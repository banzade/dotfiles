return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, but recommended
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- optional image support
  },
  lazy = false, -- load immediately; you can change to "VeryLazy" if you want
  opts = {
    -- Neo-tree config options
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
      },
    },
  },
}

