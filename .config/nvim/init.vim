call plug#begin("~/.config/nvim/plugins")

Plug 'Mofiqul/vscode.nvim' " theme
Plug 'akinsho/nvim-bufferline.lua' " buffer_line
Plug 'NTBBloodbath/galaxyline.nvim' , {'branch': 'main'} " status_line
Plug 'lukas-reineke/indent-blankline.nvim' " indentation_guides
Plug 'kyazdani42/nvim-web-devicons' " devicons
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " treesitter
Plug 'lewis6991/gitsigns.nvim' " gitsigns
Plug 'akinsho/toggleterm.nvim' " terminal_emulator
Plug 'williamboman/nvim-lsp-installer' " completion_server_installer
Plug 'neovim/nvim-lspconfig' " completion_server_configuration
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-emoji'
Plug 'hrsh7th/nvim-cmp' " completion_menu
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip' " snippet_engine
Plug 'norcalli/nvim-colorizer.lua' " colorizer
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim' " fuzzy_finder
Plug 'nvim-lua/popup.nvim'
Plug 'jvgrootveld/telescope-zoxide' " change_directory
Plug 'mhartington/formatter.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'numToStr/Comment.nvim'

call plug#end()

" general settings and mappings {{{
let g:mapleader = "\<Space>"

set noshowmode
set cindent
set tabstop=4
set shiftwidth=4
set smartindent
set number
set relativenumber
set numberwidth=2
set nowrap
set expandtab
set undofile
set undodir=~/.config/nvim/undodir
set cursorline
set mouse=a
set foldmethod=marker
set guifont=Iosevka\ Nerd\ Font,Laila,Noto\ Color\ Emoji:h13
set guifontwide=Laila
set laststatus=3
set signcolumn=yes:2
set shell=zsh
set hidden
set termguicolors
set ignorecase
set smartcase
set updatetime=300
set title
set pumheight=10
set fillchars=eob:\ 
set timeoutlen=400
set completeopt=menu,menuone,noselect
set scrolloff=4
set sidescrolloff=4
set splitright
set splitbelow

inoremap jk <esc>
inoremap <M-v> "+p
nnoremap <M-v> "+p
vnoremap <M-c> "+y
nnoremap <silent><tab> :bn!<cr>
nnoremap <silent><S-tab> :bp!<cr>
nnoremap <silent><leader>d :bd<cr>
nnoremap <silent><leader>w <C-w>

" gitsigns mappings
nnoremap <silent><leader>gd :silent! Gitsigns diffthis<cr>
nnoremap <silent><leader>gj :silent! Gitsigns next_hunk<cr>
nnoremap <silent><leader>gk :silent! Gitsigns prev_hunk<cr>

" telescope mappings
nnoremap <silent><leader>ff :silent! Telescope find_files theme=dropdown<cr>
nnoremap <silent><leader>fh :silent! Telescope oldfiles theme=dropdown<cr>
nnoremap <silent><leader>fH :silent! Telescope help_tags theme=dropdown<cr>
nnoremap <silent><leader>fl :silent! Telescope grep_string theme=dropdown<cr>
nnoremap <silent><leader>fb :silent! Telescope buffers theme=dropdown<cr>
nnoremap <silent><leader>fk :silent! Telescope keymaps theme=dropdown<cr>
nnoremap <silent><leader>fd :silent! Telescope zoxide list theme=dropdown<cr>
nnoremap <silent><leader>fM :silent! Telescope man_pages theme=dropdown<cr>

" formatter mappings
nnoremap <silent><leader>fm :silent! Format<cr>

" neovide settings
let g:neovide_cursor_antialiasing=v:true
let g:neovide_cursor_vfx_mode="railgun"
let g:neovide_scroll_animation_length=0
let g:neovide_floating_opacity=0.9

" mappings for neovide
let g:def_font_size = 13
let g:var_font_size = g:def_font_size
let g:tmp_font = "Iosevka\\ Nerd\\ Font,Laila,Noto\\ Color\\ Emoji:h"

func ResetFontSize()
    let g:var_font_size = g:def_font_size
    silent! call feedkeys(":silent! set guifont=".g:tmp_font.g:var_font_size."\<cr>")
endf

func ChangeFontSize(change)
    let g:var_font_size = g:var_font_size + a:change
    silent! call feedkeys(":silent! set guifont=".g:tmp_font.g:var_font_size."\<cr>")
endf

nnoremap <silent><leader>- :silent! call ChangeFontSize(-2)<cr>
nnoremap <silent><leader>= :silent! call ChangeFontSize(2)<cr>
nnoremap <silent><leader><bs> :silent! call ResetFontSize()<cr>
"}}}

" lsp_config {{{
lua <<EOF
local servers = { 'pyright', 'ccls', 'tsserver', 'sumneko_lua' }

require("nvim-lsp-installer").setup({
    ensure_installed = servers,
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ui = {
        icons = {
            server_installed = "✓ ",
            server_pending = "➜ ",
            server_uninstalled = "✗ "
        }
    }
})

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>j', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>k', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>c', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
end

vim.diagnostic.config({
    virtual_text = {
        prefix = '•',
    },
    signs = true,
    underline = true,
    update_in_insert = true,
    severity_sort = false,
})

vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#272727]]
vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white]]

local border = {
      {"╭", "FloatBorder"},
      {"─", "FloatBorder"},
      {"╮", "FloatBorder"},
      {"│", "FloatBorder"},
      {"╯", "FloatBorder"},
      {"─", "FloatBorder"},
      {"╰", "FloatBorder"},
      {"│", "FloatBorder"},
}
local width = 50
local height = 15

local handlers =  {
    ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border, max_width = width, max_height = height }),
    ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border, max_width = width, max_height = height }),
}

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

for _, lsp in pairs(servers) do
    require('lspconfig')[lsp].setup {
        on_attach = on_attach,
        handlers = handlers,
        flags = {
            -- This will be the default in neovim 0.7+
            debounce_text_changes = 150,
        }
    }
end
EOF
" }}}

" nvim_cmp {{{
lua <<EOF
    local cmp = require'cmp'
    local luasnip = require'luasnip'

    kind_icons = {
        Class = " ",
        Color = " ",
        Constant = "ﲀ ",
        Constructor = " ",
        Enum = "練",
        EnumMember = " ",
        Event = " ",
        Field = " ",
        File = "",
        Folder = " ",
        Function = " ",
        Interface = "ﰮ ",
        Keyword = " ",
        Method = " ",
        Module = " ",
        Operator = "",
        Property = " ",
        Reference = " ",
        Snippet = " ",
        Struct = " ",
        Text = " ",
        TypeParameter = " ",
        Unit = "塞",
        Value = " ",
        Variable = " ",
    }

    source_names = {
        -- cmp_tabnine = "(Tabnine)",
        -- tmux = "(TMUX)",
        -- vsnip = "(Snippet)",
        nvim_lsp = "(LSP)",
        emoji = "(Emoji)",
        path = "(Path)",
        calc = "(Calc)",
        luasnip = "(Snippet)",
        buffer = "(Buffer)",
    }

    cmp.setup({
        completion = {
            keyword_length = 1,
        },

        experimental = {
            ghost_text = true,
            native_menu = false,
        },

        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                local max_width = 65
                if max_width ~= 0 and #vim_item.abbr > max_width then
                    vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. "… "
                end
                vim_item.kind = kind_icons[vim_item.kind]
                vim_item.menu = source_names[entry.source.name]
                return vim_item
            end,
        },

        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },

        window = {
            completion = cmp.config.window.bordered(),
            documentation = {
                border = "rounded",
                max_width = 50,
                max_height = 15,
            }
        },

        mapping = cmp.mapping.preset.insert({
            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
        }),

        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
        }, {
            { name = 'buffer' },
            { name = 'path' },
            { name = 'emoji' },
        })
    })
EOF
" }}}

" bufferline {{{
lua <<EOF
require("bufferline").setup({
    options = {
        buffer_close_icon = "",
        close_command = "bd",
        close_icon = " ",
        indicator_icon = " ",
        left_trunc_marker = " ",
        modified_icon = "•",
        offsets = { { filetype = "NvimTree", text = "EXPLORER", text_align = "center" } },
        right_mouse_command = "bd!",
        right_trunc_marker = " ",
        show_close_icon = false,
        show_tab_indicators = true,
    },
    highlights = {
        fill = {
            guifg = { attribute = "fg", highlight = "Normal" },
            guibg = { attribute = "bg", highlight = "StatusLineNC" },
        },
        background = {
            guifg = { attribute = "fg", highlight = "Normal" },
            guibg = { attribute = "bg", highlight = "StatusLine" },
        },
        buffer_visible = {
            guifg = { attribute = "fg", highlight = "Normal" },
            guibg = { attribute = "bg", highlight = "Normal" },
        },
        buffer_selected = {
            guifg = { attribute = "fg", highlight = "Normal" },
            guibg = { attribute = "bg", highlight = "Normal" },
            gui = "bold",
        },
        separator = {
            guifg = { attribute = "bg", highlight = "Normal" },
            guibg = { attribute = "bg", highlight = "StatusLine" },
        },
        separator_selected = {
            guifg = { attribute = "fg", highlight = "Special" },
            guibg = { attribute = "bg", highlight = "Normal" },
        },
        separator_visible = {
            guifg = { attribute = "fg", highlight = "Normal" },
            guibg = { attribute = "bg", highlight = "StatusLineNC" },
        },
        close_button = {
            guifg = { attribute = "fg", highlight = "Normal" },
            guibg = { attribute = "bg", highlight = "StatusLine" },
        },
        close_button_selected = {
            guifg = { attribute = "fg", highlight = "Normal" },
            guibg = { attribute = "bg", highlight = "Normal" },
        },
        close_button_visible = {
            guifg = { attribute = "fg", highlight = "Normal" },
            guibg = { attribute = "bg", highlight = "Normal" },
        },
        modified = {
            guibg = { attribute = "bg", highlight = "StatusLine" },
        },
        modified_selected = {
            guibg = { attribute = "bg", highlight = "Normal" },
        },
        modified_visible = {
            guibg = { attribute = "bg", highlight = "Normal" },
        },
    },
})
EOF
"}}}

" galaxyline {{{
lua <<EOF
local gl = require('galaxyline')

local status_line = {}
local colors = {}

colors.fg = function()
    if vim.g.vscode_style == 'dark' then
        return '#ffffff'
    else
        return '#343434'
    end
end

colors.bg = function()
    if vim.g.vscode_style == 'dark' then
        return '#252526'
    else
        return '#f3f3f3'
    end
end

colors.green = function()
    if vim.g.vscode_style == 'dark' then
        return '#619955'
    else
        return '#008000'
    end
end

colors.bluegreen = function()
    if vim.g.vscode_style == 'dark' then
        return '#4ec9b0'
    else
        return '#16825d'
    end
end

colors.yellow = function()
    if vim.g.vscode_style == 'dark' then
        return '#ffaf00'
    else
        return '#795e26'
    end
end

colors.pink = function()
    if vim.g.vscode_style == 'dark' then
        return '#c586c0'
    else
        return '#af00db'
    end
end

colors.yelloworrange = function()
    return '#d7ba7d'
end

colors.blue = function()
    return '#0a7aca'
end

colors.red = function()
    return '#f44747'
end

colors.lightblue = function()
    return '#5CB6F8'
end

local condition = require('galaxyline.condition')
local gls = gl.section
gl.short_line_list = { 'NvimTree', 'vista', 'dbui', 'packer' }

gls.left[1] = {
    FirstElement = {
        provider = function()
            return ' '
        end,
        highlight = { colors.bg, colors.bg },
    },
}

gls.left[2] = {
    ViMode = {
        provider = function()
            local mode_text = {
                n      = 'NOR',
                i      = 'INS',
                V      = 'VIS',
                v      = 'VIS',
                R      = 'RPL',
                c      = 'CMD',
                [''] = 'VIB'
            }

            return mode_text[vim.fn.mode()]
        end,
        separator = ' ',
        separator_highlight = { colors.bg, colors.bg },
        highlight = { colors.blue, colors.bg, 'bold' },
    },
}

gls.left[3] = {
    GitIcon = {
        provider = function()
            return ''
        end,
        condition = condition.check_git_workspace,
        separator = ' ',
        separator_highlight = { colors.bg, colors.bg },
        highlight = { colors.pink, colors.bg },
    },
}

gls.left[4] = {
    GitBranch = {
        provider = 'GitBranch',
        condition = condition.check_git_workspace,
        separator = ' ',
        separator_highlight = { colors.bg, colors.bg },
        highlight = { colors.pink, colors.bg },
    },
}

gls.left[6] = {
    DiagnosticError = {
        provider = 'DiagnosticError',
        icon = ' ',
        highlight = { colors.red, colors.bg },
    },
}
gls.left[7] = {
    DiagnosticWarn = {
        provider = 'DiagnosticWarn',
        icon = ' ',
        highlight = { colors.yellow, colors.bg },
    },
}

gls.left[8] = {
    DiagnosticHint = {
        provider = 'DiagnosticHint',
        icon = ' ',
        highlight = { colors.pink, colors.bg },
    },
}

gls.left[9] = {
    DiagnosticInfo = {
        provider = 'DiagnosticInfo',
        icon = ' ',
        highlight = { colors.lightblue, colors.bg },
    },
}

-- Right Side
gls.right[1] = {
    FileSize = {
        provider = 'FileSize',
        condition = condition.buffer_not_empty,
        highlight = { colors.fg, colors.bg },
    },
}

gls.right[4] = {
    FileEncode = {
        provider = 'FileEncode',
        condition = condition.buffer_not_empty,
        separator = '',
        separator_highlight = { colors.bg, colors.bg },
        highlight = { colors.fg, colors.bg, 'bold,underline' },
    },
}

gls.right[5] = {
    FileFormat = {
        provider = 'FileFormat',
        condition = condition.buffer_not_empty,
        separator = ' ',
        condition = condition.buffer_not_empty,
        separator_highlight = { colors.bg, colors.bg },
        highlight = { colors.fg, colors.bg, 'bold,underline' },
    },
}

gls.right[6] = {
    FileIcon = {
        provider = 'FileIcon',
        condition = condition.buffer_not_empty,
        separator = ' ',
        separator_highlight = { colors.bg, colors.bg },
        highlight = { require('galaxyline.providers.fileinfo').get_file_icon_color, colors.bg },
    },
}

gls.right[7] = {
    ShowLspClient = {
        provider = 'GetLspClient',
        condition = function()
            local tbl = { ['dashboard'] = true, [''] = true }
            if tbl[vim.bo.filetype] then
                return false
            end
            return true
        end,
        separator = '',
        separator_highlight = { colors.bg, colors.bg },
        highlight = { require('galaxyline.providers.fileinfo').get_file_icon_color, colors.bg },
    },
}

gls.right[8] = {
    LastElement = {
        provider = function()
            return ' '
        end,
        highlight = { colors.bg, colors.bg },
    },
}

gls.short_line_left[1] = {
    BufferType = {
        provider = 'FileTypeName',
        highlight = { colors.blue, colors.bg, 'bold' },
    },
}

gls.short_line_left[2] = {
    SFileName = {
        provider = 'SFileName',
        condition = condition.buffer_not_empty,
        highlight = { colors.bg, colors.bg },
    },
}

gls.short_line_right[1] = {
    BufferIcon = {
        provider = 'BufferIcon',
        highlight = { colors.bg, colors.bg },
    },
}

EOF
"}}}

" indent_blankline {{{
lua <<EOF
vim.opt.list = true

require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    -- show_current_context_start = true,
    use_treesitter = true,
    show_trailing_blankline_indent = false,
}
EOF
"}}}

" treesitter {{{
lua <<EOF
require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = { "c", "lua", "cpp", "vim" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- List of parsers to ignore installing (for "all")
    ignore_install = { "javascript" },

    highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        -- disable = { "c", "rust" },

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}

-- nvim-colorizer settings
require'colorizer'.setup()

-- treesitter autopairs
require("nvim-treesitter.configs").setup { autopairs = { enable = true } }
EOF
"}}}

" gitsigins {{{
lua <<EOF
require('gitsigns').setup {
    signs = {
        add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
        change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        delete       = {hl = 'GitSignsDelete', text = '│', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        topdelete    = {hl = 'GitSignsDelete', text = '│', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
        changedelete = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    },

    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`

    watch_gitdir = {
        interval = 1000,
        follow_files = true
    },

    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`

    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
    },

    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,

    preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },

    yadm = {
        enable = false
    },
}
EOF
"}}}

" terminal_emulator {{{
let g:terminal_color_0="#1e1e1e"
let g:terminal_color_1="#e73c50"
let g:terminal_color_2="#a6e22e"
let g:terminal_color_3="#e6db74"
let g:terminal_color_4="#66d9ef"
let g:terminal_color_5="#ae81ff"
let g:terminal_color_6="#a1efe4"
let g:terminal_color_7="#e8e8e3"
let g:terminal_color_8="#64645e"
let g:terminal_color_9="#f92772"
let g:terminal_color_10="#9ec400"
let g:terminal_color_11="#e7c547"
let g:terminal_color_12="#7aa6da"
let g:terminal_color_13="#b77ee0"
let g:terminal_color_14="#54ced6"
let g:terminal_color_15="#dfdfdf"

lua <<EOF
require("toggleterm").setup {
    -- on_open = fun(t: Terminal), -- function to run when the terminal opens
    -- on_close = fun(t: Terminal), -- function to run when the terminal closes
    -- on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
    -- on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
    -- on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
    -- shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    -- shell = vim.o.shell, -- change the default shell
    -- This field is only relevant if direction is set to 'float'
    open_mapping = [[<c-t>]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = true,
    start_in_insert = true,
    insert_mappings = false, -- whether or not the open mapping applies in insert mode
    terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
    persist_size = true,
    direction = 'float', --'vertical' | 'horizontal' | 'tab' | 'float',
    close_on_exit = true, -- close the terminal window when the process exits
    float_opts = {
        border = 'curved',
        width = 150,
        height = 20,
        winblend = 2,
    }
}
EOF
" }}}

" telescope {{{
lua <<EOF

require'telescope'.load_extension('zoxide')

require'telescope'.setup {
    defaults = {
        prompt_prefix = '   ',
        selection_caret = ' ',
        path_display = function(opts, path)
            local tail = require("telescope.utils").path_tail(path)
            return string.format(" %s (%s)", tail, path)
        end,
    }
}
EOF
" }}}

" formatter {{{
lua <<EOF
require('formatter').setup({
    filetype = {
        javascript = {
            function()
                return {
                    exe = "prettier",
                    args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), '--single-quote', '--tab-width 4'},
                    stdin = true
                }
            end
        },

        sh = {
            function()
                return {
                    exe = "shfmt",
                    args = { "-i", 4 },
                    stdin = true,
                }
            end,
        },

        zsh = {
            function()
                return {
                    exe = "shfmt",
                    args = { "-i", 4 },
                    stdin = true,
                }
            end,
        },

        bash = {
            function()
                return {
                    exe = "shfmt",
                    args = { "-i", 4 },
                    stdin = true,
                }
            end,
        },

        lua = {
            function()
                return {
                    exe = "stylua",
                    args = {
                        "--indent-type Spaces",
                        "--indent-width 4",
                        -- "--config-path "
                        -- .. os.getenv("XDG_CONFIG_HOME")
                        -- .. "/stylua/stylua.toml",
                        "-",
                    },
                    stdin = true,
                }
            end,
        },

        c = {
            function()
                return {
                    exe = "clang-format",
                    args = {"--assume-filename", vim.api.nvim_buf_get_name(0), '-style="{IndentWidth: 4}"'},
                    stdin = true,
                    cwd = vim.fn.expand('%:p:h')  -- Run clang-format in cwd of the file.
                }
            end
        },

        cpp = {
            function()
                return {
                    exe = "clang-format",
                    args = {"--assume-filename", vim.api.nvim_buf_get_name(0), '-style="{IndentWidth: 4}"'},
                    stdin = true,
                    cwd = vim.fn.expand('%:p:h')  -- Run clang-format in cwd of the file.
                }
            end
        },

        h = {
            function()
                return {
                    exe = "clang-format",
                    args = {"--assume-filename", vim.api.nvim_buf_get_name(0), '-style="{IndentWidth: 4}"'},
                    stdin = true,
                    cwd = vim.fn.expand('%:p:h')  -- Run clang-format in cwd of the file.
                }
            end
        },

        hpp = {
            function()
                return {
                    exe = "clang-format",
                    args = {"--assume-filename", vim.api.nvim_buf_get_name(0), '-style="{IndentWidth: 4}"'},
                    stdin = true,
                    cwd = vim.fn.expand('%:p:h')  -- Run clang-format in cwd of the file.
                }
            end
        },
    }
})
EOF
" }}}

" nvim-autopairs {{{
lua <<EOF
require('nvim-autopairs').setup({
    check_ts = true,
    ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
    },
    fast_wrap = {
        map = [[<M-e>]]
    },
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
EOF
" }}}

" comment_nvim {{{
lua <<EOF
require('Comment').setup({
    padding = true,
    sticky = true,
    ignore = nil,
    toggler = {
        line = 'gcc',
        block = 'gbc',
    },
    opleader = {
        line = 'gc',
        block = 'gb',
    },
    extra = {
        above = 'gcO',
        below = 'gco',
        eol = 'gcA',
    },
    mappings = {
        basic = true,
        extra = true,
        extended = false,
    },
    pre_hook = nil,
    post_hook = nil,
})
EOF
" }}}

let g:vscode_style = "dark"
colorscheme vscode
