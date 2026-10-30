use anyhow::Result;

use crate::app::App;
use crate::dot::Dot;
use crate::installer::{self, UnlinkOutcome};
use crate::output::{bold, dim, info, ok, warn};

pub fn run(app: &App, names: &[String], all: bool) -> Result<()> {
	let mut selected: Vec<Dot> = app.select(names, all)?.into_iter().cloned().collect();

	if all {
		selected.extend(forgotten(app, &selected)?);
	}

	if selected.is_empty() {
		println!("{}", dim("no dots to uninstall"));
		return Ok(());
	}

	let mut removed = 0;
	for dot in &selected {
		let target = dot.target(&app.paths.config);
		println!("{}", bold(&dot.name));

		match installer::unlink(dot, &app.paths.config)? {
			UnlinkOutcome::Unlinked => {
				println!("  {} unlink {}", info("-"), app.paths.display(&target));
				removed += 1;
			}
			UnlinkOutcome::NotInstalled => println!("  {}", dim("not installed")),
			UnlinkOutcome::Foreign(path) => println!(
				"  {} {} points to {}, leaving it alone",
				warn("!"),
				app.paths.display(&target),
				path.display()
			),
			UnlinkOutcome::Conflict => println!(
				"  {} {} is a real directory",
				warn("!"),
				app.paths.display(&target)
			),
		}

		app.db.forget(&dot.name)?;
	}

	println!("{} {removed} link(s) removed", ok("✓"));
	Ok(())
}

fn forgotten(app: &App, selected: &[Dot]) -> Result<Vec<Dot>> {
	let mut extra = Vec::new();
	for name in app.db.installed()? {
		if selected.iter().any(|dot| dot.name == name) {
			continue;
		}
		let dir = app.repo.path.join("dot").join(&name);
		if let Ok(dot) = Dot::load(&dir) {
			extra.push(dot);
		}
	}
	Ok(extra)
}
