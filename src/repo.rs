use std::path::Path;

use anyhow::{bail, Context, Result};

#[derive(Debug, PartialEq, Eq)]
pub enum Pull {
	NotACheckout,
	Updated(String),
}

pub fn is_checkout(path: &Path) -> bool {
	path.join(".git").is_dir()
}

pub fn clone_into(spec: &str, destination: &Path) -> Result<()> {
	if let Some(parent) = destination.parent() {
		std::fs::create_dir_all(parent)
			.with_context(|| format!("could not create {}", parent.display()))?;
	}
	git(
		&[
			"clone",
			"--depth",
			"1",
			spec,
			&destination.display().to_string(),
		],
		None,
	)
}

pub fn pull(path: &Path) -> Result<Pull> {
	if !is_checkout(path) {
		return Ok(Pull::NotACheckout);
	}
	git(&["pull", "--ff-only"], Some(path))?;
	Ok(Pull::Updated(head(path)?))
}

fn head(path: &Path) -> Result<String> {
	let raw = duct::cmd(
		"git",
		[
			"-C",
			&path.display().to_string(),
			"rev-parse",
			"--short",
			"HEAD",
		],
	)
	.read()
	.context("git rev-parse failed")?;
	Ok(raw.trim().to_string())
}

fn git(args: &[&str], cwd: Option<&Path>) -> Result<()> {
	let mut command = duct::cmd("git", args);
	if let Some(cwd) = cwd {
		command = command.dir(cwd);
	}
	let output = command
		.unchecked()
		.run()
		.with_context(|| format!("could not run git {}", args.join(" ")))?;
	if !output.status.success() {
		bail!("git {} failed", args.join(" "));
	}
	Ok(())
}
