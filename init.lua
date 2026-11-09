-- require('vim._core.ui2').enable() -- Experimental
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.options')
require('config.pack')
require('config.lsp')
require('config.keymaps')
