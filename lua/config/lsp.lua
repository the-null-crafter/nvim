-- blink.cmp's completion capabilities (snippets, resolve, labelDetails...) for every server
vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities() })

local ts_hints = {
    includeInlayParameterNameHints = 'all',
    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayVariableTypeHints = true,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayEnumMemberValueHints = true,
}

local servers = {
    rust_analyzer = {
        cmd = { 'rust-analyzer' },
        filetypes = { 'rust' },
        root_markers = { 'Cargo.toml', 'Cargo.lock', '.git' },

        settings = {
            ['rust-analyzer'] = {
                cargo = {
                    targetDir = true,
                    allFeatures = true,
                    buildScripts = { enable = true },
                },
                check = { command = 'clippy' },
                procMacro = { enable = true },
                diagnostics = { enable = true },
            },
        },
    },
    js_and_ts = {
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = { 'typescriptreact', 'typescript', 'javascriptreact', 'javascript' }, -- tsx, ts, js, jsx
        root_markers = { 'package.json', 'node_modules' },
        settings = { typescript = { inlayHints = ts_hints }, javascript = { inlayHints = ts_hints } },
    },
    expert = {
        cmd = { 'expert', '--stdio' },
        filetypes = { 'elixir' },
        root_markers = { 'mix.exs' },
        settings = {},
    },
    pyright = {
        cmd = { 'basedpyright-langserver', '--stdio' },
        filetypes = { 'python' },
        root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = 'openFilesOnly',
                    typeCheckingMode = 'basic',
                },
            },
        },
    },
    jedi = {
        cmd = { 'jedi-language-server' },
        filetypes = { 'python' },
        root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
        settings = {},
    },
    lua_ls = {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
        settings = {
            Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = { 'vim' } },
                workspace = {
                    library = vim.api.nvim_get_runtime_file('', true), -- runtime + every installed plugin (pack.lua already ran)
                    checkThirdParty = false,
                },
            },
        },
    },
    gopls = {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        root_markers = { 'go.work', 'go.mod', '.git' },
        settings = {
            gopls = {
                staticcheck = true,
                usePlaceholders = true,
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
                codelenses = { test = true },
                analyses = {
                    unusedparams = true,
                    unusedwrite = true,
                    nilness = true,
                },
            },
        },
    },
}

for name, cfg in pairs(servers) do
    vim.lsp.config(name, cfg)
end
vim.lsp.enable(vim.tbl_keys(servers))

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})
