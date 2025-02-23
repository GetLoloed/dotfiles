-- Bootstrap Mason
require("bootstrap").ensure_mason()

-- Configuration de base
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Installation automatique de lazy.nvim
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

-- Configuration des plugins
require("lazy").setup({
  -- Thème
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- Barre de status
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup()
    end
  },

  -- Explorateur de fichiers
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>')
    end
  },

  -- Autocomplétion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
    },
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'jose-elias-alvarez/typescript.nvim', -- Meilleur support TypeScript
    },
  },

  -- Telescope (recherche)
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
    },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files)
      vim.keymap.set('n', '<leader>fg', builtin.live_grep)
      vim.keymap.set('n', '<leader>fb', builtin.buffers)
    end
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { 
          "lua", "vim", "javascript", "typescript", 
          "html", "css", "scss", "json" 
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  -- Support Angular
  {
    "joeveiga/ng.nvim",
    config = function()
      require('ng').setup()
    end
  },

  -- Gestionnaire de tags HTML/JSX
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

  -- Paires automatiques
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end
  },

  -- Git
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },

  -- Commentaires
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },
})

-- Configuration LSP
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { 
    "lua_ls",
    "tsserver",
    "html",
    "cssls",
    "angularls"
  }
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Configuration des serveurs LSP
local lspconfig = require('lspconfig')

-- Angular
lspconfig.angularls.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    -- Raccourcis spécifiques à Angular
    vim.keymap.set('n', '<leader>at', ':NgOpenTemplate<CR>', { buffer = bufnr })
    vim.keymap.set('n', '<leader>ac', ':NgOpenComponent<CR>', { buffer = bufnr })
    vim.keymap.set('n', '<leader>as', ':NgOpenStylesheet<CR>', { buffer = bufnr })
  end,
})

-- TypeScript
require("typescript").setup({
  server = {
    capabilities = capabilities,
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        }
      }
    }
  }
})

-- Configuration de l'autocomplétion
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  })
}) 