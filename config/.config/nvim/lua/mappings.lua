require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

local map = vim.keymap.set

-- Leader
vim.g.mapleader = " "

-- ==========================
-- WASD Navigation
-- ==========================
map("n", "w", "k", { desc = "Up" })
map("n", "a", "h", { desc = "Left" })
map("n", "s", "j", { desc = "Down" })
map("n", "d", "l", { desc = "Right" })

map("v", "w", "k")
map("v", "a", "h")
map("v", "s", "j")
map("v", "d", "l")

map("o", "w", "k")
map("o", "a", "h")
map("o", "s", "j")
map("o", "d", "l")

-- ==========================
-- Q behaves like b
-- ==========================
map({ "n", "v", "o" }, "q", "b", { desc = "Previous word" })

-- ==========================
-- Insert mode switching
-- ==========================

-- Ctrl+Q exits insert mode
map("i", "<C-q>", "<Esc>", { desc = "Exit Insert Mode" })

-- Ctrl+E enters insert mode
map("n", "<C-e>", "i", { desc = "Enter Insert Mode" })

-- ==========================
-- Disable original meanings
-- ==========================
map("n", "Q", "<Nop>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
