-- vim:foldmethod=marker

-- Setup {{{

local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt

-- Don't load these builtin plugins
g.loaded_2html_plugin = 1
g.loaded_netrw = 1
g.loaded_netrwFileHandlers = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_tutor_mode_plugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1

--- }}}

-- Plugins {{{

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]], false)

require('packer').startup(function(use)
  use("wbthomason/packer.nvim")

  use("nvim-lua/plenary.nvim")
  use("tpope/vim-fugitive")
  use("tpope/vim-commentary")
  use("tpope/vim-projectionist")

  use({
    "EdenEast/nightfox.nvim",
    config = function()
      require("nightfox").setup({
        options = {
          styles = {
            comments = "italic",
          },
        },
      })
    end,
  })

  use({
    "kyazdani42/nvim-tree.lua",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        filters = {
          custom = { ".git$", "__pycache__", ".pytest_cache", "*.pyc" },
        },
        view = { hide_root_folers = true },
        renderer = {
          highlight_opened_files = "icon",
          indent_markers = { enable = true },
        },
        git = { ignore = false },
      })
    end,
  })

  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      g.indent_blankline_filetype_exclude = {"help", "checkhealth", "packer", "man", "lspinfo", "NvimTree", ""}
      require("indent_blankline").setup({})
    end,
  })

  use({
    "nvim-lualine/lualine.nvim",
    config = function ()
      require("lualine").setup({
        options = {
          disabled_filetypes = {"help", "NvimTree"}
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
  })

  use({
    "akinsho/bufferline.nvim",
    config = function()
      require("bufferline").setup({
        options = {
          offsets = {
            {
              filetype = "NvimTree",
              text = "",
              padding = 1,
            },
          },
        },
      })
    end,
  })

  use({
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
  })

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
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
  })

  use({
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({
        patterns = {
          default = {
            "class",
            "function",
            "method",
          },
        },
      })
    end,
  })

  use("neovim/nvim-lspconfig")
  use("williamboman/nvim-lsp-installer")

  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
  })

  use({
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end,
  })

  use({
    "ibhagwan/fzf-lua",
    requires = {
      {"junegunn/fzf", run = function() fn["fzf#install"]() end},
    },
  })

end)

-- }}}

-- General Settings {{{

opt.background = "dark"  -- easier on the eyes
opt.clipboard = "unnamed"  -- Set defaults registry to clipboard.
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

cmd("colorscheme nordfox")

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
    {name = "buffer"},
    {name = "path"},
  })
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = {noremap = true, silent = true}

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

local servers = {
  "bashls",
  "sumneko_lua",
  "pylsp",
}

require("nvim-lsp-installer").setup({
  install_root_dir = os.getenv("HOME") .. "/.config/nvim/tooling/lsp_servers",
  ensure_installed = servers
})

for _, lsp in pairs(servers) do
  require("lspconfig")[lsp].setup({
    capabilities = capabilities,
    on_attach = on_attach
  })
end

-- }}}

-- Mappings {{{

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

g.mapleader = " "

keymap("n", "<leader>R", ":NvimTreeToggle<cr>", opts)
keymap("n", "<leader>r", ":NvimTreeFindFile<cr>", opts)

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
