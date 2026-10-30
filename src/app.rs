use anyhow::{bail, Result};

use crate::db::{Db, RepoRef};
use crate::dot::{self, Dot};
use crate::paths::Paths;

pub struct App {
	pub paths: Paths,
	pub db: Db,
	pub repo: RepoRef,
	pub dots: Vec<Dot>,
	pub warnings: Vec<String>,
}

impl App {
	pub fn load(paths: &Paths) -> Result<Self> {
		let db = Db::open(&paths.db())?;
		let Some(repo) = db.repo()? else {
			bail!("no repo configured; run `dot init <repo>`");
		};
		if !repo.path.is_dir() {
			bail!(
				"configured repo does not exist ({}); run `dot init {}`",
				repo.path.display(),
				repo.url
			);
		}
		let scan = dot::scan(&repo.path)?;
		Ok(Self {
			paths: paths.clone(),
			db,
			repo,
			dots: scan.dots,
			warnings: scan.warnings,
		})
	}

	pub fn select(&self, names: &[String], all: bool) -> Result<Vec<&Dot>> {
		if all {
			return Ok(self.dots.iter().collect());
		}
		if names.is_empty() {
			bail!("name one or more dots, or use --all");
		}
		names
			.iter()
			.map(|name| dot::find(&self.dots, name))
			.collect()
	}
}
