vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },

    filetypes = { "lua" },

    root_markers = {
        ".luarc.json",
        ".luarc.jsonc",
        ".git",
    },

    capabilities = require("blink.cmp").get_lsp_capabilities(),

    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
})

vim.lsp.config("clangd", {
    cmd = { "clangd" },

    filetypes = {
        "c",
        "cpp",
        "objc",
        "objcpp",
    },

    root_markers = {
        "compile_commands.json",
        "compile_flags.txt",
        ".git",
    },

    capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.lsp.enable("lua_ls")
vim.lsp.enable("clangd")

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    severity_sort = true,

    float = {
        border = "rounded",
    },
})

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
