local map = vim.keymap.set

map('n', '<leader>ff', function()
    Snacks.picker.files()
end, { desc = 'Find files' })
map('n', '<leader>fg', function()
    Snacks.picker.grep()
end, { desc = 'Live grep' })
map('n', '<leader>fb', function()
    Snacks.picker.buffers()
end, { desc = 'Buffers' })
map('n', '<leader>fh', function()
    Snacks.picker.help()
end, { desc = 'Help tags' })

map('n', '<leader>e', function()
    Snacks.explorer()
end, { desc = 'Toggle file explorer' })
map('n', '<leader>o', '<cmd>Oil<cr>', { desc = 'File browser (oil)' })
map('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent dir (oil)' })

-- snacks.terminal: bottom + full-screen float. Prefix a count for more, e.g. 2<leader>tt.
local function bottom_term()
    Snacks.terminal.toggle(nil, { win = { position = 'bottom' } })
end

map({ 'n', 't' }, '<C-]>', bottom_term, { desc = 'Toggle bottom terminal' })
map('n', '<leader>tt', bottom_term, { desc = 'Bottom terminal' })

-- right-side terminal; <C-\> toggles it from anywhere (incl. terminal mode), mirroring <C-]>
local function right_term()
    Snacks.terminal.toggle(nil, { env = { SNACKS_TERM = 'right' }, win = { position = 'right', width = 0.5 } })
end
map({ 'n', 't' }, '<C-\\>', right_term, { desc = 'Toggle right terminal' })
map('n', '<leader>tr', right_term, { desc = 'Right terminal' })

-- dedicated terminal buffers in the current window (like editing buffers, running in the background)
-- <leader>tb -> terminal 1, 2<leader>tb -> terminal 2, ...
local term_bufs = {}
local function goto_term(n)
    local buf = term_bufs[n]
    if buf and vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_set_current_buf(buf)
    else
        vim.cmd('terminal')
        term_bufs[n] = vim.api.nvim_get_current_buf()
    end
    vim.cmd('startinsert')
end
map('n', '<leader>tb', function()
    goto_term(vim.v.count1)
end, { desc = 'Terminal buffer N (count)' })

map('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
map('t', '<C-Up>', [[<C-\><C-n><C-u>]], { desc = 'Scroll up half page' })
map('t', '<C-Down>', [[<C-\><C-n><C-d>]], { desc = 'Scroll down half page' })
map('t', '<C-h>', [[<C-\><C-n><C-w>h]], { desc = 'Window left from term' })
map('t', '<C-j>', [[<C-\><C-n><C-w>j]], { desc = 'Window down from term' })
map('t', '<C-k>', [[<C-\><C-n><C-w>k]], { desc = 'Window up from term' })
map('t', '<C-l>', [[<C-\><C-n><C-w>l]], { desc = 'Window right from term' })

map('n', '<leader>w', '<cmd>write<cr>', { desc = 'Save' })
map('n', '<leader>q', '<cmd>quit<cr>', { desc = 'Quit' })
map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })

-- LSP. Built-ins stay: K hover, <C-S> signature (insert), grn/gra/grr/gri/grt/gO/grx, [d ]d [D ]D.
-- Snacks lsp_* pickers jump straight to a single result and open a preview list otherwise.
map('n', 'gd', function()
    Snacks.picker.lsp_definitions()
end, { desc = 'Goto definition' })
map('n', '<leader>lg', function()
    Snacks.picker.lsp_definitions()
end, { desc = 'Goto definition' })
map('n', '<leader>lD', function()
    Snacks.picker.lsp_declarations()
end, { desc = 'Goto declaration' })
map('n', '<leader>lR', function()
    Snacks.picker.lsp_references()
end, { desc = 'References' })
map('n', '<leader>li', function()
    Snacks.picker.lsp_implementations()
end, { desc = 'Implementations' })
map('n', '<leader>lt', function()
    Snacks.picker.lsp_type_definitions()
end, { desc = 'Type definition' })
map('n', '<leader>ls', function()
    Snacks.picker.lsp_symbols()
end, { desc = 'Document symbols' })
map('n', '<leader>lS', function()
    Snacks.picker.lsp_workspace_symbols()
end, { desc = 'Workspace symbols' })
map('n', '<leader>lx', function()
    Snacks.picker.diagnostics_buffer()
end, { desc = 'Buffer diagnostics' })
map('n', '<leader>lX', function()
    Snacks.picker.diagnostics()
end, { desc = 'Workspace diagnostics' })
map('n', '<leader>lc', function()
    Snacks.picker.lsp_incoming_calls()
end, { desc = 'Incoming calls' })
map('n', '<leader>lC', function()
    Snacks.picker.lsp_outgoing_calls()
end, { desc = 'Outgoing calls' })
map('n', '<leader>lI', function()
    Snacks.picker.lsp_config()
end, { desc = 'LSP servers (configured/installed/attached)' })
map('n', '<leader>ld', vim.diagnostic.open_float, { desc = 'Line diagnostics' })
map('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'Rename' })
map({ 'n', 'x' }, '<leader>la', vim.lsp.buf.code_action, { desc = 'Code action' })
map({ 'n', 'x' }, '<leader>lf', function()
    require('conform').format({ async = true })
end, { desc = 'Format (visual: range)' })
map('n', '<leader>lh', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = 'Toggle inlay hints' })
map('n', '<leader>ll', function()
    vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end, { desc = 'Toggle codelens' })
map('n', '<leader>lL', vim.lsp.codelens.run, { desc = 'Run codelens' })

-- ]] / [[ walk the LSP references of the word under the cursor (snacks.words); plain section motion without LSP
local function word_jump(dir, key)
    if Snacks.words.is_enabled() then
        Snacks.words.jump(dir * vim.v.count1, true)
    else
        vim.cmd('normal! ' .. vim.v.count1 .. key)
    end
end
map('n', ']]', function()
    word_jump(1, ']]')
end, { desc = 'Next reference' })
map('n', '[[', function()
    word_jump(-1, '[[')
end, { desc = 'Prev reference' })

map('n', ']c', function()
    require('gitsigns').nav_hunk('next')
end, { desc = 'Next git hunk' })
map('n', '[c', function()
    require('gitsigns').nav_hunk('prev')
end, { desc = 'Prev git hunk' })
map('n', '<leader>hs', function()
    require('gitsigns').stage_hunk()
end, { desc = 'Stage hunk' })
map('n', '<leader>hr', function()
    require('gitsigns').reset_hunk()
end, { desc = 'Reset hunk' })
map('n', '<leader>hp', function()
    require('gitsigns').preview_hunk()
end, { desc = 'Preview hunk' })
map('n', '<leader>hb', function()
    require('gitsigns').blame_line()
end, { desc = 'Blame line' })
