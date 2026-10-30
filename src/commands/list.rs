use anyhow::Result;

use crate::app::App;
use crate::installer::{self, State};
use crate::output::{bold, dim, ok, table, warn};

pub fn run(app: &App, quiet: bool) -> Result<()> {
	if app.dots.is_empty() {
		println!("{}", dim("no dots in the repo"));
		return Ok(());
	}

	if quiet {
		for dot in &app.dots {
			println!("{}", dot.name);
		}
		return Ok(());
	}

	let rows: Vec<Vec<String>> = app
		.dots
		.iter()
		.map(|dot| {
			vec![
				bold(&dot.name),
				state_label(installer::state(dot, &app.paths.config)),
				dot.description.clone().unwrap_or_else(|| "—".to_string()),
			]
		})
		.collect();

	table(&["name", "state", "description"], &rows);
	Ok(())
}

fn state_label(state: State) -> String {
	match state {
		State::Linked => ok("installed"),
		State::Missing => dim("not installed"),
		State::Foreign(path) => format!("{} {}", warn("foreign"), dim(&path.display().to_string())),
		State::Conflict => warn("conflict"),
	}
}
