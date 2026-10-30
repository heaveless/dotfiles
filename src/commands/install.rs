use anyhow::Result;

use crate::app::App;
use crate::dot::Dot;
use crate::hooks;
use crate::installer::{self, LinkOutcome};
use crate::output::{bold, dim, info, ok, warn};
use crate::repo::{self, Pull};

pub fn run(app: &App, names: &[String], all: bool) -> Result<()> {
	let (app, synced) = refresh(app)?;
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
				println!(
					"  {}",
					dim(match synced {
						true => "already installed, up to date",
						false => "already installed, repo not updated",
					})
				);
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

fn refresh(app: &App) -> Result<(App, bool)> {
	let mut synced = true;
	match repo::pull(&app.repo.path) {
		Ok(Pull::Updated {
			head,
			changed: true,
		}) => {
			println!("{} repo updated to {head}", ok("✓"));
		}
		Ok(Pull::Updated { .. } | Pull::NotACheckout) => {}
		Err(err) => {
			synced = false;
			eprintln!("{} could not update the repo: {err:#}", warn("!"));
		}
	}
	let app = App::load(&app.paths)?;
	crate::output::warnings(&app.warnings);
	Ok((app, synced))
}

fn run_hook(dot: &Dot) -> Result<()> {
	let Some(command) = &dot.install_hook else {
		return Ok(());
	};
	println!("  {} {}", info("$"), dim(command));
	hooks::run(command, &dot.dir)
}
