vim.api.nvim_set_keymap("n", "0", "^", { noremap = true, desc = "Move to the first non-whitespace character" })
vim.api.nvim_set_keymap("n", "Q", "<nop>", { noremap = true, desc = "Disabled" })
vim.api.nvim_set_keymap("n", "j", "gj", { desc = "Move to next display line" })
vim.api.nvim_set_keymap("n", "k", "gk", { desc = "Move to previous display line" })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center the buffer" })
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center the buffer" })
vim.api.nvim_set_keymap("n", "<leader>l", "<cmd>nohlsearch<cr> <cmd>echo ''<cr>", { desc = "Clear search and message" })
vim.api.nvim_set_keymap("t", "<C-t><esc>", "<C-\\><C-n>", { desc = "Exit insert model in the terminal" })
