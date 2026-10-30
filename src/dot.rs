use std::path::{Path, PathBuf};

use anyhow::{bail, Context, Result};
use serde::Deserialize;

#[derive(Debug, Clone)]
pub struct Dot {
	pub name: String,
	pub dir: PathBuf,
	pub description: Option<String>,
	pub install_hook: Option<String>,
}

#[derive(Debug, Default, Deserialize)]
#[serde(deny_unknown_fields)]
struct Metadata {
	#[serde(default)]
	description: Option<String>,
	#[serde(default)]
	hooks: Hooks,
}

#[derive(Debug, Default, Deserialize)]
#[serde(deny_unknown_fields)]
struct Hooks {
	#[serde(default)]
	install: Option<String>,
}

pub struct Scan {
	pub dots: Vec<Dot>,
	pub warnings: Vec<String>,
}

impl Dot {
	pub fn config(&self) -> PathBuf {
		self.dir.join("config")
	}

	pub fn target(&self, config_dir: &Path) -> PathBuf {
		config_dir.join(&self.name)
	}

	pub fn load(dir: &Path) -> Result<Self> {
		let name = dir
			.file_name()
			.and_then(|name| name.to_str())
			.with_context(|| format!("invalid dot name: {}", dir.display()))?
			.to_string();
		if !valid_name(&name) {
			bail!("invalid dot name: {name} (use [a-z0-9-])");
		}

		let metadata = read_metadata(dir)?;
		Ok(Self {
			name,
			dir: dir.to_path_buf(),
			description: metadata.description,
			install_hook: metadata.hooks.install,
		})
	}
}

fn read_metadata(dir: &Path) -> Result<Metadata> {
	let path = dir.join("metadata.yml");
	if !path.is_file() {
		return Ok(Metadata::default());
	}
	let raw = std::fs::read_to_string(&path)
		.with_context(|| format!("could not read {}", path.display()))?;
	serde_norway::from_str(&raw).with_context(|| format!("invalid YAML in {}", path.display()))
}

pub fn valid_name(name: &str) -> bool {
	let mut chars = name.chars();
	match chars.next() {
		Some(first) if first.is_ascii_lowercase() || first.is_ascii_digit() => {}
		_ => return false,
	}
	chars.all(|char| char.is_ascii_lowercase() || char.is_ascii_digit() || char == '-')
}

pub fn scan(repo: &Path) -> Result<Scan> {
	let dots_dir = repo.join("dot");
	if !dots_dir.is_dir() {
		bail!("repo has no `dot/` folder: {}", repo.display());
	}

	let mut dots = Vec::new();
	let mut warnings = Vec::new();
	let mut entries: Vec<PathBuf> = std::fs::read_dir(&dots_dir)?
		.filter_map(|entry| entry.ok())
		.map(|entry| entry.path())
		.collect();
	entries.sort();

	for dir in entries {
		if !dir.is_dir() {
			warnings.push(format!("skipped (not a directory): {}", dir.display()));
			continue;
		}
		if !dir.join("config").is_dir() {
			warnings.push(format!(
				"skipped (no config/): {}",
				dir.file_name().unwrap_or_default().to_string_lossy()
			));
			continue;
		}
		match Dot::load(&dir) {
			Ok(dot) => dots.push(dot),
			Err(err) => warnings.push(format!("{err:#}")),
		}
	}

	dots.sort_by(|left, right| left.name.cmp(&right.name));
	Ok(Scan { dots, warnings })
}

pub fn find<'a>(dots: &'a [Dot], name: &str) -> Result<&'a Dot> {
	dots.iter()
		.find(|dot| dot.name == name)
		.with_context(|| format!("no such dot `{name}` (see `dot list`)"))
}
