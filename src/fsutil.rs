use std::path::Path;

use anyhow::{Context, Result};

#[cfg(unix)]
pub fn symlink(source: &Path, destination: &Path) -> Result<()> {
	std::os::unix::fs::symlink(source, destination)
		.with_context(|| format!("could not link {}", destination.display()))
}

#[cfg(not(unix))]
pub fn symlink(_source: &Path, _destination: &Path) -> Result<()> {
	anyhow::bail!("dot only supports unix")
}

pub fn copy_tree(from: &Path, to: &Path) -> Result<()> {
	let meta = std::fs::symlink_metadata(from)
		.with_context(|| format!("could not read {}", from.display()))?;

	if meta.file_type().is_symlink() {
		return symlink(&std::fs::read_link(from)?, to);
	}

	if meta.is_dir() {
		std::fs::create_dir_all(to)
			.with_context(|| format!("could not create {}", to.display()))?;
		for entry in std::fs::read_dir(from)? {
			let entry = entry?;
			copy_tree(&entry.path(), &to.join(entry.file_name()))?;
		}
		return Ok(());
	}

	std::fs::copy(from, to)
		.with_context(|| format!("could not copy {} to {}", from.display(), to.display()))?;
	Ok(())
}

pub fn remove(path: &Path) -> Result<()> {
	let meta = std::fs::symlink_metadata(path)
		.with_context(|| format!("could not read {}", path.display()))?;
	if meta.is_dir() {
		std::fs::remove_dir_all(path)
			.with_context(|| format!("could not remove {}", path.display()))?;
	} else {
		std::fs::remove_file(path)
			.with_context(|| format!("could not remove {}", path.display()))?;
	}
	Ok(())
}
