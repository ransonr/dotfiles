-- vim:foldmethod=marker

-- Setup {{{

local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt

--- }}}

-- Plugins {{{

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Must happen before plugins are required (otherwise wrong leader will be used)
g.mapleader = " "
g.maplocalleader = " "

require("lazy").setup({
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          styles = {
            comments = "italic",
          },
          groups = {
            all = {
              DevIconPy = { fg = "palette.blue" },
            },
          },
        },
      })

      cmd[[colorscheme nordfox]]
    end,
  },
  "nvim-lua/plenary.nvim",
  "tpope/vim-fugitive",
  { "numToStr/Comment.nvim", config = true },
  { "hynek/vim-python-pep8-indent", ft = "python" },
  { "tmhedberg/SimpylFold", ft = "python" },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      filters = {
        custom = { ".git$", "__pycache__", ".pytest_cache", "*.pyc" },
      },
      view = { adaptive_size = true },
      renderer = {
        highlight_opened_files = "icon",
        indent_markers = { enable = true },
      },
      git = { ignore = false },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = true,
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      local function diff_source()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
          }
        end
      end

      require("lualine").setup({
        options = {
          theme = "auto",
        },
        sections = {
          lualine_b = {
            "branch",
            {
              "diff",
              diff_color = {
                added = "GitSignsAdd",
                modified = "GitSignsChange",
                removed = "GitSignsDelete",
              },
            },
          },
          lualine_c = {
            {
              "filename",
              file_status = true,
              path = 1
            },
          },
        },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        offsets = {
          {
            filetype = "NvimTree",
            text = "",
            padding = 1,
          },
        },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
          map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
          map('n', '<leader>hS', gs.stage_buffer)
          map('n', '<leader>hu', gs.undo_stage_hunk)
          map('n', '<leader>hR', gs.reset_buffer)
          map('n', '<leader>hp', gs.preview_hunk)
          map('n', '<leader>hb', function() gs.blame_line{full=true} end)
          map('n', '<leader>tb', gs.toggle_current_line_blame)
          map('n', '<leader>hd', gs.diffthis)
          map('n', '<leader>hD', function() gs.diffthis('~') end)
          map('n', '<leader>td', gs.toggle_deleted)
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "bash", "cpp", "lua", "python" },
        sync_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        }
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      patterns = {
        default = {
          "class",
          "function",
          "method",
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
  },
  {
    "folke/which-key.nvim",
    config = true,
    lazy = true,
  },
  {
    "folke/todo-comments.nvim",
    config = true,
    lazy = true,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = true,
  },
  {
    "ibhagwan/fzf-lua",
    requires = {
      {"junegunn/fzf", run = function() fn["fzf#install"]() end},
    },
  },
  {
    "j-hui/fidget.nvim",
    opts = {
      window = {
        blend = 0,
      },
    },
  },
}, {
  performance = {
    rtp = {
      disabled_plugins = {
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "tar",
        "tarPlugin",
        "getscript",
        "getscriptPlugin",
        "vimball",
        "vimballPlugin",
        "2html_plugin",
        "logipat",
        "rrhelper",
        "spellfile_plugin",
        "matchit",
      },
    },
  },
})

-- }}}

-- General Settings {{{

opt.background = "dark"  -- easier on the eyes
opt.clipboard = "unnamedplus"
opt.colorcolumn = {100}  -- display ruler at 100 characters
opt.completeopt = "menu,menuone,noselect"
opt.cursorline = true  -- show cursor line.
opt.expandtab = true  -- use spaces instead of tabs
opt.foldlevelstart = 0  -- close all folds by default
opt.foldmethod = "syntax"  -- syntax highlighting items specify folds
opt.hidden = true  -- enable buffer to be hidden.
opt.ignorecase = true  -- ignore case when searching.
opt.mouse = "a"  -- mouse support.
opt.number = true  -- enable number line.
opt.scrolloff = 5  -- min number of lines above and below cursor
opt.shiftwidth = 2  -- shift line by 2 spaces when using >> or <<
opt.showmatch = true  -- show matching open/close for bracket
opt.sidescrolloff = 2  -- min number of columns to the right and left of cursor
opt.signcolumn = "yes"  -- always show sign column to avoid text jumping around
opt.smartcase = true  -- case sensitive if searching with uppercase.
opt.smartindent = true  -- C-like indenting when possible
opt.splitbelow = true  -- put new window below current when splitting
opt.splitright = true  -- put new window to the right when splitting vertically
opt.swapfile = false  -- disable swapfile.
opt.tabstop = 2  -- tab is 2 spaces
opt.termguicolors = true  -- enable rgb colors.
opt.timeoutlen = 300  -- reduce lag for mapped sequences (default is 1000)
opt.wrap = false  -- don't wrap lines visually
opt.wrapscan = false  -- do not wrap to beginning when searching

-- }}}

-- LSP {{{

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require("cmp")

cmp.setup({
  mapping = {
    ["<C-Space>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },

    ["<Tab>"] = function(fallback)
      if not cmp.select_next_item() then
        if vim.bo.buftype ~= "prompt" and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,

    ["<S-Tab>"] = function(fallback)
      if not cmp.select_prev_item() then
        if vim.bo.buftype ~= "prompt" and has_words_before() then
            cmp.complete()
          else
            fallback()
        end
      end
    end,
  },
  sources = cmp.config.sources({
    {name = "nvim_lsp"},
    {name = "nvim_lsp_signature_help"},
    {name = "buffer", keyword_length = 3},
    {name = "path"},
  })
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local servers = {
  bashls = {},
  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          flake8 = { enabled = true },
          mccabe = { enabled = false },
          preload = { enabled = false },
          pycodestyle = { enabled = false },
          pydocstyle = { enabled = false },
          pyflakes = { enabled = false },
          pylint = { enabled = false },
          rope_completion = { enabled = false },
          yapf = { enabled = false },
        },
      },
    },
  },
}

local lsp_opts = {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}

require("mason").setup({})
require("mason-lspconfig").setup({
  ensure_installed = vim.tbl_keys(servers)
})

lspconfig = require("lspconfig")

for server_name, _ in pairs(servers) do
  local extended_opts = vim.tbl_deep_extend("force", lsp_opts, servers[server_name] or {})
  lspconfig[server_name].setup(extended_opts)
end

-- }}}

-- Mappings {{{

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("n", "<leader>R", ":NvimTreeToggle<CR>", opts)
keymap("n", "<leader>r", ":NvimTreeFindFile<CR>", opts)

keymap("n", "<leader>ff", ":FzfLua files<CR>", opts)
keymap("n", "<leader>fg", ":FzfLua live_grep<CR>", opts)
keymap("n", "<leader>fb", ":FzfLua buffers<CR>", opts)
keymap("n", "<leader>fc", ":FzfLua git_commits<CR>", opts)

-- Easier than reaching for ESC
keymap("i", "jk", "<Esc>", opts)

-- Close the current buffer
keymap("n", "<leader>q", ":bw<CR>", opts)

-- Move between buffers easily
keymap("n", "<leader>l", ":bnext", opts)
keymap("n", "<leader>h", ":bprevious", opts)

-- Move around splits easily
keymap("n", "<C-j>", "<C-w><C-j>", opts)
keymap("n", "<C-k>", "<C-w><C-k>", opts)
keymap("n", "<C-l>", "<C-w><C-l>", opts)
keymap("n", "<C-h>", "<C-w><C-h>", opts)

-- Clear trailing white space
keymap("n", "<leader>rtw", ":%s/\\s\\+$//e<CR>", opts)

-- }}}
