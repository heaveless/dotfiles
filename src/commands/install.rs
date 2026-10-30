use anyhow::Result;

use crate::app::App;
use crate::dot::Dot;
use crate::hooks;
use crate::installer::{self, LinkOutcome};
use crate::output::{bold, dim, info, ok};

pub fn run(app: &App, names: &[String], all: bool) -> Result<()> {
	let selected = app.select(names, all)?;
	if selected.is_empty() {
		println!("{}", dim("no dots in the repo"));
		return Ok(());
	}

	let backups = app.paths.backups();
	let mut linked = 0;

	for dot in selected {
		println!("{}", bold(&dot.name));

		match installer::link(dot, &app.paths.config, &backups)? {
			LinkOutcome::AlreadyLinked => {
				println!("  {}", dim("already installed"));
				continue;
			}
			LinkOutcome::Linked { backup } => {
				if let Some(path) = backup {
					println!("  {} backup → {}", info("↷"), app.paths.display(&path));
				}
				let target = dot.target(&app.paths.config);
				println!(
					"  {} link {} → {}",
					info("→"),
					app.paths.display(&target),
					app.paths.display(&dot.config())
				);
				run_hook(dot)?;
				app.db.record(&dot.name, &dot.config(), &target)?;
				linked += 1;
			}
		}
	}

	println!("{} {linked} dot(s) installed", ok("✓"));
	Ok(())
}

fn run_hook(dot: &Dot) -> Result<()> {
	let Some(command) = &dot.install_hook else {
		return Ok(());
	};
	println!("  {} {}", info("$"), dim(command));
	hooks::run(command, &dot.dir)
}
