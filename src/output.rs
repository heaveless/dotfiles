use std::io::IsTerminal;

fn color() -> bool {
	std::env::var_os("NO_COLOR").is_none() && std::io::stdout().is_terminal()
}

fn paint(text: &str, style: anstyle::Style) -> String {
	if !color() {
		return text.to_string();
	}
	format!("{}{}{}", style.render(), text, style.render_reset())
}

fn style(color: anstyle::AnsiColor) -> anstyle::Style {
	anstyle::Style::new().fg_color(Some(color.into()))
}

pub fn ok(text: &str) -> String {
	paint(text, style(anstyle::AnsiColor::Green))
}

pub fn bad(text: &str) -> String {
	paint(text, style(anstyle::AnsiColor::Red))
}

pub fn warn(text: &str) -> String {
	paint(text, style(anstyle::AnsiColor::Yellow))
}

pub fn info(text: &str) -> String {
	paint(text, style(anstyle::AnsiColor::Cyan))
}

pub fn dim(text: &str) -> String {
	paint(text, anstyle::Style::new().dimmed())
}

pub fn bold(text: &str) -> String {
	paint(text, anstyle::Style::new().bold())
}

pub fn err_prefix() -> String {
	bad("dot:")
}

pub fn warnings(warnings: &[String]) {
	for warning in warnings {
		eprintln!("{} {warning}", warn("!"));
	}
}

fn visible_len(text: &str) -> usize {
	let mut len = 0;
	let mut escape = false;
	for character in text.chars() {
		if escape {
			if character == 'm' {
				escape = false;
			}
			continue;
		}
		if character == '\u{1b}' {
			escape = true;
			continue;
		}
		len += 1;
	}
	len
}

fn pad(text: &str, width: usize) -> String {
	let missing = width.saturating_sub(visible_len(text));
	format!("{text}{}", " ".repeat(missing))
}

pub fn table(headers: &[&str], rows: &[Vec<String>]) {
	if rows.is_empty() {
		return;
	}

	let widths: Vec<usize> = headers
		.iter()
		.enumerate()
		.map(|(index, header)| {
			rows.iter()
				.map(|row| visible_len(&row[index]))
				.chain(std::iter::once(header.chars().count()))
				.max()
				.unwrap_or(0)
		})
		.collect();

	let header: Vec<String> = headers
		.iter()
		.enumerate()
		.map(|(index, header)| pad(&bold(&header.to_uppercase()), widths[index]))
		.collect();
	println!("{}", header.join("  ").trim_end());

	for row in rows {
		let cells: Vec<String> = row
			.iter()
			.enumerate()
			.map(|(index, cell)| pad(cell, widths[index]))
			.collect();
		println!("{}", cells.join("  ").trim_end());
	}
}
