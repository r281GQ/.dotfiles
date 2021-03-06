require('packer').startup(function(use)
    -- Packer can manage itself
    -- My own plugins under development
    use {
        "/Users/endrevegh/Repos/personal/zettelkasten.nvim",
        requires = {"nvim-lua/plenary.nvim"}
    }
    --
    use 'kazhala/close-buffers.nvim'
    use 'wbthomason/packer.nvim'
    use {'tanvirtin/vgit.nvim', requires = {'nvim-lua/plenary.nvim'}}
    use 'kyazdani42/nvim-web-devicons'
    use 'sumneko/lua-language-server'
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end
    })

    use {
        "akinsho/toggleterm.nvim",
        tag = 'v1.*',
        config = function() require("toggleterm").setup() end
    }

    use "hrsh7th/cmp-path"

    use {'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim'}

    use {
        'akinsho/bufferline.nvim',
        tag = "*",
        requires = 'kyazdani42/nvim-web-devicons'
    }

    use 'neovim/nvim-lspconfig'
    --  use 'chentau/marks.nvim'

    -- Post-install/update hook with neovim command
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use {
        'ibhagwan/fzf-lua',
        -- optional for icon support
        requires = {'kyazdani42/nvim-web-devicons'},
        use = {'junegunn/fzf', run = './install --bin'}
    }
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim", {
                -- only needed if you want to use the "open_window_picker" command
                's1n7ax/nvim-window-picker',
                tag = "1.*",
                config = function()
                    require'window-picker'.setup({
                        autoselect_one = true,
                        include_current = false,
                        filter_rules = {
                            -- filter using buffer options
                            bo = {
                                -- if the file type is one of following, the window will be ignored
                                filetype = {
                                    'neo-tree', "neo-tree-popup", "notify",
                                    "quickfix"
                                },

                                -- if the buffer type is one of following, the window will be ignored
                                buftype = {'terminal'}
                            }
                        },
                        other_win_hl_color = '#e35e4f'
                    })
                end
            }
        },
        config = function()
            -- Unless you are still migrating, remove the deprecated commands from v1.x
            vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

            -- If you want icons for diagnostic errors, you'll need to define them somewhere:
            vim.fn.sign_define("DiagnosticSignError",
                               {text = "??? ", texthl = "DiagnosticSignError"})
            vim.fn.sign_define("DiagnosticSignWarn",
                               {text = "??? ", texthl = "DiagnosticSignWarn"})
            vim.fn.sign_define("DiagnosticSignInfo",
                               {text = "??? ", texthl = "DiagnosticSignInfo"})
            vim.fn.sign_define("DiagnosticSignHint",
                               {text = "???", texthl = "DiagnosticSignHint"})
            -- NOTE: this is changed from v1.x, which used the old style of highlight groups
            -- in the form "LspDiagnosticsSignWarning"

            require("neo-tree").setup({
                close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
                popup_border_style = "rounded",
                enable_git_status = true,
                enable_diagnostics = true,
                default_component_configs = {
                    indent = {
                        indent_size = 2,
                        padding = 1, -- extra padding on left hand side
                        -- indent guides
                        with_markers = true,
                        indent_marker = "???",
                        last_indent_marker = "???",
                        highlight = "NeoTreeIndentMarker",
                        -- expander config, needed for nesting files
                        with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
                        expander_collapsed = "???",
                        expander_expanded = "???",
                        expander_highlight = "NeoTreeExpander"
                    },
                    icon = {
                        folder_closed = "???",
                        folder_open = "???",
                        folder_empty = "???",
                        default = "*"
                    },
                    modified = {symbol = "[+]", highlight = "NeoTreeModified"},
                    name = {
                        trailing_slash = false,
                        use_git_status_colors = true
                    },
                    git_status = {
                        symbols = {
                            -- Change type
                            added = "", -- or "???", but this is redundant info if you use git_status_colors on the name
                            modified = "", -- or "???", but this is redundant info if you use git_status_colors on the name
                            deleted = "???", -- this can only be used in the git_status source
                            renamed = "???", -- this can only be used in the git_status source
                            -- Status type
                            untracked = "???",
                            ignored = "???",
                            unstaged = "???",
                            staged = "???",
                            conflict = "???"
                        }
                    }
                },
                window = {
                    position = "left",
                    width = 40,
                    mapping_options = {noremap = true, nowait = true},
                    mappings = {
                        ["<space>"] = {
                            "toggle_node",
                            nowait = false -- disable `nowait` if you have existing combos starting with this char that you want to use
                        },
                        ["<2-LeftMouse>"] = "open",
                        ["<cr>"] = "open",
                        ["S"] = "open_split",
                        ["s"] = "open_vsplit",
                        ["t"] = "open_tabnew",
                        ["w"] = "open_with_window_picker",
                        ["C"] = "close_node",
                        ["a"] = "add",
                        ["A"] = "add_directory",
                        ["d"] = "delete",
                        ["r"] = "rename",
                        ["y"] = "copy_to_clipboard",
                        ["x"] = "cut_to_clipboard",
                        ["p"] = "paste_from_clipboard",
                        ["c"] = "copy", -- takes text input for destination
                        ["m"] = "move", -- takes text input for destination
                        ["q"] = "close_window",
                        ["R"] = "refresh"
                    }
                },
                nesting_rules = {},
                filesystem = {
                    filtered_items = {
                        visible = false, -- when true, they will just be displayed differently than normal items
                        hide_dotfiles = true,
                        hide_gitignored = true,
                        hide_by_name = {
                            ".DS_Store", "thumbs.db"
                            -- "node_modules"
                        },
                        hide_by_pattern = { -- uses glob style patterns
                            -- "*.meta"
                        },
                        never_show = { -- remains hidden even if visible is toggled to true
                            -- ".DS_Store",
                            -- "thumbs.db"
                        }
                    },
                    follow_current_file = true, -- This will find and focus the file in the active buffer every
                    -- time the current file is changed while the tree is open.
                    hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
                    -- in whatever position is specified in window.position
                    -- "open_current",  -- netrw disabled, opening a directory opens within the
                    -- window like netrw would, regardless of window.position
                    -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
                    use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
                    -- instead of relying on nvim autocmd events.
                    window = {
                        mappings = {
                            ["<bs>"] = "navigate_up",
                            ["."] = "set_root",
                            ["H"] = "toggle_hidden",
                            ["/"] = "fuzzy_finder",
                            ["f"] = "filter_on_submit",
                            ["<c-x>"] = "clear_filter"
                        }
                    }
                },
                buffers = {
                    show_unloaded = true,
                    window = {
                        mappings = {
                            ["bd"] = "buffer_delete",
                            ["<bs>"] = "navigate_up",
                            ["."] = "set_root"
                        }
                    }
                },
                git_status = {
                    window = {
                        position = "float",
                        mappings = {
                            ["A"] = "git_add_all",
                            ["gu"] = "git_unstage_file",
                            ["ga"] = "git_add_file",
                            ["gr"] = "git_revert_file",
                            ["gc"] = "git_commit",
                            ["gp"] = "git_push",
                            ["gg"] = "git_commit_and_push"
                        }
                    }
                }
            })

            vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
        end
    }

    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    -- use 'hrsh7th/cmp-path'
    -- use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    -- use 'jiangmiao/auto-pairs'
    use 'windwp/nvim-autopairs'
    use "lukas-reineke/lsp-format.nvim"
    use 'MunifTanjim/prettier.nvim'
    use "jose-elias-alvarez/null-ls.nvim"
    use "nvim-lua/plenary.nvim"
    use 'folke/tokyonight.nvim'
    use "terrortylor/nvim-comment"

    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'}

    use {
        'nvim-lualine/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/plenary.nvim'}}
    }
end)
-- If you want insert `(` after select function or method item
-- local cmp_autopairs = require('nvim-autopairs.completion.cmp')

-- space as <leader>
vim.g.mapleader = ' '

-- vim.opt.termguicolors = false
vim.cmd([[ if (has("termguicolors"))
  set termguicolors
endif ]])

vim.api.nvim_exec([[
  let g:nvim_markdown_preview_theme = 'solarized-light'
]], false)

require("bufferline").setup {}
require'nvim-web-devicons'.setup {
    -- your personnal icons can go here (to override)
    -- you can specify color or cterm_color instead of specifying both of them
    -- DevIcon will be appended to `name`
    override = {
        zsh = {
            icon = "???",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh"
        }
    },
    -- globally enable default icons (default to false)
    -- will get overriden by `get_icons` option
    default = true
}

require("nvim-autopairs").setup({
    check_ts = true,
    ts_config = {javascript = {'string'}},
    map_complete = true, ----------------- it doesn't have map_complete
    map_cr = false, -----------------------------------------------> WRONG change to true ? where did you get that ??
    auto_select = true --- ---------- it doesn't have auto_select
})

vim.g.mkdp_preview_options = {sequence_diagrams = {theme = 'simple'}}
vim.api.nvim_exec([[
  let g:nvim_markdown_preview_theme = 'solarized-light'
]], false)
vim.g.nvim_markdown_preview_theme = 'solarized-light'

local actions = require "fzf-lua.actions"

require('fzf-lua').setup({

    -- without these options, fzf caused bugs in render
    winopts = {
        -- split         = "new",           -- open in a split instead?
        win_height = 0.85, -- window height
        win_width = 0.80, -- window width
        win_row = 0.30, -- window row position (0=top, 1=bottom)
        win_col = 0.50, -- window col position (0=left, 1=right)
        -- win_border    = false,           -- window border? or borderchars?
        win_border = {'???', '???', '???', '???', '???', '???', '???', '???'},
        window_on_create = function() -- nvim window options override
            vim.cmd("set winhl=Normal:Normal") -- popup bg match normal windows
        end
    },
    files = {
        -- previewer      = "bat",          -- uncomment to override previewer
        -- (name from 'previewers' table)
        -- set to 'false' to disable
        prompt = 'Files??? ',
        multiprocess = true, -- run command in a separate process
        git_icons = true, -- show git icons?
        file_icons = true, -- show file icons?
        color_icons = true, -- colorize file|git icons
        -- executed command priority is 'cmd' (if exists)
        -- otherwise auto-detect prioritizes `fd`:`rg`:`find`
        -- default options are controlled by 'fd|rg|find|_opts'
        -- NOTE: 'find -printf' requires GNU find
        -- cmd            = "find . -type f -printf '%P\n'",
        find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
        rg_opts = "--color=never --files --hidden --follow -g -g '.env*' !.git' -g '!tags*' -g '!*/__generated__/*' -g '!**/graphql.schema.json'",
        fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude tags",
        actions = {
            -- inherits from 'actions.files', here we can override
            -- or set bind to 'false' to disable a default action
            ["default"] = actions.file_edit,
            -- custom actions are available too
            ["ctrl-y"] = function(selected) print(selected[1]) end
        }
    },
    grep = {
        prompt = 'Rg??? ',
        input_prompt = 'Grep For??? ',
        multiprocess = true, -- run command in a separate process
        git_icons = true, -- show git icons?
        file_icons = true, -- show file icons?
        color_icons = true, -- colorize file|git icons
        -- executed command priority is 'cmd' (if exists)
        -- otherwise auto-detect prioritizes `rg` over `grep`
        -- default options are controlled by 'rg|grep_opts'
        -- cmd            = "rg --vimgrep",
        grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp",
        rg_opts = "--column --line-number --hidden -g '!.git' -g '!tags*' -g '!yarn.lock' --no-heading --color=always --smart-case --max-columns=512",
        -- set to 'true' to always parse globs in both 'grep' and 'live_grep'
        -- search strings will be split using the 'glob_separator' and translated
        -- to '--iglob=' arguments, requires 'rg'
        -- can still be used when 'false' by calling 'live_grep_glob' directly
        rg_glob = false, -- default to glob parsing?
        glob_flag = "--iglob", -- for case sensitive globs use '--glob'
        glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
        -- advanced usage: for custom argument parsing define
        -- 'rg_glob_fn' to return a pair:
        --   first returned argument is the new search query
        --   second returned argument are addtional rg flags
        -- rg_glob_fn = function(opts, query)
        --   ...
        --   return new_query, flags
        -- end,
        actions = {
            -- actions inherit from 'actions.files' and merge
            -- this action toggles between 'grep' and 'live_grep'
            ["ctrl-g"] = {actions.grep_lgrep}
            -- grep = {
            --   ["ctrl-q"] = { actions.file_sel_to_qf }
            -- }
        },
        no_header = false, -- hide grep|cwd header?
        no_header_i = false -- hide interactive header?
    }
})

require('vgit').setup({
    keymaps = {
        ['n <C-k>'] = 'hunk_up',
        ['n <C-j>'] = 'hunk_down',
        ['n <leader>gs'] = 'buffer_hunk_stage',
        ['n <leader>gr'] = 'buffer_hunk_reset',
        ['n <leader>gp'] = 'buffer_hunk_preview',
        ['n <leader>gb'] = 'buffer_blame_preview',
        -- ['n <C-g>'] = 'buffer_diff_preview',
        ['n <leader>gf'] = 'buffer_diff_preview',
        ['n <leader>gh'] = 'buffer_history_preview',
        ['n <leader>gu'] = 'buffer_reset',
        ['n <leader>gg'] = 'buffer_gutter_blame_preview',
        ['n <leader>gl'] = 'project_hunks_preview',
        ['n <leader>gd'] = 'project_diff_preview',
        ['n <leader>gq'] = 'project_hunks_qf',
        ['n <leader>gx'] = 'toggle_diff_preference'
    },
    settings = {
        hls = {
            GitBackgroundPrimary = 'NormalFloat',
            GitBackgroundSecondary = {
                gui = nil,
                fg = nil,
                bg = nil,
                sp = nil,
                override = false
            },
            GitBorder = 'LineNr',
            GitLineNr = 'LineNr',
            GitComment = 'Comment',
            GitSignsAdd = {
                gui = nil,
                fg = '#d7ffaf',
                bg = nil,
                sp = nil,
                override = false
            },
            GitSignsChange = {
                gui = nil,
                fg = '#7AA6DA',
                bg = nil,
                sp = nil,
                override = false
            },
            GitSignsDelete = {
                gui = nil,
                fg = '#e95678',
                bg = nil,
                sp = nil,
                override = false
            },
            GitSignsAddLn = 'DiffAdd',
            GitSignsDeleteLn = 'DiffDelete',
            GitWordAdd = {
                gui = nil,
                fg = nil,
                bg = '#5d7a22',
                sp = nil,
                override = false
            },
            GitWordDelete = {
                gui = nil,
                fg = nil,
                bg = '#960f3d',
                sp = nil,
                override = false
            }
        },
        live_blame = {
            enabled = true,
            format = function(blame, git_config)
                local config_author = git_config['user.name']
                local author = blame.author
                if config_author == author then author = 'You' end
                local time = os.difftime(os.time(), blame.author_time) /
                                 (60 * 60 * 24 * 30 * 12)
                local time_divisions = {
                    {1, 'years'}, {12, 'months'}, {30, 'days'}, {24, 'hours'},
                    {60, 'minutes'}, {60, 'seconds'}
                }
                local counter = 1
                local time_division = time_divisions[counter]
                local time_boundary = time_division[1]
                local time_postfix = time_division[2]
                while time < 1 and counter ~= #time_divisions do
                    time_division = time_divisions[counter]
                    time_boundary = time_division[1]
                    time_postfix = time_division[2]
                    time = time * time_boundary
                    counter = counter + 1
                end
                local commit_message = blame.commit_message
                if not blame.committed then
                    author = 'You'
                    commit_message = 'Uncommitted changes'
                    return string.format(' %s ??? %s', author, commit_message)
                end
                local max_commit_message_length = 255
                if #commit_message > max_commit_message_length then
                    commit_message = commit_message:sub(1,
                                                        max_commit_message_length) ..
                                         '...'
                end
                return string.format(' %s, %s ??? %s', author,
                                     string.format('%s %s ago', time >= 0 and
                                                       math.floor(time + 0.5) or
                                                       math.ceil(time - 0.5),
                                                   time_postfix), commit_message)
            end
        },
        live_gutter = {enabled = true},
        authorship_code_lens = {enabled = true},
        screen = {diff_preference = 'unified'},
        project_diff_preview = {
            keymaps = {
                buffer_stage = 's',
                buffer_unstage = 'u',
                stage_all = 'a',
                unstage_all = 'd',
                reset_all = 'R',
                reset = 'r'
            }
        },
        signs = {
            -- this allows lsp diagnostics to show up
            priority = 1,
            definitions = {
                GitSignsAddLn = {
                    linehl = 'GitSignsAddLn',
                    texthl = nil,
                    numhl = nil,
                    icon = nil,
                    text = ''
                },
                GitSignsDeleteLn = {
                    linehl = 'GitSignsDeleteLn',
                    texthl = nil,
                    numhl = nil,
                    icon = nil,
                    text = ''
                },
                GitSignsAdd = {
                    texthl = 'GitSignsAdd',
                    numhl = nil,
                    icon = nil,
                    linehl = nil,
                    text = '???'
                },
                GitSignsDelete = {
                    texthl = 'GitSignsDelete',
                    numhl = nil,
                    icon = nil,
                    linehl = nil,
                    text = '???'
                },
                GitSignsChange = {
                    texthl = 'GitSignsChange',
                    numhl = nil,
                    icon = nil,
                    linehl = nil,
                    text = '???'
                }
            },
            usage = {
                screen = {add = 'GitSignsAddLn', remove = 'GitSignsDeleteLn'},
                main = {
                    add = 'GitSignsAdd',
                    remove = 'GitSignsDelete',
                    change = 'GitSignsChange'
                }
            }
        },
        symbols = {void = '???'}
    }
})

vim.o.updatetime = 300
vim.o.incsearch = false
vim.wo.signcolumn = 'yes'

require('nvim_comment').setup({
    line_mapping = "<leader>??",
    operator_mapping = "<leader>??",
    comment_chunk_text_object = "ic"
})

local null_ls = require("null-ls")

local set = vim.opt

set.ignorecase = true
set.smartcase = true

require("toggleterm").setup {
    -- size can be a number or function which is passed the current terminal
    size = function(term)
        if term.direction == "horizontal" then
            return 15
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.6
        end
    end,
    -- open_mapping = [[<c-\>]],
    open_mapping = "<c-p>",
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    highlights = {
        -- highlights which map to a highlight group name and a table of it's values
        -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
        -- Normal = {
        --   guibg = <VALUE-HERE>,
        -- },
        NormalFloat = {link = 'Normal'}
        -- FloatBorder = {
        --   guifg = <VALUE-HERE>,
        --   guibg = <VALUE-HERE>,
        -- },
    },
    shade_terminals = true,
    shading_factor = 1, -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
    persist_size = true,
    direction = 'float',
    close_on_exit = true, -- close the terminal window when the process exits
    shell = vim.o.shell -- change the default shell,
    -- This field is only relevant if direction is set to 'float'
    -- float_opts = {
    --     -- The border key is *almost* the same as 'nvim_open_win'
    --     -- see :h nvim_open_win for details on borders however
    --     -- the 'curved' border is a custom border type
    --     -- not natively supported but implemented in this plugin.
    --     border = 'double',
    --     width = 40,
    --     height = 40,
    --     winblend = 3
    -- }
}

local Terminal = require('toggleterm.terminal').Terminal

local lazygit = Terminal:new({
    cmd = "lazygit",
    direction = "float",
    float_opts = {
        -- The border key is *almost* the same as 'nvim_open_win'
        -- see :h nvim_open_win for details on borders however
        -- the 'curved' border is a custom border type
        -- not natively supported but implemented in this plugin.
        border = 'double',
        height = 100
    }
})

local btm = Terminal:new({
    cmd = "btm",
    direction = "float",
    float_opts = {
        -- The border key is *almost* the same as 'nvim_open_win'
        -- see :h nvim_open_win for details on borders however
        -- the 'curved' border is a custom border type
        -- not natively supported but implemented in this plugin.
        border = 'double',
        height = 100
    }
})

TOGGLE_LAZY_GIT = function() lazygit:toggle() end
TOGGLE_BTM = function() btm:toggle() end

vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua TOGGLE_LAZY_GIT()<CR>",
                        {noremap = true, silent = true})

vim.api.nvim_set_keymap("n", "<leader>btm", "<cmd>lua TOGGLE_BTM()<CR>",
                        {noremap = true, silent = true})

-- Lua
vim.cmd [[colorscheme tokyonight]]

-- Set the behavior of tab
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2
set.expandtab = true
set.relativenumber = true
set.number = true
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'palenight',
        component_separators = {left = '???', right = '???'},
        section_separators = {left = '???', right = '???'},
        disabled_filetypes = {},
        always_divide_middle = true,
        globalstatus = false
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {
            {
                'filename',
                file_status = true,
                path = 1,
                shorting_target = 40,
                symbols = {
                    modified = '[+]', -- Text to show when the file is modified.
                    readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
                    unnamed = '[No Name]' -- Text to show for unnamed buffers.
                }
            }
        },
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
}

local keymap = vim.api.nvim_set_keymap

-- More convinient way to get back to normal mode.
keymap("i", "kj", "<Esc>", {noremap = true})
keymap("i", "jj", '<Esc>', {noremap = true})

-- Save the file.
keymap("n", "<c-s>", ":w<CR>", {noremap = true})
keymap("i", "<c-s>", "<Esc>:w<CR>a", {noremap = true})

local teleActions = require('telescope.actions')
require('telescope').setup {
    pickers = {
        buffers = {
            mappings = {
                i = {
                    ["<c-d>"] = teleActions.delete_buffer +
                        teleActions.move_to_top
                }
            }
        }
    },
    defaults = {
        mappings = {
            i = {
                ["<c-k>"] = teleActions.move_selection_previous,
                ["<c-j>"] = teleActions.move_selection_next,
                ["<c-o>"] = teleActions.send_selected_to_qflist,
                ["<c-q>"] = teleActions.send_selected_to_qflist +
                    teleActions.open_qflist,

                ["<c-n>"] = teleActions.preview_scrolling_down,
                ["<c-p>"] = teleActions.preview_scrolling_up
            }
        },
        preview = {treesitter = false}
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case" -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
    }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:

-- keymap("n", "<Leader>ff", "<cmd>lua require('telescope.builtin').git_files({hidden= true, file_ignore_patterns = {'node_modules', '.git', 'tags*'}})<CR>", { noremap = true })
keymap("n", "<Leader>ff",
       "<cmd>lua require('telescope.builtin').git_files({file_ignore_patterns = { 'tags*' }})<CR>",
       {noremap = true})

keymap("n", "<Leader>vc",
       "<cmd>lua require('telescope.builtin').find_files({ cwd = '~/.dotfiles', file_ignore_patterns = { 'git*' }, hidden = true})<CR>",
       {noremap = true})
--
keymap("n", "<Leader>ht",
       "<cmd>lua require('telescope.builtin').help_tags()<CR>", {noremap = true})
keymap("n", "<Leader>fa",
       "<cmd>lua require('telescope.builtin').grep_string()<CR>",
       {noremap = true})
-- keymap("n", "<Leader>fg", "<cmd>lua require('telescope.builtin').live_grep({hidden= true, file_ignore_patterns = { 'node_modules', '.git', 'yarn.lock', 'tags*', 'tags' }})<CR>", { noremap = true })
-- keymap("n", "<Leader>fg", "<cmd>lua require('telescope.builtin').live_grep({ hidden= true, trim = true, no-headeng = true, line-number = true, file_ignore_patterns = { 'node_modules', '.git', 'yarn.lock', 'tags*', 'tags' }})<CR>", { noremap = true })
keymap("n", "<Leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>",
       {noremap = true})

-- keymap("n", "<Leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", { noremap = true })
--
--

keymap("n", "<Leader>fp", "<cmd>lua require('fzf-lua').commands()<CR>",
       {noremap = true})

keymap("n", "<Leader>fw", "<cmd>lua require('fzf-lua').grep_cword()<CR>",
       {noremap = true})
keymap("n", "<Leader>gg",
       "<cmd>lua require('telescope.builtin').git_bcommits()<CR>",
       {noremap = true})

keymap("n", "<Leader>gl",
       "<cmd>lua require('telescope.builtin').git_status()<CR>",
       {noremap = true})

keymap("n", "<Leader>fr",
       "<cmd>lua require('telescope.builtin').git_branches()<CR>",
       {noremap = true})
keymap("n", "<Leader>fg", "<cmd>lua require('fzf-lua').live_grep()<CR>",
       {noremap = true})
keymap("n", "<Leader>fb", "<cmd>lua require('telescope.builtin').buffers()<CR>",
       {noremap = true})
keymap("n", "<Leader>/",
       "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find({sorting_strategy = 'ascending'})<CR>",
       {noremap = true})
-- nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
-- nnoremap <leader>fb <cmd>luarequire('telescope.builtin').buffers()<cr>
-- nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
--
-- :command WQ wq
-- :command Wq wq
-- :command W w
-- :command Q q

-- keymap("command", "WQ", "wq", {})
-- keymap("command", "Wq", "wq", {})
-- keymap("command", "W", "w", {})
-- keymap("command", "Q", "q", {})

-- Maps accidental "WQ" to proper save and/or quit.
keymap("c", "WQ", "wq", {})
keymap("c", "Wq", "wq", {})
keymap("c", "W", "w", {})
keymap("c", "Q", "q", {})

require'nvim-treesitter.configs'.setup {
    -- One of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = "all",

    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- List of parsers to ignore installing

    highlight = {
        -- `false` will disable the whole extension
        enable = true,

        additional_vim_regex_highlighting = false
    },
    indent = {enable = true}
}

require'lspconfig'.pyright.setup {}

vim.api.nvim_set_option('guicursor', "i:ver1")
-- vim.api.nvim_command(':NoMatchParen')
-- vim.api.nvim_set_option('smarttab', false)
-- print(vim.api.nvim_get_option('smarttab')) -- false

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldnestmax = 1

-- this allows to have no folds on file open
vim.opt.foldlevel = 10
-- -- Mappings.
-- -- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap('n', '<Leader>e',
                        '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>d[',
                        '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>d]',
                        '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>q',
                        '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- -- Use an on_attach function to only map the following keys
-- -- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    -- This disables document formatting for language servers
    client.resolved_capabilities.document_formatting = false
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD',
                                '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd',
                                '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt',
                                '<cmd>lua vim.lsp.buf.type_definition()<CR>',
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',
                                '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi',
                                '<cmd>lua vim.lsp.buf.implementation()<CR>',
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>',
                                '<cmd>lua vim.lsp.buf.signature_help()<CR>',
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa',
                                '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',
                                opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr',
                                '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
                                opts)
    --  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D',
    --                             '<cmd>lua vim.lsp.buf.type_definition()<CR>',
    --                             opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn',
                                '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>ca',
                                '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr',
                                '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ll',
    --                             '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- local servers = { 'pyright', 'rust_analyzer', 'tsserver', 'prosemd' }
local servers = {'pyright', 'tsserver'}

local lspc = require('lspconfig.configs')

-- experimental md lsp setup
lspc.zettel = {
    default_config = {
        cmd = {"/Users/endrevegh/Repos/personal/md/index-macos", "--stdio"},
        filetypes = {"markdown"},
        root_dir = function() return vim.fn.getcwd() end,
        settings = {}
    }
}

lspc.prosemd = {
    default_config = {
        -- Update the path to prosemd-lsp
        -- cmd = { "/Users/endrevegh/Downloads/prosemd-lsp-macos", "--stdio" },
        cmd = {"/Users/endrevegh/.cargo/bin/prosemd-lsp", "--stdio"},
        filetypes = {"markdown"},
        root_dir = function()
            return vim.fn.getcwd()
            -- return lsp_util.find_git_ancestor(fname) or vim.fn.getcwd()
        end,
        settings = {}
    }
}

require'lspconfig'.bashls.setup {}
require'lspconfig'.zettel.setup {on_attach = on_attach}
require'lspconfig'.prosemd.setup {on_attach = on_attach}
require'lspconfig'.terraformls.setup {filetypes = {'terraform', 'tf'}}
-- require'lspconfig'.tflint.setup {}
require'lspconfig'.rust_analyzer.setup {

    on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {
            assist = {importGranularity = "module", importPrefix = "self"},
            cargo = {loadOutDirsFromCheck = true},
            procMacro = {enable = true}
        }
    }

}
require'lspconfig'.sumneko_lua.setup {
    settings = {
        Lua = {
            diagnostics = {
                enabled = true,
                globals = {
                    "hs", "vim", "it", "describe", "before_each", "after_each",
                    "P"
                }
            },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("~/build/neovim/src/nvim/lua")] = true
                }
            }
        }
    },
    on_attach = on_attach,
    flags = {
        -- This will be the default in neovim 0.7+
        debounce_text_changes = 150
    }
}

for _, lsp in pairs(servers) do

    require('lspconfig')[lsp].setup {
        on_attach = on_attach,
        flags = {
            -- This will be the default in neovim 0.7+
            debounce_text_changes = 150
        }
    }
end

local cmp = require 'cmp'

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end
    },
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 'c'}),
        ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 'c'}),
        ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 'c'}),
        ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 'c'}),
        ['<Left>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 'c'}),
        ['<Right>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 'c'}),
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close()
        }),
        ['<CR>'] = cmp.mapping.confirm({select = true}) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
        {name = 'nvim_lsp'}, {name = 'vsnip'} -- For vsnip users.,
        , {name = "path"}
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {{name = 'buffer'}})
})

vim.g.rustfmt_command =
    '~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/rustfmt'

local prettier = require "prettier"
null_ls.setup({
    sources = {
        -- builtins.formatting.stylua,
        -- null_ls.builtins.formatting.prettier,
        require("null-ls").builtins.formatting.prettier,
        require("null-ls").builtins.formatting.lua_format,
        require("null-ls").builtins.diagnostics.eslint,
        require("null-ls").builtins.formatting.shfmt,
        require("null-ls").builtins.formatting.rustfmt.with({
            extra_args = {"--edition=2021"}
        })
        -- null_ls.builtins.diagnostics.eslint,
        --     null_ls.builtins.completion.spell,
    },
    on_attach = function(client)
        vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
            augroup END
            ]])
        -- if client.resolved_capabilities.document_formatting then
        --     -- vim.cmd("nnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.formatting()<CR>")
        --     -- vim.cmd("nnoremap <silent><buffer> <C>o :lua vim.lsp.buf.formatting()<CR>")
        --     -- format on save
        --     -- vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()")
        -- end

        if client.resolved_capabilities.document_range_formatting then
            vim.cmd(
                "xnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.range_formatting({})<CR>")
        end
    end
})

prettier.setup({
    bin = 'prettier', -- or `prettierd`
    filetypes = {
        "css", "graphql", "html", "javascript", "javascriptreact", "json",
        "less", "markdown", "scss", "typescript", "typescriptreact", "yaml"
    },
    -- prettier format options (you can use config files too. ex: `.prettierrc`)
    arrow_parens = "always",
    bracket_spacing = true,
    embedded_language_formatting = "auto",
    end_of_line = "lf",
    html_whitespace_sensitivity = "css",
    jsx_bracket_same_line = false,
    jsx_single_quote = false,
    print_width = 80,
    prose_wrap = "preserve",
    quote_props = "as-needed",
    semi = true,
    single_quote = false,
    tab_width = 2,
    trailing_comma = "es5",
    use_tabs = false,
    vue_indent_script_and_style = false
})
-- keymap("n", "<Leader>fm", "<cmd>lua require('zettle').hello()<CR>", { noremap = true })

-- keymap("n", "<leader><leader>x", "<cmd>w<CR><cmd>source %<CR>", {noremap = true})
keymap("n", "<leader><leader>x", "<cmd>w<CR><cmd>node %<CR>", {noremap = true})
-- keymap("n", "<leader><leader>x", "<cmd>source %<CR>", { noremap = true })

-- adding return sign
vim.api.nvim_command('set listchars=eol:???')
vim.api.nvim_command('set list')

keymap('n', '<leader>wh', '<C-W>h', {noremap = true}) -- , 'goto window left' )
keymap('n', '<leader>wj', '<C-W>j', {noremap = true}) -- , 'goto window down' )
keymap('n', '<leader>wk', '<C-W>k', {noremap = true}) -- , 'goto window up' )
keymap('n', '<leader>wl', '<C-W>l', {noremap = true}) -- , 'goto window right' )
keymap('n', '<leader>wd', '<C-W>c', {noremap = true}) -- , 'delete window' )
keymap('n', '<leader>wD', '<C-W>o', {noremap = true}) -- , 'delete other windows' )
keymap('n', '<leader>ws', '<CMD>split<CR>', {noremap = true}) -- ,'split window' )
keymap('n', '<leader>wv', '<CMD>vsplit<CR>', {noremap = true}) -- , 'vertical split window' )
keymap('n', '<leader>wL', '<cmd>20winc ><CR>', {noremap = true}) -- ,  'inc width??' )
keymap('n', '<leader>wH', '<Plug>DecWidth', {noremap = true}) -- ,  'dec width??' )
keymap('n', '<leader>wK', '<Plug>IncHeight', {noremap = true}) -- , 'inc height??' )
keymap('n', '<leader>wJ', '<Plug>DecHeight', {noremap = true}) -- , 'dec height??' )

-- closing quickfix and locallist
keymap('n', '<leader>cc', '<cmd>cclose<CR>', {noremap = true}) -- , 'inc height??' )
keymap('n', '<leader>lc', '<cmd>lclose<CR>', {noremap = true}) -- , 'inc height??' )

keymap('n', '<leader>co', '<cmd>copen<CR>', {noremap = true}) -- , 'inc height??' )
keymap('n', '<leader>lo', '<cmd>lopen<CR>', {noremap = true}) -- , 'inc height??' )

keymap('n', '<leader>cn', '<cmd>cnext<CR>', {noremap = true}) -- , 'inc height??' )
keymap('n', '<leader>ln', '<cmd>lnext<CR>', {noremap = true}) -- , 'inc height??' )
keymap('n', '<leader>cp', '<cmd>cprev<CR>', {noremap = true}) -- , 'inc height??' )
keymap('n', '<leader>lp', '<cmd>lprev<CR>', {noremap = true}) -- , 'inc height??' )

keymap('n', '<leader>cm', '<cmd>DiffviewOpen main<CR>', {noremap = true}) -- , 'inc height??' )

-- Reloads config file from everywhere.
keymap('n', '<leader>rr', '<cmd>source ~/.config/nvim/init.lua<CR>',
       {noremap = true})

-- keymap('n', '<leader><leader>f', '<cmd>Neotree<CR>', {noremap = true})

keymap('n', '<F2>', '<cmd>Neotree<CR>', {noremap = true})
require('close_buffers').setup({
    filetype_ignore = {}, -- Filetype to ignore when running deletions
    file_glob_ignore = {}, -- File name glob pattern to ignore when running deletions (e.g. '*.md')
    file_regex_ignore = {}, -- File name regex pattern to ignore when running deletions (e.g. '.*[.]md')
    preserve_window_layout = {'this', 'nameless'}, -- Types of deletion that should preserve the window layout
    next_buffer_cmd = nil -- Custom function to retrieve the next buffer when preserving window layout
})

vim.api.nvim_set_keymap('n', '<leader>td',
                        "<CMD>lua require('close_buffers').delete({type = 'this'})<CR>",
                        {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>tw',
                        "<CMD>lua require('close_buffers').delete({type = 'other'})<CR>",
                        {noremap = true, silent = true})

-- disable arrows
keymap('n', '<up>', '<nop>', {noremap = true})
keymap('n', '<down>', '<nop>', {noremap = true})
keymap('n', '<left>', '<nop>', {noremap = true})
keymap('n', '<right>', '<nop>', {noremap = true})
keymap('i', '<up>', '<nop>', {noremap = true})
keymap('i', '<down>', '<nop>', {noremap = true})
keymap('i', '<left>', '<nop>', {noremap = true})
keymap('i', '<right>', '<nop>', {noremap = true})

keymap("n", "<Leader>web",
       "<cmd>lua require('telescope.builtin').git_files({ cwd = '~/Repos/formidable/puma/', file_ignore_patterns = { 'tags*' }})<CR>",
       {noremap = true})

keymap("n", "<Leader>app",
       "<cmd>lua require('telescope.builtin').git_files({ cwd = '~/Repos/formidable/puma-app/', file_ignore_patterns = { 'tags*' }})<CR>",
       {noremap = true})
keymap("n", "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>",
       {desc = "ToggleTerm horizontal split"})
keymap("n", "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>",
       {desc = "ToggleTerm vertical split"})
keymap("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",
       {desc = "ToggleTerm float"})
keymap("n", "<C-Up>", "<cmd>resize -2<CR>", {desc = "Resize split up"})
keymap("n", "<C-Down>", "<cmd>resize +2<CR>", {desc = "Resize split down"})
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>",
       {desc = "Resize split left"})
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>",
       {desc = "Resize split right"})
keymap("n", "<leader>m", ":MarkdownPreview<cr>", {desc = "Resize split right"})

require'lspconfig'.html.setup {on_attach = on_attach}
vim.g.t_Co = 256

-- utils

local removePackage =
    function(packageName) package.loaded[packageName] = nil end

local assignPackage = function(packageName)
    package.loaded[packageName] = require(packageName)
end

R = function(packageName)
    removePackage(packageName)
    assignPackage(packageName)
end

vim.cmd [[:autocmd InsertEnter * set cul
:autocmd InsertLeave * set nocul]]

-- issue when opening a file with telescope intterupts folds, need to make it for other events, like focus.
vim.api.nvim_create_autocmd({"BufEnter"},
                            {pattern = {"*"}, command = "normal zx"})

require('zettelkasten').setup({
    root_dir = "/Users/endrevegh/Dropbox/obsidian/personal/journal"
})

vim.api.nvim_set_keymap("n", "<leader>pd",
                        "<cmd> lua require('zettelkasten').daily_journal()<CR>",
                        {noremap = true})
