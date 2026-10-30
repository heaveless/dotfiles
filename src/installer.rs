use std::path::{Path, PathBuf};

use anyhow::{Context, Result};

use crate::dot::Dot;
use crate::fsutil;

#[derive(Debug, PartialEq, Eq)]
pub enum State {
	Linked,
	Missing,
	Foreign(PathBuf),
	Conflict,
}

#[derive(Debug, PartialEq, Eq)]
pub enum LinkOutcome {
	AlreadyLinked,
	Linked { backup: Option<PathBuf> },
}

#[derive(Debug, PartialEq, Eq)]
pub enum UnlinkOutcome {
	Unlinked,
	NotInstalled,
	Foreign(PathBuf),
	Conflict,
}

pub fn state(dot: &Dot, config_dir: &Path) -> State {
	let target = dot.target(config_dir);
	let Ok(meta) = std::fs::symlink_metadata(&target) else {
		return State::Missing;
	};
	if !meta.file_type().is_symlink() {
		return State::Conflict;
	}
	let Ok(destination) = std::fs::read_link(&target) else {
		return State::Conflict;
	};
	let destination = absolute(&target, destination);
	if destination == dot.config() {
		State::Linked
	} else {
		State::Foreign(destination)
	}
}

fn absolute(link: &Path, destination: PathBuf) -> PathBuf {
	if destination.is_absolute() {
		return destination;
	}
	match link.parent() {
		Some(parent) => parent.join(destination),
		None => destination,
	}
}

pub fn link(dot: &Dot, config_dir: &Path, backups: &Path) -> Result<LinkOutcome> {
	let target = dot.target(config_dir);
	let backup = match state(dot, config_dir) {
		State::Linked => return Ok(LinkOutcome::AlreadyLinked),
		State::Missing => None,
		State::Foreign(_) | State::Conflict => Some(move_aside(&target, backups)?),
	};

	if let Some(parent) = target.parent() {
		std::fs::create_dir_all(parent)
			.with_context(|| format!("could not create {}", parent.display()))?;
	}
	fsutil::symlink(&dot.config(), &target)?;

	Ok(LinkOutcome::Linked { backup })
}

pub fn unlink(dot: &Dot, config_dir: &Path) -> Result<UnlinkOutcome> {
	let target = dot.target(config_dir);
	match state(dot, config_dir) {
		State::Linked => {
			std::fs::remove_file(&target)
				.with_context(|| format!("could not remove {}", target.display()))?;
			Ok(UnlinkOutcome::Unlinked)
		}
		State::Missing => Ok(UnlinkOutcome::NotInstalled),
		State::Foreign(path) => Ok(UnlinkOutcome::Foreign(path)),
		State::Conflict => Ok(UnlinkOutcome::Conflict),
	}
}

fn move_aside(target: &Path, backups: &Path) -> Result<PathBuf> {
	let name = target
		.file_name()
		.with_context(|| format!("{} has no file name", target.display()))?;
	let destination = free_path(backups.join(name));

	if let Some(parent) = destination.parent() {
		std::fs::create_dir_all(parent)
			.with_context(|| format!("could not create {}", parent.display()))?;
	}

	match std::fs::rename(target, &destination) {
		Ok(()) => Ok(destination),
		Err(_) => {
			fsutil::copy_tree(target, &destination)?;
			fsutil::remove(target)?;
			Ok(destination)
		}
	}
}

fn free_path(path: PathBuf) -> PathBuf {
	if std::fs::symlink_metadata(&path).is_err() {
		return path;
	}
	let parent = path.parent().unwrap_or(Path::new(".")).to_path_buf();
	let name = path
		.file_name()
		.map(|name| name.to_string_lossy().to_string())
		.unwrap_or_default();
	let mut index = 2;
	loop {
		let candidate = parent.join(format!("{name}-{index}"));
		if std::fs::symlink_metadata(&candidate).is_err() {
			return candidate;
		}
		index += 1;
	}
}
