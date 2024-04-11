------------------------
-- NVIM CONFIGURATION --
------------------------

-- modified from https://github.com/NormTurtle/Windots/blob/main/vi/init.lua


-- Options --
vim.g.mapleader = " " -- sets leader key to <SPACE>
vim.opt.spell = true -- set spell on
vim.opt.spelllang = "en_us"
vim.opt.title = true -- show title
vim.opt.keywordprg = ":help" -- Replace :man with :help, fix `K` freeze | :h keywordprg
vim.opt.syntax = "ON" -- maybe just set syntax
vim.opt.backup = false -- set backup
vim.opt.cursorline = true -- current line Highlight
vim.opt.number = true -- turn on line numbers
vim.opt.ignorecase = true -- enable case insensitive searching
vim.opt.smartcase = true -- all searches are case insensitive unless there's a capital letter
vim.opt.hlsearch = true -- disable all highlighted search results
vim.opt.incsearch = true -- enable incremental searching
vim.opt.wrap = false -- enable text wrapping
vim.opt.fileencoding = "utf-8" -- encoding set to utf-8
vim.opt.showtabline = 1 -- always show the tab line  1 = if at-least 2 tab, 2 = always, 0 = never
vim.opt.laststatus = 2 -- always show statusline
vim.opt.expandtab = false -- expand tab
vim.opt.smarttab = true --
vim.opt.smartindent = true
vim.opt.scrolloff = 8 -- scroll page when cursor is 8 lines from top/bottom
vim.opt.sidescrolloff = 8 -- scroll page when cursor is 8 spaces from left/right
vim.opt.guifont = "monospace:h17"
vim.opt.wildignore = "*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx" -- files that u never want to edit
vim.opt.termguicolors = true -- terminal gui colors
vim.opt.background = "dark" -- use dark theme only
vim.cmd('colorscheme rose-pine-main')

-- Undo --
vim.opt.undodir = vim.fn.stdpath("data") .. "/vi/undo"
vim.opt.undofile = true

-- KEYBINDS --
local map = vim.keymap.set -- Functional wrapper for mapping custom keybindings

-- Line movement Soft wrap movement fix
map("n", "j", "gj") -- move vert by visual line
map("n", "k", "gk") -- move vert by visual line
-- HL as amplified versions of hjkl
map({ "n", "v" }, "H", "0^") -- "beginning of line"
map({ "n", "v" }, "L", "$") --"end of line" ,
map({ "n", "v" }, "M", "gm") --"middle of line" ,

-- Easy way to get back to normal mode from home row
map("i", "kj", "<Esc>") -- kj simulates ESC
map("i", "jk", "<Esc>") -- jk simulates ESC

-- buffer navigation
map("n", "<leader>n", ":bnext <CR>") --  to next buffer
map("n", "<leader>b", ":bprevious <CR>") -- to previous buffer
map("n", "<leader>d", ":bd! <CR>") -- Space+d delets current buffer

-- Clipboard
map({ "i", "c" }, "<C-v>", "<C-R>+", { desc = "Paste from clipboard" })
map({ "n", "v" }, "<C-v>", '"+gP', { desc = "Paste from clipboard" })
map({ "n", "v" }, "<C-c>", '"+y', { desc = "Copy to clipboard" })
map({ "v" }, "<C-x>", '"+x', { desc = "Cut to clipboard" })
map("x", "p", [["_dP]]) -- paste text but DONT copy the overidden text
map({ "n", "v" }, "<leader>d", [["_d]]) -- delete text but DONT copy to clipboard

-- Align
map({ "n", "i" }, "<A-j>", "<Esc>:m .+1<CR>==") -- Move current line down
map({ "n", "i" }, "<A-k>", "<Esc>:m .-2<CR>==") -- Move current line up
map("v", "<A-j>", ":m '>+1<CR>gv=gv") -- Move current line down
map("v", "<A-k>", ":m '<-2<CR>gv=gv") -- Move current line up
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '>-2<CR>gv=gv")

-- Misc
map("v", "<leader>sr", '"hy:%s/<C-r>h//g<left><left>') -- Replace all instances of highlighted words
map("n", "<C-z>", ":setlocal spell! spelllang=en_us<CR>") -- Spell-check on\off

-- AUTOCOMMANDS --

------------------------------
-- Mode based Cursorline --
vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = function()
        vim.o.cursorline = false
    end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
        vim.o.cursorline = true
    end,
})

-- Restore cursor position
--vim.api.nvim_create_augroup("general", {})
--vim.api.nvim_create_autocmd("BufReadPost", {
--    group = "general",
--    desc = "Restore last cursor position in file",
--    callback = function()
--        if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
--            vim.fn.setpos(".", vim.fn.getpos("'\""))
--        end
--    end,
--})
vim.cmd[[
augroup RestoreCursor
  autocmd!
  autocmd BufRead * autocmd FileType <buffer> ++once
    \ let s:line = line("'\"")
    \ | if s:line >= 1 && s:line <= line("$") && &filetype !~# 'commit'
    \      && index(['xxd', 'gitrebase'], &filetype) == -1
    \ |   execute "normal! g`\""
    \ | endif
augroup END

]]
--vim.api.nvim_create_autocmd("BufWrite",
--	{
--		pattern = "*",
--		callback = function()
--			vim.cmd [[%s/\s\+$//e]] -- remove trailing whitespace
--			vim.cmd [[%s/\n\+\%$//e]] -- remove trailing newlines
--			vim.lsp.buf.format()
--		end
--	})
------------------------------

------------------------------
-- FileBrowser --
map("n", "<leader>e", ":Lex<CR>") -- space+e toggles netrw tree view
map("n", "<leader>o", ":Explore<CR>") -- Open file-picker
vim.g.netrw_browse_split = 4 -- open in prior window
vim.g.netrw_keepdir = 0 -- Sync current directory with browsing directory
vim.g.netrw_altv = 1 -- change from left splitting to right splitting
vim.g.netrw_banner = 0 -- gets rid of the annoying banner for netrw
vim.g.netrw_liststyle = 3 -- tree style view in netrw
vim.g.netrw_winsize = 15 -- window size
vim.cmd("let g:netrw_list_hide=netrw_gitignore#Hide()")
-- Netrw Keymaps
local function netrw_mapping()
    local bufmap = function(lhs, rhs)
        local opts = { buffer = true, remap = true }
        vim.keymap.set("n", lhs, rhs, opts)
    end

    --  -- close window
    --  bufmap('<leader>e', ':Lexplore<cr>')
    --  bufmap('<leader>E', ':Lexplore<cr>')

    -- Go back in history
    bufmap("H", "u")

    -- Go up a directory
    bufmap("h", "-^")

    -- Open file/directory
    bufmap("l", "<cr>")

    -- Open file/directory then close explorer
    bufmap("L", "<cr>:Lexplore<CR>")

    -- Toggle dotfiles
    bufmap(".", "gh")
end
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    group = group,
    desc = "Keybindings for netrw",
    callback = netrw_mapping,
})
------------------------------

------------------------------

------------------------------
-- Completion from :h ins-completion --
vim.opt.omnifunc = "syntaxcomplete#Complete" -- Auto Completion - Enable Omni complete features
vim.cmd("set complete+=k") -- Enable Spelling Suggestions for Auto-Completion:
vim.opt.completeopt = { "menu", "menuone", "noinsert" }
vim.cmd([[
" Minimalist-Tab Complete
	inoremap <expr> <Tab> TabComplete()
	fun! TabComplete()
	    if getline('.')[col('.') - 2] =~ '\K' || pumvisible()
	        return "\<C-N>"
	    else
	        return "\<Tab>"
	    endif
	endfun
""""""""""""""""""""""""""""""""""""""""
" Minimalist-Autocomplete
	inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"
	autocmd InsertCharPre * call AutoComplete()
	fun! AutoComplete()
	    if v:char =~ '\K'
	        \ && getline('.')[col('.') - 4] !~ '\K'
	        \ && getline('.')[col('.') - 3] =~ '\K'
	        \ && getline('.')[col('.') - 2] =~ '\K' " last char
	        \ && getline('.')[col('.') - 1] !~ '\K'

	        call feedkeys("\<C-N>", 'n')
	    end
	endfun
]])
-- Automatically Pair brackets, parethesis, and quotes
map("i", "'", "''<left>")
map("i", '"', '""<left>')
map("i", "(", "()<left>")
map("i", "[", "[]<left>")
map("i", "{", "{}<left>")
map("i", "{;", "{};<left><left>")
map("i", "/*", "/**/<left><left>")
--------------------------------


