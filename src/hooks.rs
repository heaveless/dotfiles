use std::path::Path;

use anyhow::{Context, Result};

pub fn run(command: &str, cwd: &Path) -> Result<()> {
	duct::cmd("sh", ["-c", command])
		.dir(cwd)
		.run()
		.with_context(|| format!("hook failed: {command}"))?;
	Ok(())
}
