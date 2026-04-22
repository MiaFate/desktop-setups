-- ==============================
--  Bootstrap packer.nvim
-- ==============================
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()


-- ==============================
--  Plugins
-- ==============================
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Rose Pine colorscheme
  use({
    'rose-pine/neovim',
    as = 'rose-pine',
    config = function()
      require("rose-pine").setup({
        variant = "moon",
        dark_variant = "moon",
      })
      vim.cmd("colorscheme rose-pine")
    end
  })

  -- Mason
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'

  -- LSP setup
  use 'neovim/nvim-lspconfig'

  -- Completion (nvim-cmp + sources)
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/vim-vsnip'

  -- Treesitter
  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { "lua", "rust", "toml" },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      }
    end
  })

  -- Lualine
  use({
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local colors = {
        blue   = '#89b4fa',
        cyan   = '#89dceb',
        black  = '#1e1e2e',
        white  = '#a6adc8',
        red    = '#f38ba8',
        violet = '#b4befe',
        grey   = '#6c7086',
      }

      local bubbles_theme = {
        normal = {
          a = { fg = colors.black, bg = colors.blue },
          b = { fg = colors.white, bg = colors.grey },
          c = { fg = colors.black, bg = colors.black },
        },
        insert = { a = { fg = colors.black, bg = colors.red } },
        visual = { a = { fg = colors.black, bg = colors.cyan } },
        replace = { a = { fg = colors.black, bg = colors.red } },
        inactive = {
          a = { fg = colors.white, bg = colors.black },
          b = { fg = colors.white, bg = colors.black },
          c = { fg = colors.black, bg = colors.black },
        },
      }

      require('lualine').setup {
        options = {
          theme = bubbles_theme,
          component_separators = '|',
          section_separators = { left = '', right = '' },
        },
      }
    end
  })

  -- Neo-tree
  use({
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  })

  -- Copilot
  use({
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
  })

  use({ "xiyaowong/transparent.nvim" })

  -- Icon support (mini.icons for better compatibility with which-key and other plugins)
  use({ 'echasnovski/mini.icons', version = false })

  -- Auto-sync packer
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- ==============================
--  Completion (nvim-cmp)
-- ==============================
local cmp = require 'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'copilot' },
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

-- ==============================
--  Copilot
-- ==============================
pcall(function()
  require("copilot").setup({
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 75,
      keymap = {
        accept = "<C-l>",
        accept_word = false,
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    panel = { enabled = false },
  })
end)

-- ==============================
--  LSP Setup
-- ==============================
pcall(function()
  require("mason").setup({
    ui = {
      icons = {
        package_installed = "",
        package_pending = "",
        package_uninstalled = "",
      },
    },
  })
  require("mason-lspconfig").setup()
  require("mason-lspconfig").setup_handlers {
    function(server_name)
      require("lspconfig")[server_name].setup {}
    end,
    ["rust_analyzer"] = function()
      require("lspconfig").rust_analyzer.setup {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<C-space>", vim.lsp.buf.hover, { buffer = bufnr })
          vim.keymap.set("n", "<Leader>a", vim.lsp.buf.code_action, { buffer = bufnr })
        end,
      }
    end,
  }
end)

-- ==============================
--  Opciones generales
-- ==============================
vim.cmd("set number")
vim.cmd("set expandtab")
vim.cmd("set shiftwidth=4")
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.api.nvim_set_option('updatetime', 300)

vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
-- ==============================
--  Diagnósticos LSP
-- ==============================
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({ name = 'DiagnosticSignError', text = '' })
sign({ name = 'DiagnosticSignWarn', text = '' })
sign({ name = 'DiagnosticSignHint', text = '' })
sign({ name = 'DiagnosticSignInfo', text = '' })

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = true,
  underline = true,
  severity_sort = false,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

-- ==============================
--  Disable Provider Warnings
-- ==============================
-- Disable Node.js provider (not needed, and warning about missing 'neovim' package)
vim.g.loaded_node_provider = 0

-- Disable Ruby provider (not needed)
vim.g.loaded_ruby_provider = 0

-- Disable Perl provider (not needed)
vim.g.loaded_perl_provider = 0

-- Disable Python3 provider (not needed for this config)
vim.g.loaded_python3_provider = 0
