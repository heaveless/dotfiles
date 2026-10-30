use std::path::Path;

use dot::dot::{scan, valid_name};

fn write(path: impl AsRef<Path>, contents: &str) {
	let path = path.as_ref();
	if let Some(parent) = path.parent() {
		std::fs::create_dir_all(parent).unwrap();
	}
	std::fs::write(path, contents).unwrap();
}

fn repo_with(dots: &[(&str, Option<&str>)]) -> tempfile::TempDir {
	let dir = tempfile::tempdir().unwrap();
	for (name, metadata) in dots {
		std::fs::create_dir_all(dir.path().join("dot").join(name).join("config")).unwrap();
		if let Some(metadata) = metadata {
			write(
				dir.path().join("dot").join(name).join("metadata.yml"),
				metadata,
			);
		}
	}
	dir
}

#[test]
fn scans_every_dot_with_a_config_folder() {
	let dir = repo_with(&[
		("nvim", Some("description: Neovim\n")),
		("shell", None),
		("broken", None),
	]);
	std::fs::remove_dir_all(dir.path().join("dot/broken/config")).unwrap();

	let scan = scan(dir.path()).unwrap();
	let names: Vec<&str> = scan.dots.iter().map(|dot| dot.name.as_str()).collect();
	assert_eq!(names, vec!["nvim", "shell"]);
	assert_eq!(scan.warnings.len(), 1);
	assert!(scan.warnings[0].contains("broken"));
}

#[test]
fn repo_without_dot_folder_is_an_error() {
	let dir = tempfile::tempdir().unwrap();
	assert!(scan(dir.path()).is_err());
}

#[test]
fn metadata_is_optional() {
	let dir = repo_with(&[("shell", None)]);
	let scan = scan(dir.path()).unwrap();
	assert_eq!(scan.dots[0].name, "shell");
	assert_eq!(scan.dots[0].description, None);
	assert_eq!(scan.dots[0].install_hook, None);
	assert!(scan.warnings.is_empty());
}

#[test]
fn install_hook_is_read() {
	let dir = repo_with(&[(
		"nvim",
		Some("description: Neovim\nhooks:\n  install: ./scripts/setup.sh\n"),
	)]);
	let scan = scan(dir.path()).unwrap();
	assert_eq!(
		scan.dots[0].install_hook.as_deref(),
		Some("./scripts/setup.sh")
	);
}

#[test]
fn unknown_metadata_keys_are_rejected() {
	let dir = repo_with(&[("typo", Some("hook: echo hi\n"))]);
	let scan = scan(dir.path()).unwrap();
	assert!(scan.dots.is_empty());
	assert!(
		scan.warnings[0].contains("unknown field `hook`"),
		"{:?}",
		scan.warnings
	);
}

#[test]
fn invalid_names_are_rejected() {
	let dir = repo_with(&[("Bad_Name", Some("description: x\n"))]);
	let scan = scan(dir.path()).unwrap();
	assert!(scan.dots.is_empty());
	assert!(
		scan.warnings[0].contains("invalid dot name"),
		"{:?}",
		scan.warnings
	);
}

#[test]
fn name_rules() {
	for valid in ["nvim", "shell", "pi-nvim", "0day", "a"] {
		assert!(valid_name(valid), "{valid} should be valid");
	}
	for invalid in ["Nvim", "nvim_lua", "-nvim", "nvim/", "", "nvim lua"] {
		assert!(!valid_name(invalid), "{invalid} should be invalid");
	}
}
