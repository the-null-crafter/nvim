vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name = ev.data.spec.name
        local kind = ev.data.kind
        if kind ~= 'update' then
            return
        end -- 'install' fires before the plugin is on the runtimepath

        if name == 'nvim-treesitter' then
            vim.notify('Updating treesitter parsers...', vim.log.levels.INFO)

            vim.cmd('TSUpdate')
        end
    end,
})

vim.filetype.add({
    extension = {
        cl = 'lisp',
    },
})

vim.pack.add({
    { src = 'https://github.com/folke/tokyonight.nvim' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
    { src = 'https://github.com/stevearc/oil.nvim' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
    { src = 'https://github.com/nvim-lualine/lualine.nvim' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
    { src = 'https://github.com/folke/which-key.nvim' },
    { src = 'https://github.com/kylechui/nvim-surround' },
    { src = 'https://github.com/windwp/nvim-autopairs' },
    { src = 'https://github.com/folke/snacks.nvim' },
    { src = 'https://github.com/MunifTanjim/nui.nvim' },
    { src = 'https://github.com/folke/noice.nvim' },
    { src = 'https://github.com/saghen/blink.lib' },
    { src = 'https://github.com/saghen/blink.cmp' },
    { src = 'https://github.com/sphamba/smear-cursor.nvim' },
    { src = 'https://github.com/stevearc/conform.nvim' },
})

require('nvim-treesitter.parsers').elixir = {
    install_info = {
        url = 'https://github.com/elixir-lang/tree-sitter-elixir',
        revision = 'e2d9e6e0e76b0c436fa48a0b8c32a031d0cbdf49', -- commit hash for revision to check out; HEAD if missing
        -- optional entries:
        queries = 'queries', -- also install queries from given directory
    },
}
require('nvim-treesitter').install({ 'elixir' })

require('tokyonight').setup({
    style = 'night',
    transparent = false,
})
vim.cmd.colorscheme('tokyonight')

require('nvim-web-devicons').setup({})

require('snacks').setup({
    notifier = { enabled = true },
    input = { enabled = true },
    indent = { enabled = true },
    explorer = { enabled = true },
    picker = { enabled = true },
    words = { enabled = true }, -- LSP document highlight + ]] [[ reference jumps
    dashboard = {
        enabled = true,
        sections = {
            { section = 'header' },
            { section = 'keys', gap = 1, padding = 1 },
        },
    },
})

require('noice').setup({
    lsp = { signature = { enabled = false } }, -- blink.cmp owns signature help; both on = two windows
})

local cmp = require('blink.cmp')

cmp.build():wait(60000)
cmp.setup({
    keymap = { preset = 'enter' },
    appearance = { nerd_font_variant = 'mono' },
    completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        ghost_text = { enabled = true },
    },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    signature = { enabled = true },
})

require('conform').setup({
    formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'goimports', 'gofumpt' },
        python = { 'ruff_organize_imports', 'ruff_format' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        -- everything else (rust via rust-analyzer, gomod/gowork via gopls, elixir via expert): the attached server formats
        ['_'] = { lsp_format = 'prefer' },
    },
    -- listed filetypes keep conform's default lsp_format = 'never': a missing binary warns once and formats nothing
    format_on_save = { timeout_ms = 2000 },
})

require('lualine').setup({
    options = { theme = 'tokyonight' },
})

require('nvim-treesitter').install({
    'python',
    'bash',
    'json',
    'yaml',
    'markdown_inline',
    'clojure',
    'commonlisp',
    'go',
    'gomod',
    'gowork',
    'rust',
    'typescript',
    'tsx',
    'javascript',
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = {
        'python',
        'lua',
        'vim',
        'help',
        'bash',
        'sh',
        'json',
        'yaml',
        'markdown',
        'clojure',
        'lisp',
        'commonlisp',
        'elixir',
        'eelixir',
        'go',
        'gomod',
        'gowork',
        'rust',
        'typescript',
        'typescriptreact',
        'javascript',
        'javascriptreact',
    },
    callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
    end,
})

require('which-key').setup({})
require('which-key').add({
    { '<leader>l', group = 'lsp' },
    { '<leader>f', group = 'find' },
    { '<leader>t', group = 'terminal' },
    { '<leader>h', group = 'git' },
})

require('nvim-surround').setup({})

local lisp_fts = { lisp = true, clojure = true, commonlisp = true, scheme = true }
require('nvim-autopairs').setup({})
require('nvim-autopairs').disable()
vim.api.nvim_create_autocmd({ 'BufEnter', 'FileType' }, {
    callback = function()
        if lisp_fts[vim.bo.filetype] then
            require('nvim-autopairs').enable()
        else
            require('nvim-autopairs').disable()
        end
    end,
})

-- winbar shows the directory oil is browsing; global because `%!v:lua.` can only call globals
function _G.get_oil_winbar()
    local dir = require('oil').get_current_dir(vim.api.nvim_win_get_buf(vim.g.statusline_winid))
    -- no local dir (e.g. ssh:// adapter) -> fall back to the buffer name
    return dir and vim.fn.fnamemodify(dir, ':~') or vim.api.nvim_buf_get_name(0)
end

require('oil').setup({
    -- ponytail: oil opened explicitly via <leader>o / `-`; snacks.explorer owns the sidebar + netrw.
    -- Flip to true if you want `nvim <dir>` to open oil instead of snacks.explorer.
    default_file_explorer = false,
    view_options = { show_hidden = true },
    win_options = { winbar = '%!v:lua.get_oil_winbar()' },
})

require('gitsigns').setup({})

require('smear_cursor').setup({})
