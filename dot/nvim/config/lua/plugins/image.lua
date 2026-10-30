return {
	"3rd/image.nvim",
	lazy = true,
	build = false,
	opts = {
		backend = "kitty",
		processor = "magick_cli",
		window_overlap_clear_enabled = true,
		max_width_window_percentage = 100,
		max_height_window_percentage = 90,
		scale_factor = 1.0,
		integrations = {
			markdown = { enabled = true, only_render_image_at_cursor = true },
			neorg = { enabled = true },
			html = { enabled = true },
		},
	},
}
