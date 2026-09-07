return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
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

            highlight = {
                enable = true,
            },

            indent = {
                enable = true,
            },
        },
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
}
