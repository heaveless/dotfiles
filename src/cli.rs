use clap::{Parser, Subcommand};

#[derive(Debug, Parser)]
#[command(name = "dot", version, about = "Dotfiles manager")]
pub struct Cli {
	#[command(subcommand)]
	pub command: Command,
}

#[derive(Debug, Subcommand)]
pub enum Command {
	Init {
		repo: String,
	},

	List {
		#[arg(short, long)]
		quiet: bool,
	},

	Install {
		#[arg(value_name = "DOT")]
		dots: Vec<String>,

		#[arg(long, conflicts_with = "dots")]
		all: bool,
	},

	Uninstall {
		#[arg(value_name = "DOT")]
		dots: Vec<String>,

		#[arg(long, conflicts_with = "dots")]
		all: bool,
	},

	Update,
}
