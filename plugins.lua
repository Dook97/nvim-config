vim.pack.add({
  'tpope/vim-repeat',                                           -- enables . command for some plugins
  'tpope/vim-surround',                                         -- super useful to (un)surround stuff
  'itchyny/lightline.vim',                                      -- statusline
  'josa42/nvim-lightline-lsp',                                  -- add err and warning sign to lightline
  'tpope/vim-sleuth',                                           -- automatic indentation mode detection
  'nvim-treesitter/nvim-treesitter',                            -- a lot of functionality with ASTs
  'nvim-treesitter/nvim-treesitter-textobjects',                -- define bindings for actions with AST text objects
  'nvim-treesitter/nvim-treesitter-context',                    -- show current function name when scrolling
  'psliwka/vim-smoothie',                                       -- smooth scrolling
  'norcalli/nvim-colorizer.lua',                                -- css colors preview
  'nvim-lua/plenary.nvim',                                      -- telescope prerequisite
  'stevearc/conform.nvim',                                      -- ebin meta formatter thingy
  { src = 'nvim-telescope/telescope.nvim', version = '0.1.x' }, -- conveniently search buffers, files & whatever else
  { src = 'shirosaki/tabular', version = 'fix_leading_spaces' } -- multiline alignment
})

-- lightline
local theme = os.getenv('XDG_DATA_HOME') .. '/nvim/site/pack/core/opt/lightline.vim/autoload/lightline/colorscheme/dook.vim'
if vim.fn.filereadable(theme) == 0 then
  print('Downloading custom lightline theme...')
  vim.fn.system({
    'curl',
    '-fLo', theme,
    '--create-dirs',
    'https://raw.githubusercontent.com/Dook97/nvim-config/main/lightline_colors.vim'
  })
end
vim.cmd('source ${XDG_CONFIG_HOME}/nvim/lightline_conf.vim')

vim.g.smoothie_no_default_mappings = 1

vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0

-- treesitter config
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'c', 'cpp', 'go', 'javascript', 'json', 'python', 'comment',
    'typescript', 'c_sharp', 'haskell', 'markdown', 'markdown_inline',
    'make', 'html', 'gitignore', 'gitcommit', 'arduino', 'yaml', 'sql',
    'css', 'dockerfile', 'bash', 'rust', 'query', 'lua'
  },
  sync_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['aP'] = '@parameter.outer',
        ['iP'] = '@parameter.inner',
        ['ib'] = '@block.inner',
        ['ab'] = '@block.outer',
        ['iC'] = '@comment.inner',
        ['aC'] = '@comment.outer',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']f'] = '@function.outer',
        [']c'] = '@class.outer',
        [']p'] = '@parameter.inner',
      },
      goto_next_end = {
        [']F'] = '@function.outer',
        [']C'] = '@class.outer',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
        ['[c'] = '@class.outer',
        ['[p'] = '@parameter.inner',
      },
      goto_previous_end = {
        ['[F'] = '@function.outer',
        ['[C'] = '@class.outer',
      },
    },
  },
}

-- Attach to certain Filetypes, add special configuration for `html`
-- Use `background` for everything else.
vim.o.termguicolors = true
require('colorizer').setup {
  'css';
  'javascript';
  html = {
    mode = 'foreground';
  }
}

vim.diagnostic.config({
  virtual_text = true,
  -- diagnostic messages are highlighted via line numbers instead of signcolumn
  signs = {
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticLineNrError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticLineNrWarn',
    },
  },
})

vim.lsp.config('*', {
  root_markers = { '.git' },
})

-- enable all configured LSP servers
local servers = vim.fn.systemlist([[ ls ${XDG_CONFIG_HOME}/nvim/lsp/ | sed -E 's/(.*)\\.lua$/\\1/' ]])
for _, line in ipairs(servers) do
  vim.lsp.enable({line:match("(.+)%.lua$")})
end

require('treesitter-context').setup({enable=true})

require("conform").setup({
	formatters_by_ft = {
		sh   = { "shfmt", "shellcheck" },
		zsh  = { "shfmt", "shellcheck" },
		bash = { "shfmt", "shellcheck" },
		go   = { "gofmt" },
		cs   = { "clang-format" },
		js   = { "clang-format" },
		java = { "clang-format" },
		json = { "jq" },
		lua  = { "stylua" },
	},
})

-- use conform as gq for filetypes that have a formatter set
vim.api.nvim_create_autocmd('FileType', {
  pattern = vim.tbl_keys(require("conform").formatters_by_ft),
  group = vim.api.nvim_create_augroup('conform_formatexpr', { clear = true }),
  callback = function()
    vim.opt_local.formatexpr = 'v:lua.require("conform").formatexpr()'
  end,
})
