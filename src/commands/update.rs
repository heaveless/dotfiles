use anyhow::Result;

use crate::app::App;
use crate::binary::{self, Rebuild};
use crate::output::{dim, info, ok};
use crate::repo::{self, Pull};

pub fn run(app: &App) -> Result<()> {
	println!("{} git pull --ff-only", info("→"));
	match repo::pull(&app.repo.path)? {
		Pull::NotACheckout => println!(
			"{} not a git checkout, skipping pull ({})",
			dim("·"),
			app.repo.path.display()
		),
		Pull::Updated(head) => println!("{} repo at {head}", ok("✓")),
	}

	println!("{} cargo build --release", info("→"));
	match binary::rebuild(&app.repo.path)? {
		Rebuild::Replaced(path) => println!("{} binary updated at {}", ok("✓"), path.display()),
		Rebuild::BuiltOnly(path) => println!(
			"{} running from target/, not replacing the binary. Built at {}",
			dim("·"),
			path.display()
		),
	}

	println!("{} dot {} ready", ok("✓"), env!("CARGO_PKG_VERSION"));
	Ok(())
}
