use std::path::Path;

use anyhow::{bail, Context, Result};

#[derive(Debug, PartialEq, Eq)]
pub enum Pull {
	NotACheckout,
	Updated { head: String, changed: bool },
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
	let before = head(path)?;
	git_captured(&["pull", "--ff-only"], Some(path))?;
	let after = head(path)?;
	Ok(Pull::Updated {
		changed: before != after,
		head: after,
	})
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
	command(args, cwd, false)?;
	Ok(())
}

fn git_captured(args: &[&str], cwd: Option<&Path>) -> Result<()> {
	command(args, cwd, true)?;
	Ok(())
}

fn command(args: &[&str], cwd: Option<&Path>, capture: bool) -> Result<()> {
	let mut command = duct::cmd("git", args);
	if capture {
		command = command.stdout_capture().stderr_capture();
	}
	if let Some(cwd) = cwd {
		command = command.dir(cwd);
	}
	let output = command
		.unchecked()
		.run()
		.with_context(|| format!("could not run git {}", args.join(" ")))?;
	if output.status.success() {
		return Ok(());
	}
	let detail = String::from_utf8_lossy(&output.stderr).trim().to_string();
	if detail.is_empty() {
		bail!("git {} failed", args.join(" "));
	}
	bail!("git {} failed: {detail}", args.join(" "))
}
