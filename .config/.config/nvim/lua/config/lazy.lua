local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"

    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})

        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",

        config = function()
            require("nvim-treesitter").setup()

            require("nvim-treesitter").install({
                "lua",
                "vim",
                "vimdoc",
                "query",
                "bash",
                "c",
                "cpp",
                "python",
                "rust",
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "bash",
                    "c",
                    "cpp",
                    "python",
                    "rust",
                },

                callback = function()
                    vim.treesitter.start()
                end,
            })
        end,
    },

    {
        "saghen/blink.cmp",

        dependencies = {
            "saghen/blink.lib",
        },

        build = function()
            require("blink.cmp").build():wait()
        end,

        opts = {
            keymap = {
                preset = "default",

                ["<Tab>"] = {
                    "select_next",
                    "fallback",
                },

                ["<S-Tab>"] = {
                    "select_prev",
                    "fallback",
                },

                ["<CR>"] = {
                    "accept",
                    "fallback",
                },

                ["<Esc>"] = {
                    "cancel",
                    "fallback",
                },
            },

            sources = {
                default = {
                    "lsp",
                    "path",
                    "buffer",
                },
            },
        },
    },
    {
        "Senal-D-A-Gunaratna/matugen.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            palette_path = "~/.cache/matugen/nvim-colors.json",
            -- load_theme = false,
        },
    },
})
