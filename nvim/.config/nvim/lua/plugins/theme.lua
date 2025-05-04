-- lua/plugins/theme.lua

return {
  "craftzdog/solarized-osaka.nvim", -- Plugin for Solarized Osaka theme
  lazy = false,                     -- Load immediately
  priority = 1000,                  -- Load first

  config = function()
    vim.opt.termguicolors = true
    vim.opt.background = "dark"     -- dark or light

    -- Optional: configure Solarized Osaka
    require("solarized-osaka").setup({
      transparent = false, -- true to disable background color
      styles = {
        comments = { italic = true },
        keywords = { italic = false },
        functions = { bold = true },
        variables = {},
      },
    })

    -- Set colorscheme
    local ok, _ = pcall(vim.cmd, "colorscheme solarized-osaka")
    if not ok then
      vim.notify("Colorscheme solarized-osaka not found!", vim.log.levels.WARN)
    end
  end,
}

