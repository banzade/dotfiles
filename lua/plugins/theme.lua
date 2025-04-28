-- lua/plugins/theme.lua

return {
    "folke/tokyonight.nvim", -- this downloads the theme plugin
    lazy = false,            -- load immediately
    priority = 1000,         -- load before other plugins
  
    config = function()
      vim.opt.termguicolors = true
      vim.opt.background = "dark"
  
      -- Tokyonight setup (optional settings, you can customize)
      require("tokyonight").setup({
        style = "storm",     -- "storm", "moon", "night", "day"
        transparent = false, -- no transparent background
      })
  
      -- Set colorscheme
      local ok, _ = pcall(vim.cmd, "colorscheme tokyonight")
      if not ok then
        vim.notify("Colorscheme tokyonight not found!", vim.log.levels.WARN)
      end
    end,
  }
  