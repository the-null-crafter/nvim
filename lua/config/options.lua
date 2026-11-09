local o = vim.opt

o.number = true
o.relativenumber = true
o.signcolumn = 'yes'
o.cursorline = true
o.wrap = true
o.linebreak = true
o.breakindent = true
o.scrolloff = 8
o.sidescrolloff = 8

o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.smartindent = true

o.ignorecase = true
o.smartcase = true

o.splitbelow = true
o.splitright = true

o.termguicolors = true
o.undofile = true
o.updatetime = 250
o.timeoutlen = 400

o.completeopt = { 'menu', 'menuone', 'noselect', 'popup' }
o.clipboard = 'unnamedplus'

if vim.env.SSH_TTY then
    vim.api.nvim_create_autocmd('TextYankPost', {
        callback = function()
            require('vim.ui.clipboard.osc52').copy('+')(vim.v.event.regcontents)
        end,
    })
end
