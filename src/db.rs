use std::path::{Path, PathBuf};

use anyhow::{Context, Result};
use rusqlite::{params, Connection, OptionalExtension};

pub struct Db {
	conn: Connection,
}

#[derive(Debug, Clone)]
pub struct RepoRef {
	pub url: String,
	pub path: PathBuf,
}

impl Db {
	pub fn open(path: &Path) -> Result<Self> {
		if let Some(parent) = path.parent() {
			std::fs::create_dir_all(parent)
				.with_context(|| format!("could not create {}", parent.display()))?;
		}
		let conn =
			Connection::open(path).with_context(|| format!("could not open {}", path.display()))?;
		conn.execute_batch(
			"PRAGMA journal_mode = WAL;
			CREATE TABLE IF NOT EXISTS meta (
				key   TEXT PRIMARY KEY,
				value TEXT NOT NULL
			);
			CREATE TABLE IF NOT EXISTS dots (
				name         TEXT PRIMARY KEY,
				source       TEXT NOT NULL,
				target       TEXT NOT NULL,
				installed_at TEXT NOT NULL DEFAULT (datetime('now'))
			);",
		)?;
		Ok(Self { conn })
	}

	pub fn repo(&self) -> Result<Option<RepoRef>> {
		let url = self.meta("repo_url")?;
		let path = self.meta("repo_path")?;
		Ok(match (url, path) {
			(Some(url), Some(path)) => Some(RepoRef {
				url,
				path: PathBuf::from(path),
			}),
			_ => None,
		})
	}

	pub fn set_repo(&self, repo: &RepoRef) -> Result<()> {
		self.set_meta("repo_url", &repo.url)?;
		self.set_meta("repo_path", &repo.path.display().to_string())
	}

	pub fn installed(&self) -> Result<Vec<String>> {
		let mut statement = self.conn.prepare("SELECT name FROM dots ORDER BY name")?;
		let rows = statement.query_map([], |row| row.get(0))?;
		Ok(rows.collect::<rusqlite::Result<Vec<String>>>()?)
	}

	pub fn record(&self, name: &str, source: &Path, target: &Path) -> Result<()> {
		self.conn.execute(
			"INSERT INTO dots (name, source, target) VALUES (?1, ?2, ?3)
			 ON CONFLICT(name) DO UPDATE SET
				source = excluded.source,
				target = excluded.target,
				installed_at = datetime('now')",
			params![
				name,
				source.display().to_string(),
				target.display().to_string()
			],
		)?;
		Ok(())
	}

	pub fn forget(&self, name: &str) -> Result<()> {
		self.conn
			.execute("DELETE FROM dots WHERE name = ?1", [name])?;
		Ok(())
	}

	fn meta(&self, key: &str) -> Result<Option<String>> {
		Ok(self
			.conn
			.query_row("SELECT value FROM meta WHERE key = ?1", [key], |row| {
				row.get(0)
			})
			.optional()?)
	}

	fn set_meta(&self, key: &str, value: &str) -> Result<()> {
		self.conn.execute(
			"INSERT INTO meta (key, value) VALUES (?1, ?2)
			 ON CONFLICT(key) DO UPDATE SET value = excluded.value",
			params![key, value],
		)?;
		Ok(())
	}
}
