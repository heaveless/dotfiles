use anyhow::{Context, Result};

use crate::db::{Db, RepoRef};
use crate::dot;
use crate::output::{dim, info, ok, warn};
use crate::paths::Paths;
use crate::repo;

pub fn run(paths: &Paths, spec: &str) -> Result<()> {
	let db = Db::open(&paths.db())?;
	let repo = resolve(paths, spec)?;
	let scan = dot::scan(&repo.path)?;

	db.set_repo(&repo)?;

	println!("{} repo set to {}", ok("✓"), repo.path.display());
	for warning in &scan.warnings {
		eprintln!("{} {warning}", warn("!"));
	}

	let names: Vec<&str> = scan.dots.iter().map(|dot| dot.name.as_str()).collect();
	println!(
		"{} {} dot(s) available: {}",
		info("·"),
		scan.dots.len(),
		if names.is_empty() {
			dim("none")
		} else {
			dim(&names.join(", "))
		}
	);
	println!("{} run `dot install --all`", dim("→"));
	Ok(())
}

fn resolve(paths: &Paths, spec: &str) -> Result<RepoRef> {
	let candidate = paths.expand(spec);
	if candidate.join("dot").is_dir() {
		println!("{} using local checkout {}", info("→"), candidate.display());
		return Ok(RepoRef {
			url: spec.to_string(),
			path: candidate
				.canonicalize()
				.with_context(|| format!("could not resolve {}", candidate.display()))?,
		});
	}

	let destination = paths.repo();
	if repo::is_checkout(&destination) {
		println!("{} repo already cloned, updating", dim("·"));
	} else {
		println!("{} cloning {}", info("→"), spec);
	}
	repo::clone_into(spec, &destination)?;

	Ok(RepoRef {
		url: spec.to_string(),
		path: destination,
	})
}
