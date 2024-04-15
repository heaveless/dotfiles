local M = {}
local merge_tb = vim.tbl_deep_extend

M.shell_call = function(args) 
    local output = vim.fn.system(args)
    assert(vim.v.shell_error == 0, "External call failed with error code: " .. vim.v.shell_error .. "\n" .. output)
end

M.echo = function(str)
  vim.cmd "redraw"
  vim.api.nvim_echo({{ str, "Bold" }}, true, {})
end

M.load_plugins = function()
  local path = vim.fn.stdpath("config") .. "/lua/plugins"
  local ref_str = vim.fn.glob(path .. "/*.lua")
  local files = {}

  for file in ref_str:gmatch("[^%s]+") do
    table.insert(files, file)
  end

  local plugins = {}
  for _, file in ipairs(files) do
    local name = vim.fn.fnamemodify(file, ":t:r")
    if name then
      local plugin = require("plugins." .. name)
      table.insert(plugins, plugin)
    end
  end

  return plugins
end

M.load_mappings = function(section)
    vim.schedule(function()
        local mappings = require("mappings")
        mappings = { mappings[section] }

        for _, sect in pairs(mappings) do
            for mode, mode_values in pairs(sect) do
                for keybind, command in pairs(mode_values) do
                    vim.keymap.set(mode, keybind, command)
                end
            end
        end
    end)
end

return M
