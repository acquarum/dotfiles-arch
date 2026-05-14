vim.opt.number = true -- Make line numbers default (default: false)
vim.opt.numberwidth = 4 -- Set number column width to 4 {default 4} (default: 4)
vim.opt.termguicolors = true -- Set termguicolors to enable highlight groups (default: false)
vim.opt.relativenumber = true -- Set relative numbered lines (default: false)
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor (default: 0)
vim.opt.sidescrolloff = 8 -- Minimal number of screen columns either side of cursor if wrap is `false` (default: 0)
vim.opt.wrap = false -- Display lines as one long line (default: true)
vim.opt.linebreak = true -- Companion to wrap, don"t split words (default: false)
vim.opt.mouse = 'a' -- Enable mouse mode (default: "")
vim.opt.cursorline = true -- Highlight the current line (default: false)

vim.opt.smartindent = true -- Make indenting smarter again (default: false)
vim.opt.shiftwidth = 4 -- The number of spaces inserted for each indentation (default: 8)
vim.opt.tabstop = 4 -- Insert n spaces for a tab (default: 8)
vim.opt.softtabstop = 4 -- Number of spaces that a tab counts for while performing editing operations (default: 0)
vim.opt.autoindent = true -- Copy indent from current line when starting new one (default: true)
vim.opt.showtabline = 2 -- Always show tabs (default: 1)
vim.opt.breakindent = true -- Enable break indent (default: false)

vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search (default: false)
vim.opt.smartcase = true -- Smart case (default: false)
vim.opt.hlsearch = true -- Set highlight on search (default: true)
vim.opt.incsearch = true -- Show matches as you type

vim.opt.signcolumn = 'yes' -- Keep signcolumn on by default (default: "auto")
vim.opt.colorcolumn = '100' -- Show a highlighted column at pos. 100
vim.opt.showmatch = true -- Show a highlighted column at pos. 100
vim.opt.cmdheight = 1 -- More space in the Neovim command line for displaying messages (default: 1)
vim.opt.completeopt = {'menuone','noselect'} -- Set completeopt to have a better completion experience (default: "menu,preview")
vim.opt.showmode = false -- We don"t need to see things like -- INSERT -- anymore (default: true)
vim.opt.pumheight = 10 -- Pop up menu height (default: 0)
vim.opt.conceallevel = 0 -- So that `` is visible in markdown files (default: 1)

local undodir = vim.fn.expand '~/.local/share/nvim/undodir'
if vim.fn.isdirectory(undodir) == 0 then vim.fn.mkdir(undodir, 'p') end
vim.opt.backup = false -- Creates a backup file (default: false)
vim.opt.writebackup = false -- If a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited (default: true)
vim.opt.swapfile = false -- Creates a swapfile (default: true)
vim.opt.undofile = true -- Save undo history (default: false)
vim.opt.undodir = undodir -- Save undo history (default: false)
vim.opt.autoread = true -- Auto-reload changes made outside of neovim
vim.opt.autowrite = false -- Do not auto save

vim.opt.updatetime = 250 -- Decrease update time (default: 4000)
vim.opt.timeoutlen = 300 -- Time to wait for a mapped sequence to complete (in milliseconds) (default: 1000)

vim.opt.backspace = { 'indent','eol','start' } -- Allow backspace on (default: "indent,eol,start")
vim.opt.iskeyword:append '-' -- Hyphenated words recognized by searches (default: does not include "-")

vim.schedule(function() vim.opt.clipboard:append 'unnamedplus' end)
vim.opt.encoding = 'utf-8' -- The encoding written to a file (default: "utf-8")
vim.opt.autochdir = false

vim.opt.splitbelow = true -- Force all horizontal splits to go below current window (default: false)
vim.opt.splitright = true -- Force all vertical splits to go to the right of current window (default: false)

vim.opt.whichwrap = 'bs<>[]hl' -- Which "horizontal" keys are allowed to travel to prev/next line (default: "b,s")
vim.opt.runtimepath:remove '/usr/share/vim/vimfiles' -- Separate Vim plugins from Neovim in case Vim still in use (default: includes this path if Vim is installed)

-- Font
vim.g.have_nerd_font = true

-- Folds
vim.o.foldlevel = 99 -- Open all folds by default upon opening a file

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
