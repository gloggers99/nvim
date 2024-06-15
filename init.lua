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

require("lazy").setup({
    { "nvim-telescope/telescope.nvim" },
    { "onsails/lspkind.nvim" },
    { "github/copilot.vim" },
    {
        "folke/zen-mode.nvim",
        opts = {
            window = {
                backdrop = 1,
                options = {

                }
            },
            plugins = {
                options = {
                    laststatus = 3
                }
            }
        }
    },
    {
        "famiu/feline.nvim",
        config = function ()

            local present, feline = pcall(require, "feline")
            if not present then return end

            local theme = {
                aqua = "#7AB0DF",
                bg = "#1C212A",
                blue = "#5FB0FC",
                cyan = "#70C0BA",
                darkred = "#FB7373",
                fg = "#C7C7CA",
                gray = "#222730",
                green = "#79DCAA",
                lime = "#54CED6",
                orange = "#FFD064",
                pink = "#D997C8",
                purple = "#C397D8",
                red = "#F87070",
                yellow = "#FFE59E"
            }

            local mode_theme = {
                ["NORMAL"] = theme.green,
                ["OP"] = theme.cyan,
                ["INSERT"] = theme.aqua,
                ["VISUAL"] = theme.yellow,
                ["LINES"] = theme.darkred,
                ["BLOCK"] = theme.orange,
                ["REPLACE"] = theme.purple,
                ["V-REPLACE"] = theme.pink,
                ["ENTER"] = theme.pink,
                ["MORE"] = theme.pink,
                ["SELECT"] = theme.darkred,
                ["SHELL"] = theme.cyan,
                ["TERM"] = theme.lime,
                ["NONE"] = theme.gray,
                ["COMMAND"] = theme.blue,
            }

            local modes = setmetatable({
                ["n"] = "N",
                ["no"] = "N",
                ["v"] = "V",
                ["V"] = "VL",
                [""] = "VB",
                ["s"] = "S",
                ["S"] = "SL",
                [""] = "SB",
                ["i"] = "I",
                ["ic"] = "I",
                ["R"] = "R",
                ["Rv"] = "VR",
                ["c"] = "C",
                ["cv"] = "EX",
                ["ce"] = "X",
                ["r"] = "P",
                ["rm"] = "M",
                ["r?"] = "C",
                ["!"] = "SH",
                ["t"] = "T",
            }, { __index = function() return "-" end })

            local component = {}

            component.vim_mode = {
                provider = function() return modes[vim.api.nvim_get_mode().mode] end,
                hl = function()
                    return {
                        fg = "bg",
                        bg = require("feline.providers.vi_mode").get_mode_color(),
                        style = "bold",
                        name = "NeovimModeHLColor",
                    }
                end,
                left_sep = "block",
                right_sep = "block",
            }

            component.git_branch = {
                provider = "git_branch",
                hl = {
                    fg = "fg",
                    bg = "bg",
                    style = "bold",
                },
                left_sep = "block",
                right_sep = "",
            }

            component.git_add = {
                provider = "git_diff_added",
                hl = {
                    fg = "green",
                    bg = "bg",
                },
                left_sep = "",
                right_sep = "",
            }

            component.git_delete = {
                provider = "git_diff_removed",
                hl = {
                    fg = "red",
                    bg = "bg",
                },
                left_sep = "",
                right_sep = "",
            }

            component.git_change = {
                provider = "git_diff_changed",
                hl = {
                    fg = "purple",
                    bg = "bg",
                },
                left_sep = "",
                right_sep = "",
            }

            component.separator = {
                provider = "",
                hl = {
                    fg = "bg",
                    bg = "bg",
                },
            }

            component.diagnostic_errors = {
                provider = "diagnostic_errors",
                hl = {
                    fg = "red",
                },
            }

            component.diagnostic_warnings = {
                provider = "diagnostic_warnings",
                hl = {
                    fg = "yellow",
                },
            }

            component.diagnostic_hints = {
                provider = "diagnostic_hints",
                hl = {
                    fg = "aqua",
                },
            }

            component.diagnostic_info = {
                provider = "diagnostic_info",
            }

            component.lsp = {
                provider = function()
                    if not rawget(vim, "lsp") then
                        return ""
                    end

                    local progress = vim.lsp.status()[1]
                    if vim.o.columns < 120 then
                        return ""
                    end

                    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
                    if #clients ~= 0 then
                        if progress then
                            local spinners = {
                                "◜ ",
                                "◠ ",
                                "◝ ",
                                "◞ ",
                                "◡ ",
                                "◟ ",
                            }
                            local ms = vim.loop.hrtime() / 1000000
                            local frame = math.floor(ms / 120) % #spinners
                            local content = string.format("%%<%s", spinners[frame + 1])
                            return content or ""
                        else
                            return "לּ LSP"
                        end
                    end
                    return ""
                end,
                hl = function()
                    local progress = vim.lsp.status()[1]
                    return {
                        fg = progress and "yellow" or "green",
                        bg = "gray",
                        style = "bold",
                    }
                end,
                left_sep = "",
                right_sep = "block",
            }

            component.file_type = {
                provider = {
                    name = "file_type",
                    opts = {
                        filetype_icon = true,
                    },
                },
                hl = {
                    fg = "fg",
                    bg = "gray",
                },
                left_sep = "block",
                right_sep = "block",
            }

            component.scroll_bar = {
                provider = function()
                    local chars = setmetatable({
                        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
                        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
                    }, { __index = function() return " " end })
                    local line_ratio = vim.api.nvim_win_get_cursor(0)[1] / vim.api.nvim_buf_line_count(0)
                    local position = math.floor(line_ratio * 100)

                    local icon = chars[math.floor(line_ratio * #chars)] .. position
                    if position <= 5 then
                        icon = " TOP"
                    elseif position >= 95 then
                        icon = " BOT"
                    end
                    return icon
                end,
                hl = function()
                    local position = math.floor(vim.api.nvim_win_get_cursor(0)[1] / vim.api.nvim_buf_line_count(0) * 100)
                    local fg
                    local style

                    if position <= 5 then
                        fg = "aqua"
                        style = "bold"
                    elseif position >= 95 then
                        fg = "red"
                        style = "bold"
                    else
                        fg = "purple"
                        style = nil
                    end
                    return {
                        fg = fg,
                        style = style,
                        bg = "bg",
                    }
                end,
                left_sep = "block",
                right_sep = "block",
            }

            vim.api.nvim_set_hl(0, "StatusLine", { bg = "#101317", fg = "#7AB0DF" })
            feline.setup({
                components = {
                    active = {
                        {}, -- left
                        {}, -- middle
                        {   -- right
                            component.vim_mode,
                            component.file_type,
                            component.lsp,
                            component.git_branch,
                            component.git_add,
                            component.git_delete,
                            component.git_change,
                            component.separator,
                            component.diagnostic_errors,
                            component.diagnostic_warnings,
                            component.diagnostic_info,
                            component.diagnostic_hints,
                            component.scroll_bar,
                        },
                    },
                },
                theme = theme,
                vi_mode_colors = mode_theme,
            })
        end
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
        opts = {}
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
vim.cmd.colorscheme "oxocarbon"

-- cool stuff
vim.keymap.set("n", "<leader>rr", "<cmd>Lspsaga rename<CR>")
vim.keymap.set("n", "<leader><CR>", "<cmd>Lspsaga code_action<CR>")
vim.keymap.set("n", "<leader>t", "<cmd>Twilight<CR>")
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>")

-- telescope
vim.keymap.set("n", "<leader><leader>", "<cmd>Telescope find_files<CR>")

-- programs
vim.keymap.set("n", "<leader>of", "<cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>op", "<cmd>ToggleTerm<CR>")

-- build commands
vim.keymap.set("n", "<leader>bc", "<cmd>!mkdir -p ./cmake-build-debug && cd ./cmake-build-debug && cmake ../ && make && cd ..<CR>")
