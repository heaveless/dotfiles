use std::path::{Path, PathBuf};

use dot::db::{Db, RepoRef};
use dot::dot::Dot;
use dot::installer::{self, LinkOutcome, State, UnlinkOutcome};

struct Fixture {
	root: tempfile::TempDir,
	config: PathBuf,
	backups: PathBuf,
	repo: PathBuf,
}

impl Fixture {
	fn new() -> Self {
		let root = tempfile::tempdir().unwrap();
		let repo = root.path().join("repo");
		std::fs::create_dir_all(repo.join("dot/nvim/config")).unwrap();
		std::fs::write(repo.join("dot/nvim/config/init.lua"), "init").unwrap();
		let config = root.path().join("config");
		let backups = root.path().join("backups");
		Self {
			root,
			config,
			backups,
			repo,
		}
	}

	fn dot(&self) -> Dot {
		Dot::load(&self.repo.join("dot/nvim")).unwrap()
	}

	fn target(&self) -> PathBuf {
		self.config.join("nvim")
	}
}

fn link(fixture: &Fixture, dot: &Dot) -> LinkOutcome {
	installer::link(dot, &fixture.config, &fixture.backups).unwrap()
}

#[test]
fn link_creates_a_symlink_to_the_dot_config() {
	let fixture = Fixture::new();
	let dot = fixture.dot();

	assert_eq!(link(&fixture, &dot), LinkOutcome::Linked { backup: None });
	assert_eq!(installer::state(&dot, &fixture.config), State::Linked);
	assert_eq!(std::fs::read_link(fixture.target()).unwrap(), dot.config());
}

#[test]
fn link_is_idempotent() {
	let fixture = Fixture::new();
	let dot = fixture.dot();

	link(&fixture, &dot);
	assert_eq!(link(&fixture, &dot), LinkOutcome::AlreadyLinked);
}

#[test]
fn link_backs_up_a_real_directory() {
	let fixture = Fixture::new();
	let dot = fixture.dot();
	std::fs::create_dir_all(fixture.target()).unwrap();
	std::fs::write(fixture.target().join("user.conf"), "mine").unwrap();

	let LinkOutcome::Linked { backup } = link(&fixture, &dot) else {
		panic!("expected a link with backup");
	};
	let backup = backup.expect("backup path");
	assert_eq!(
		std::fs::read_to_string(backup.join("user.conf")).unwrap(),
		"mine"
	);
	assert_eq!(installer::state(&dot, &fixture.config), State::Linked);
}

#[test]
fn link_replaces_a_foreign_symlink() {
	let fixture = Fixture::new();
	let dot = fixture.dot();
	std::fs::create_dir_all(&fixture.config).unwrap();
	let elsewhere = fixture.root.path().join("elsewhere");
	std::fs::create_dir_all(&elsewhere).unwrap();
	std::os::unix::fs::symlink(&elsewhere, fixture.target()).unwrap();

	assert_eq!(
		installer::state(&dot, &fixture.config),
		State::Foreign(elsewhere)
	);

	let LinkOutcome::Linked { backup } = link(&fixture, &dot) else {
		panic!("expected a link with backup");
	};
	assert!(backup.is_some());
	assert_eq!(installer::state(&dot, &fixture.config), State::Linked);
}

#[test]
fn unlink_removes_only_our_link() {
	let fixture = Fixture::new();
	let dot = fixture.dot();
	link(&fixture, &dot);

	assert_eq!(
		installer::unlink(&dot, &fixture.config).unwrap(),
		UnlinkOutcome::Unlinked
	);
	assert!(!fixture.target().exists());
	assert_eq!(installer::state(&dot, &fixture.config), State::Missing);
}

#[test]
fn unlink_leaves_foreign_links_alone() {
	let fixture = Fixture::new();
	let dot = fixture.dot();
	std::fs::create_dir_all(&fixture.config).unwrap();
	let elsewhere = fixture.root.path().join("elsewhere");
	std::fs::create_dir_all(&elsewhere).unwrap();
	std::os::unix::fs::symlink(&elsewhere, fixture.target()).unwrap();

	assert_eq!(
		installer::unlink(&dot, &fixture.config).unwrap(),
		UnlinkOutcome::Foreign(elsewhere)
	);
	assert!(fixture.target().exists());
}

#[test]
fn unlink_leaves_real_directories_alone() {
	let fixture = Fixture::new();
	let dot = fixture.dot();
	std::fs::create_dir_all(fixture.target()).unwrap();

	assert_eq!(
		installer::unlink(&dot, &fixture.config).unwrap(),
		UnlinkOutcome::Conflict
	);
	assert!(fixture.target().is_dir());
}

#[test]
fn unlink_when_missing_is_a_no_op() {
	let fixture = Fixture::new();
	assert_eq!(
		installer::unlink(&fixture.dot(), &fixture.config).unwrap(),
		UnlinkOutcome::NotInstalled
	);
}

#[test]
fn backup_names_never_collide() {
	let fixture = Fixture::new();
	let dot = fixture.dot();

	std::fs::create_dir_all(fixture.target()).unwrap();
	std::fs::write(fixture.target().join("first"), "one").unwrap();
	link(&fixture, &dot);

	std::fs::remove_file(fixture.target()).unwrap();
	std::fs::create_dir_all(fixture.target()).unwrap();
	std::fs::write(fixture.target().join("second"), "two").unwrap();
	let LinkOutcome::Linked { backup } = link(&fixture, &dot) else {
		panic!("expected a link with backup");
	};
	let backup = backup.expect("backup path");
	assert!(backup.join("second").is_file());
	assert!(fixture.backups.join("nvim").join("first").is_file());
}

#[test]
fn db_roundtrip() {
	let dir = tempfile::tempdir().unwrap();
	let db = Db::open(&dir.path().join("dot.db")).unwrap();
	assert!(db.repo().unwrap().is_none());

	let repo = RepoRef {
		url: "https://example.com/dotfiles.git".to_string(),
		path: dir.path().join("repo"),
	};
	db.set_repo(&repo).unwrap();

	let loaded = db.repo().unwrap().unwrap();
	assert_eq!(loaded.url, repo.url);
	assert_eq!(loaded.path, repo.path);

	assert!(db.installed().unwrap().is_empty());
	db.record(
		"nvim",
		Path::new("/repo/dot/nvim/config"),
		Path::new("/home/user/.config/nvim"),
	)
	.unwrap();
	assert_eq!(db.installed().unwrap(), vec!["nvim".to_string()]);

	db.forget("nvim").unwrap();
	assert!(db.installed().unwrap().is_empty());
}
