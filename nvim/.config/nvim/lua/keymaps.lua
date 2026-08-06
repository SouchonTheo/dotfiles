local map = vim.keymap.set

-- window navigation (hjkl only, no arrows on purpose)
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })

for _, k in ipairs({ "<Up>", "<Down>", "<Left>", "<Right>" }) do
  map({ "n", "v" }, k, "<nop>")
end

-- mini.pick
map("n", "<leader><space>", "<cmd>Pick files<cr>",       { desc = "Find files" })
map("n", "<leader>ff",      "<cmd>Pick files<cr>",       { desc = "Find files" })
map("n", "<leader>fg",      "<cmd>Pick git_files<cr>",   { desc = "Git files" })
map("n", "<leader>fb",      "<cmd>Pick buffers<cr>",     { desc = "Buffers" })
map("n", "<leader>fr",      "<cmd>Pick oldfiles<cr>",    { desc = "Recent files" })
map("n", "<leader>fh",      "<cmd>Pick help<cr>",        { desc = "Help" })
map("n", "<leader>fk",      "<cmd>Pick keymaps<cr>",     { desc = "Keymaps" })
map("n", "<leader>fd",      "<cmd>Pick diagnostic<cr>",  { desc = "Diagnostics" })

map("n", "<leader>sg", "<cmd>Pick grep_live<cr>", { desc = "Grep project" })
map("n", "<leader>sw", function() MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end,
  { desc = "Grep word under cursor" })
map("n", "<leader>sd", function()
  MiniPick.builtin.grep_live({}, { source = { cwd = vim.fn.expand("%:p:h") } })
end, { desc = "Grep dir of current file" })
map("n", "<leader>sr", "<cmd>Pick resume<cr>", { desc = "Resume last picker" })

-- mini.files
map("n", "<leader>e", function()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" or vim.fn.filereadable(path) == 0 then path = vim.uv.cwd() end
  require("mini.files").open(path)
end, { desc = "Explorer (current file dir)" })

map("n", "<leader>E", function()
  require("mini.files").open(vim.uv.cwd())
end, { desc = "Explorer (cwd)" })

-- grug-far
map("n", "<leader>sR", "<cmd>GrugFar<cr>", { desc = "Search & Replace" })
map("v", "<leader>sR", "<cmd>GrugFarVisual<cr>", { desc = "Search & Replace (selection)" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>",     { desc = "Next buffer" })
map("n", "<leader>bd", function() require("mini.bufremove").delete(0, false) end, { desc = "Delete buffer (keep split)" })
map("n", "<leader>bD", function() require("mini.bufremove").delete(0, true) end, { desc = "Delete buffer (force)" })

map("i", "jk", "<esc>",              { desc = "Escape" })
map("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- terminal mode.
-- <Esc> alone would break TUIs running inside :terminal (lazygit, htop),
-- so the escape hatch is a double tap.
map("t", "<esc><esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
for _, k in ipairs({ "h", "j", "k", "l" }) do
  map("t", "<C-" .. k .. ">", "<C-\\><C-n><C-w>" .. k, { desc = "Go to " .. k .. " window" })
end

-- quickfix: the vanilla hub for grug-far / :Pick grep results.
-- ]q / [q navigation already comes from mini.bracketed.
map("n", "<leader>q", function()
  local open = vim.iter(vim.fn.getwininfo()):any(function(w) return w.quickfix == 1 end)
  vim.cmd(open and "cclose" or "copen")
end, { desc = "Toggle quickfix list" })

-- keep cursor centered on half-page jumps and search hits.
-- NOTE: these were routed through MiniAnimate.execute_after to survive the
-- smooth-scroll animation. All mini.animate animations are off (setup/mini.lua),
-- so the plain form is equivalent. Restore the execute_after wrapper if you
-- ever re-enable `scroll = { enable = true }`.
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n",     "nzvzz")
map("n", "N",     "Nzvzz")

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

map("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next TODO" })
map("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Prev TODO" })

map("n", "]h", function() require("gitsigns").nav_hunk("next") end, { desc = "Next hunk" })
map("n", "[h", function() require("gitsigns").nav_hunk("prev") end, { desc = "Prev hunk" })
map("n", "<leader>gs", function() require("gitsigns").stage_hunk() end, { desc = "Stage hunk" })
map("n", "<leader>gr", function() require("gitsigns").reset_hunk() end, { desc = "Reset hunk" })
map("n", "<leader>gp", function() require("gitsigns").preview_hunk() end, { desc = "Preview hunk" })
map("n", "<leader>gb", function() require("gitsigns").blame_line({ full = true }) end, { desc = "Blame line" })
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Lazygit" })

-- lsp info
map("n", "<leader>li", function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
    return
  end
  local lines = { "LSP clients for this buffer:", "" }
  for _, c in ipairs(clients) do
    table.insert(lines, ("• %s  (id=%d, root=%s)"):format(c.name, c.id, c.root_dir or "n/a"))
  end
  table.insert(lines, "")
  table.insert(lines, "All running clients: " .. #vim.lsp.get_clients())
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, { desc = "LSP: info (this buffer)" })

map("n", "<leader>lh", "<cmd>checkhealth vim.lsp<cr>", { desc = "LSP: checkhealth" })
map("n", "<leader>ll", function() vim.cmd("edit " .. vim.lsp.get_log_path()) end, { desc = "LSP: open log" })
map("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "LSP: restart" })

-- flash.nvim
map({ "n", "x", "o" }, "s", function() require("flash").jump() end,            { desc = "Flash jump" })
map({ "n", "x", "o" }, "S", function() require("flash").treesitter() end,      { desc = "Flash treesitter (jump to a node)" })
map("o",               "r", function() require("flash").remote() end,          { desc = "Remote flash (e.g. yr = yank remote)" })
map({ "x", "o" },      "R", function() require("flash").treesitter_search() end, { desc = "Treesitter search" })

-- treesitter textobjects + movement
local ok_sel, ts_select = pcall(require, "nvim-treesitter-textobjects.select")
local ok_mv,  ts_move   = pcall(require, "nvim-treesitter-textobjects.move")
if ok_sel then
  local objs = {
    f = "function",
    c = "class",     -- = struct/impl/trait in Rust
    a = "parameter",
    l = "loop",
    o = "call",
    k = "comment",
  }
  for key, name in pairs(objs) do
    map({ "x", "o" }, "a" .. key, function() ts_select.select_textobject("@" .. name .. ".outer", "textobjects") end,
      { desc = "around " .. name })
    map({ "x", "o" }, "i" .. key, function() ts_select.select_textobject("@" .. name .. ".inner", "textobjects") end,
      { desc = "inside " .. name })
  end
end
if ok_mv then
  map({ "n", "x", "o" }, "]m", function() ts_move.goto_next_start("@function.outer", "textobjects") end,     { desc = "Next function start" })
  map({ "n", "x", "o" }, "[m", function() ts_move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Prev function start" })
  map({ "n", "x", "o" }, "]M", function() ts_move.goto_next_end("@function.outer", "textobjects") end,       { desc = "Next function end" })
  map({ "n", "x", "o" }, "[M", function() ts_move.goto_previous_end("@function.outer", "textobjects") end,   { desc = "Prev function end" })
  map({ "n", "x", "o" }, "]]", function() ts_move.goto_next_start("@class.outer", "textobjects") end,        { desc = "Next class/struct start" })
  map({ "n", "x", "o" }, "[[", function() ts_move.goto_previous_start("@class.outer", "textobjects") end,    { desc = "Prev class/struct start" })
  map({ "n", "x", "o" }, "][", function() ts_move.goto_next_end("@class.outer", "textobjects") end,          { desc = "Next class/struct end" })
  map({ "n", "x", "o" }, "[]", function() ts_move.goto_previous_end("@class.outer", "textobjects") end,      { desc = "Prev class/struct end" })
  map({ "n", "x", "o" }, "]a", function() ts_move.goto_next_start("@parameter.outer", "textobjects") end,    { desc = "Next parameter" })
  map({ "n", "x", "o" }, "[a", function() ts_move.goto_previous_start("@parameter.outer", "textobjects") end,{ desc = "Prev parameter" })
end

map("n", "<leader>cw", function() MiniTrailspace.trim() end, { desc = "Trim trailing whitespace" })
map("n", "<leader>tp", "<cmd>Precognition toggle<cr>",       { desc = "Toggle precognition hints" })
map("n", "<leader>th", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { desc = "Toggle inlay hints" })

-- read by conform's format_on_save in setup/coding.lua
map("n", "<leader>tf", function()
  vim.b.disable_autoformat = not vim.b.disable_autoformat
  vim.notify("Format on save: " .. (vim.b.disable_autoformat and "OFF (buffer)" or "ON (buffer)"))
end, { desc = "Toggle format on save (buffer)" })
map("n", "<leader>tF", function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  vim.notify("Format on save: " .. (vim.g.disable_autoformat and "OFF (global)" or "ON (global)"))
end, { desc = "Toggle format on save (global)" })

-- neotest, <leader>T = +test
map("n", "<leader>Tr", function() require("neotest").run.run() end,                        { desc = "Run nearest test" })
map("n", "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end,       { desc = "Run file tests" })
map("n", "<leader>Tl", function() require("neotest").run.run_last() end,                    { desc = "Run last test" })
map("n", "<leader>Ts", function() require("neotest").summary.toggle() end,                  { desc = "Toggle summary" })
map("n", "<leader>To", function() require("neotest").output.open({ enter = true }) end,     { desc = "Show output" })
map("n", "<leader>TO", function() require("neotest").output_panel.toggle() end,             { desc = "Toggle output panel" })
map("n", "<leader>TS", function() require("neotest").run.stop() end,                        { desc = "Stop test" })

-- dap, <leader>d = +debug
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end,                   { desc = "Toggle breakpoint" })
map("n", "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, { desc = "Conditional breakpoint" })
map("n", "<leader>dc", function() require("dap").continue() end,                            { desc = "Continue / start" })
map("n", "<leader>di", function() require("dap").step_into() end,                           { desc = "Step into" })
map("n", "<leader>do", function() require("dap").step_over() end,                           { desc = "Step over" })
map("n", "<leader>dO", function() require("dap").step_out() end,                            { desc = "Step out" })
map("n", "<leader>dr", function() require("dap").repl.toggle() end,                         { desc = "Toggle REPL" })
map("n", "<leader>du", function() require("dapui").toggle() end,                            { desc = "Toggle DAP UI" })
map("n", "<leader>dt", function() require("dap").terminate() end,                           { desc = "Terminate" })
-- rustaceanvim picks the right cargo target/test to debug
map("n", "<leader>dR", function() vim.cmd.RustLsp("debuggables") end,                       { desc = "Rust debuggables" })

-- vim.pack, <leader>p = +plugins
map("n", "<leader>pu", function() vim.pack.update() end,                                    { desc = "Update all plugins" })
map("n", "<leader>pl", function() vim.print(vim.pack.get()) end,                            { desc = "List installed plugins" })
