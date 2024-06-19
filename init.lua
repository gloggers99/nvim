-- https://github.com/gloggers99/nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.mouse = "a"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.opt.foldlevel = 1
vim.opt.foldlevelstart = 0
vim.opt.foldnestmax = 1

vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.fillchars = { eob = " " }

require("lazy").setup({
    { "nvim-telescope/telescope.nvim" },
    { "onsails/lspkind.nvim" },
    { "github/copilot.vim" },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        opts = {}
    },
    {
        "nvim-zh/colorful-winsep.nvim",
        opts = {}
    },
    {
        "vigoux/notifier.nvim",
        opts = {}
    },
    {
        "rasulomaroff/reactive.nvim",
        opts = {
            load = { 'catppuccin-mocha-cursor', 'catppuccin-mocha-cursorline' },
        }
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {}
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000
    },
    {
        "morhetz/gruvbox",
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", MarkdownPreviewStop },
        ft = { "markdown" },
        build = function ()
            vim.fn["mkdp#util#install"]()
        end
    },
    {
        "folke/zen-mode.nvim",
        opts = {
            window = {
                backdrop = 1,
            },
            plugins = {
                options = {
                    laststatus = 3
                }
            }
        }
    },
    {
        "nvimdev/lspsaga.nvim",
        opts = {
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        }
    },
    {
        "akinsho/toggleterm.nvim",
        opts = {}
    },
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons"
        },
        opts = {
            theme = vim.g.colors_name
        }
    },
    {
        "m4xshen/hardtime.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim"
        },
        opts = {
            disable_mouse = false,
            disabled_keys = {
                ["<Up>"] = {},
                ["<Down>"] = {},
                ["<Left>"] = {},
                ["<Right>"] = {}
            },
            restriction_mode = "hint"
        }
    },
    {
        "Pocco81/auto-save.nvim",
        opts = {}
    },
    {
        "romgrk/barbar.nvim",
        dependencies = {
            "lewis6991/gitsigns.nvim",
            "nvim-tree/nvim-web-devicons"
        },
        init = function ()
            vim.g.barbar_auto_setup = false
        end,
        opts = {}
    },
    {
        "nyoom-engineering/oxocarbon.nvim"
    },
    {
        "yamatsum/nvim-cursorline",
        opts = {
            cursorline = {
                enable = true,
                timeout = 0,
                number = false,
            },
            cursorword = {
                enable = true,
                min_length = 3,
                hl = { underline = true }
            }
        }
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
        opts = {}
    },
    {
        "williamboman/mason.nvim",
        opts = {}
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {},
        config = function()
            require("mason-lspconfig").setup_handlers {
                function(server_name)
                    local capabilities = require("cmp_nvim_lsp").default_capabilities()
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end
            }
        end
    },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { 
        "hrsh7th/nvim-cmp" ,
        config = function()
            local cmp = require("cmp")
            require("lspconfig").lua_ls.setup {}

            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                completion = {
                    completeopt = "menu,menuone"
                },
                window = {
                    completion = {
                        --winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                    },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    --["<Tab>"] = cmp.mapping.confirm({ select = true }),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        local status_ok, luasnip = pcall(require, "luasnip")
                        if status_ok and luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        local status_ok, luasnip = pcall(require, "luasnip")
                        if status_ok and luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" })
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "vsnip" },
                },  {
                    { name = "buffer" },
                })
            })

            cmp.setup {
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
                        local strings = vim.split(kind.kind, "%s", { trimempty = true })
                        kind.kind = " " .. (strings[1] or "") .. " "
                        kind.menu = "    (" .. (strings[2] or "") .. ")"

                        return kind
                    end,
                }
            }

            vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#282C34", fg = "NONE" })
            vim.api.nvim_set_hl(0, "Pmenu", { fg = "#C5CDD9", bg = "#22252A" })

            vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#7E8294", bg = "NONE", strikethrough = true })
            vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#82AAFF", bg = "NONE", bold = true })
            vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#82AAFF", bg = "NONE", bold = true })
            vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#C792EA", bg = "NONE", italic = true })

            vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = "#EED8DA", bg = "#B5585F" })
            vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#EED8DA", bg = "#B5585F" })
            vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = "#EED8DA", bg = "#B5585F" })

            vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#C3E88D", bg = "#9FBD73" })
            vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = "#C3E88D", bg = "#9FBD73" })
            vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#C3E88D", bg = "#9FBD73" })

            vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = "#FFE082", bg = "#D4BB6C" })
            vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = "#FFE082", bg = "#D4BB6C" })
            vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = "#FFE082", bg = "#D4BB6C" })

            vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#EADFF0", bg = "#A377BF" })
            vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = "#EADFF0", bg = "#A377BF" })
            vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#EADFF0", bg = "#A377BF" })
            vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = "#EADFF0", bg = "#A377BF" })
            vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = "#EADFF0", bg = "#A377BF" })

            vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#C5CDD9", bg = "#7E8294" })
            vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = "#C5CDD9", bg = "#7E8294" })

            vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#F5EBD9", bg = "#D4A959" })
            vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#F5EBD9", bg = "#D4A959" })
            vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = "#F5EBD9", bg = "#D4A959" })

            vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#DDE5F5", bg = "#6C8ED4" })
            vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = "#DDE5F5", bg = "#6C8ED4" })
            vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = "#DDE5F5", bg = "#6C8ED4" })

            vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#D8EEEB", bg = "#58B5A8" })
            vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = "#D8EEEB", bg = "#58B5A8" })
            vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { fg = "#D8EEEB", bg = "#58B5A8" })

            -- Autocomplete for git
            cmp.setup.filetype("gitcommit", {
                sources = cmp.config.sources({
                    { name = "git" },
                }, {
                    { name = "buffer" },
                })
            })

            -- Autocomplete for searching
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" }
                }
            })

            -- Autocomplete for vim commands
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" }
                }, {
                    { name = "cmdline" }
                })
            })
        end
    },
    { "hrsh7th/cmp-vsnip" },
    { "hrsh7th/vim-vsnip" },
    {
        "stevearc/aerial.nvim",
        opts = {},
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        }
    },
    {
        "folke/which-key.nvim",
        opts = {}
    },
    {
        "folke/todo-comments.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        opts = {}
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {}
    },
    {
        "nvchad/nvim-colorizer.lua",
        opts = {}
    },
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        opts = {},

        dependencies = {
            "nvim-tree/nvim-web-devicons"
        }
    }
})

vim.opt.background = "dark"
vim.cmd.colorscheme "catppuccin-mocha"

-- keybinds

-- cool stuff
vim.keymap.set("n", "<leader>rr", "<cmd>Lspsaga rename<CR>")
vim.keymap.set("n", "<leader><CR>", "<cmd>Lspsaga code_action<CR>")
vim.keymap.set("n", "<leader>gd", "<cmd>Lspsaga hover_doc<CR>")
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>")

-- telescope
vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope find_files<CR>")

-- window
vim.keymap.set("n", "<C-s>", "<cmd>split<CR>")
vim.keymap.set("n", "<C-t>", "<cmd>vsplit<CR>")

-- programs
vim.keymap.set("n", "<leader>of", "<cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>op", "<cmd>ToggleTerm<CR>")

-- build commands
vim.keymap.set("n", "<leader>bc", "<cmd>!mkdir -p ./cmake-build-debug && cd ./cmake-build-debug && cmake ../ && make && cd .. && ./cmake-build-debug/$(basename $(pwd))<CR>")

