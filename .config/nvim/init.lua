vim.opt.clipboard = "unnamedplus"

-- Set leader key to space (important to set this early)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic Settings
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Relative line numbers
vim.opt.mouse = 'a'             -- Enable mouse
vim.opt.ignorecase = true       -- Case insensitive search
vim.opt.smartcase = true        -- Unless capital letters used
vim.opt.hlsearch = false        -- Don't highlight searches
vim.opt.wrap = false            -- Don't wrap lines
vim.opt.breakindent = true      -- Wrapped lines indent
vim.opt.tabstop = 2             -- 2 spaces for tabs
vim.opt.shiftwidth = 2          -- 2 spaces for indents
vim.opt.expandtab = true        -- Use spaces instead of tabs
vim.opt.termguicolors = true    -- True color support
vim.opt.signcolumn = "yes"      -- Always show sign column
vim.opt.updatetime = 250        -- Faster completion
vim.opt.timeoutlen = 300        -- Faster key sequence completion
vim.opt.splitright = true       -- Vertical splits go right
vim.opt.splitbelow = true       -- Horizontal splits go below

-- Install lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin Setup
require("lazy").setup({
  -- Color scheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()
    end,
  },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdate", "TSInstall" },
    config = function()
      -- Ensure the module is available before configuring
      local status_ok, configs = pcall(require, "nvim-treesitter.configs")
      if not status_ok then
        vim.notify("nvim-treesitter.configs not loaded yet, will retry", vim.log.levels.WARN)
        return
      end

      configs.setup({
        ensure_installed = { 
          "javascript", 
          "typescript", 
          "svelte", 
          "html", 
          "css", 
          "json",
          "lua",
          "vim",
          "markdown",
          "markdown_inline",
        },
        sync_install = false,
        auto_install = true,
        highlight = { 
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })
    end,
  },

  -- Mason for LSP server management
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { 
          "svelte", 
          "ts_ls",  -- TypeScript
          "eslint",
          "html",
          "cssls"
        },
        automatic_installation = true,
      })
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Check if new API is available (Neovim 0.11+)
      if vim.lsp.config then
        -- New API (Neovim 0.11+)
        vim.lsp.config('svelte', {
          cmd = { 'svelteserver', '--stdio' },
          filetypes = { 'svelte' },
          root_markers = { 'package.json', '.git' },
          capabilities = capabilities,
        })

        vim.lsp.config('ts_ls', {
          cmd = { 'typescript-language-server', '--stdio' },
          filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
          root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
          capabilities = capabilities,
        })

        vim.lsp.config('eslint', {
          cmd = { 'vscode-eslint-language-server', '--stdio' },
          filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte' },
          root_markers = { '.eslintrc', '.eslintrc.js', '.eslintrc.json', 'package.json', '.git' },
          capabilities = capabilities,
        })

        vim.lsp.config('html', {
          cmd = { 'vscode-html-language-server', '--stdio' },
          filetypes = { 'html', 'svelte' },
          capabilities = capabilities,
        })

        vim.lsp.config('cssls', {
          cmd = { 'vscode-css-language-server', '--stdio' },
          filetypes = { 'css', 'scss', 'less', 'svelte' },
          capabilities = capabilities,
        })

        -- Enable LSP servers
        vim.lsp.enable('svelte')
        vim.lsp.enable('ts_ls')
        vim.lsp.enable('eslint')
        vim.lsp.enable('html')
        vim.lsp.enable('cssls')
      else
        -- Fallback to old API for older Neovim versions
        local lspconfig = require("lspconfig")
        lspconfig.svelte.setup({ capabilities = capabilities })
        lspconfig.ts_ls.setup({ capabilities = capabilities })
        lspconfig.eslint.setup({ capabilities = capabilities })
        lspconfig.html.setup({ capabilities = capabilities })
        lspconfig.cssls.setup({ capabilities = capabilities })
      end

      -- LSP keybindings
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        end,
      })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
        },
      })
    end,
  },

  -- Comment toggle
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],
        direction = "float",
      })
    end,
  },
})

-- Key Mappings
local keymap = vim.keymap.set

-- File explorer
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Telescope (fuzzy finder)
keymap("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Search in files" })
keymap("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows
keymap("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Buffer navigation
keymap("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })

-- Save and quit
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- Clear search highlight
keymap("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlight" })

-- Better indenting
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

print("Neovim config loaded! Press <Space>ff to find files, <Space>e for file explorer")
