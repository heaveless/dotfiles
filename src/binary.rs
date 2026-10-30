use std::path::{Path, PathBuf};

use anyhow::{bail, Context, Result};

#[derive(Debug, PartialEq, Eq)]
pub enum Rebuild {
	Replaced(PathBuf),
	BuiltOnly(PathBuf),
}

pub fn rebuild(repo: &Path) -> Result<Rebuild> {
	if !repo.join("Cargo.toml").is_file() {
		bail!(
			"repo has no Cargo.toml, cannot build the CLI: {}",
			repo.display()
		);
	}

	duct::cmd("cargo", ["build", "--release"])
		.dir(repo)
		.run()
		.context("cargo build failed")?;

	let built = repo.join("target").join("release").join("dot");
	let current = std::env::current_exe().context("could not resolve the current binary")?;

	if runs_from_target(&current) {
		return Ok(Rebuild::BuiltOnly(built));
	}

	replace(&built, &current)?;
	Ok(Rebuild::Replaced(current))
}

fn runs_from_target(binary: &Path) -> bool {
	binary
		.components()
		.any(|component| component.as_os_str() == "target")
}

fn replace(built: &Path, current: &Path) -> Result<()> {
	let staged = staging_path(current)?;
	std::fs::copy(built, &staged)
		.with_context(|| format!("could not write {}", staged.display()))?;
	set_executable(&staged)?;

	if let Err(err) = std::fs::rename(&staged, current) {
		let _ = std::fs::remove_file(&staged);
		return Err(err).with_context(|| format!("could not replace {}", current.display()));
	}
	Ok(())
}

fn staging_path(current: &Path) -> Result<PathBuf> {
	let name = current
		.file_name()
		.with_context(|| format!("{} has no file name", current.display()))?;
	let mut staged = name.to_os_string();
	staged.push(".new");
	Ok(current.with_file_name(staged))
}

#[cfg(unix)]
fn set_executable(path: &Path) -> Result<()> {
	use std::os::unix::fs::PermissionsExt;
	let mode = std::fs::metadata(path)?.permissions().mode();
	std::fs::set_permissions(path, std::fs::Permissions::from_mode(mode | 0o755))
		.with_context(|| format!("could not chmod {}", path.display()))
}

#[cfg(not(unix))]
fn set_executable(_path: &Path) -> Result<()> {
	Ok(())
}
