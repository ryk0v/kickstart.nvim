-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Config & Keymaps
--  See `:help vim.diagnostic.Opts`
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float {
        bufnr = bufnr,
        scope = 'cursor',
        focus = false,
      }
    end,
  },
}

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

local opts = { noremap = true, silent = true }

-- save file
vim.keymap.set('n', '<D-s>', '<cmd> w <CR>', opts)

-- save file without auto-formatting
vim.keymap.set('n', '<C-s>', '<cmd>noautocmd w <CR>', opts)

-- delete character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
-- When cycling through search results with n (forward) or N (backward), zzzv forces
-- the screen to center on the match (zz) and opens any folded text blocks (zv) containing the match.
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Resize with arrows
-- vim.keymap.set('n', '<Up>', ':resize -4<CR>', opts)
-- vim.keymap.set('n', '<Down>', ':resize +4<CR>', opts)
-- vim.keymap.set('n', '<Left>', ':vertical resize +4<CR>', opts)
-- vim.keymap.set('n', '<Right>', ':vertical resize -4<CR>', opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>w', ':bdelete!<CR>', opts)
--vim.keymap.set('n', '<leader>n', '<cmd> enew <CR>', opts)

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts)
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts)
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts)
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts)

-- Stay in visual mode after indenting
-- saves the cursor position in mark z (mz), joins the lines (J), and then teleports the cursor back to where it started (``z`).
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- move selected lines
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- saves the cursor position in mark z (mz), joins the lines (J), and then teleports the cursor back to where it started (``z`).
vim.keymap.set('n', 'J', 'mzJ`z')

vim.keymap.set('n', '<leader>ea', 'oassert.NoError(err, "")<Esc>F";a')

--The moment you finish typing =ap, Neovim instantly executes four hidden steps in a fraction of a second:ma: It silently drops a virtual bookmark (Mark a) right where your cursor is currently sitting.=ap: It triggers Vim's native auto-indent command for the current paragraph (=ap stands for "Format Around Paragraph"). Your code instantly snaps into its correct indentation, and the cursor naturally flies down to the bottom of the paragraph during the format.'a: It automatically jumps your cursor straight back to the line where you started (Mark a).
-- vim.keymap.set('n', '=ap', "ma=ap'a")

-- Deletes text into the "void register" ("_). This allows you to cut/delete text without overwriting
-- what you currently have copied in your main clipboard.
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d')

-- Unbinds the capital Q key entirely (<nop> means No Operation). Normally,
-- Q enters "Ex mode", a legacy mode that is confusing to accidentally get stuck in.
vim.keymap.set('n', 'Q', '<nop>')

-- Cycles through global code errors or search hits in the Quickfix list.
-- Ctrl + k jumps to the next error, Ctrl + j jumps to the previous error, centering the view (zz) every time.
vim.keymap.set('n', '<C-k>', '<cmd>cprev<CR>zz')
vim.keymap.set('n', '<C-j>', '<cmd>cnext<CR>zz')

-- The ultimate find-and-replace snippet. Pressing Space + s grabs the exact word your cursor is sitting on (<C-r><C-w>) and populates a global search-and-replace command (:%s/\<word\>/word/gI). It leaves your cursor perfectly positioned so you can just type the new replacement word and press Enter.
vim.keymap.set('n', '<leader>r', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
