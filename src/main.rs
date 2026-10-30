use clap::Parser;
use dot::app::App;
use dot::cli::{Cli, Command};
use dot::paths::Paths;
use dot::{commands, output};

fn main() {
	reset_sigpipe();
	let cli = Cli::parse();
	if let Err(err) = run(cli) {
		eprintln!("{} {err:#}", output::err_prefix());
		std::process::exit(1);
	}
}

fn run(cli: Cli) -> anyhow::Result<()> {
	let paths = Paths::resolve();

	match cli.command {
		Command::Init { repo } => commands::init::run(&paths, &repo),
		Command::List { quiet } => commands::list::run(&load(&paths)?, quiet),
		Command::Install { dots, all } => commands::install::run(&load(&paths)?, &dots, all),
		Command::Uninstall { dots, all } => commands::uninstall::run(&load(&paths)?, &dots, all),
		Command::Update => commands::update::run(&load(&paths)?),
	}
}

fn load(paths: &Paths) -> anyhow::Result<App> {
	let app = App::load(paths)?;
	output::warnings(&app.warnings);
	Ok(app)
}

#[cfg(unix)]
fn reset_sigpipe() {
	unsafe {
		libc::signal(libc::SIGPIPE, libc::SIG_DFL);
	}
}

#[cfg(not(unix))]
fn reset_sigpipe() {}
