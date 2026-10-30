use std::path::{Path, PathBuf};

#[derive(Debug, Clone)]
pub struct Paths {
	pub home: PathBuf,
	pub data: PathBuf,
	pub config: PathBuf,
}

impl Paths {
	pub fn resolve() -> Self {
		let home = etcetera::home_dir().expect("could not determine $HOME");
		let data = env_path("XDG_DATA_HOME")
			.unwrap_or_else(|| home.join(".local").join("share"))
			.join("dot");
		let config = env_path("XDG_CONFIG_HOME").unwrap_or_else(|| home.join(".config"));
		Self { home, data, config }
	}

	pub fn db(&self) -> PathBuf {
		self.data.join("dot.db")
	}

	pub fn repo(&self) -> PathBuf {
		self.data.join("repo")
	}

	pub fn backups(&self) -> PathBuf {
		let stamp = std::time::SystemTime::now()
			.duration_since(std::time::UNIX_EPOCH)
			.map(|elapsed| elapsed.as_secs())
			.unwrap_or(0);
		self.data.join("backups").join(stamp.to_string())
	}

	pub fn expand(&self, spec: &str) -> PathBuf {
		match spec.strip_prefix("~/") {
			Some(rest) => self.home.join(rest),
			None => PathBuf::from(spec),
		}
	}

	pub fn display(&self, path: &Path) -> String {
		match path.strip_prefix(&self.home) {
			Ok(relative) => format!("~/{}", relative.display()),
			Err(_) => path.display().to_string(),
		}
	}
}

fn env_path(key: &str) -> Option<PathBuf> {
	std::env::var_os(key)
		.filter(|value| !value.is_empty())
		.map(PathBuf::from)
}
