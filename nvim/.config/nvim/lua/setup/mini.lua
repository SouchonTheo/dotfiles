require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons() -- compat for plugins that expect nvim-web-devicons

require("mini.ai").setup()
require("mini.comment").setup()
require("mini.surround").setup()
require("mini.move").setup()
require("mini.pairs").setup()

local hipatterns = require("mini.hipatterns")
hipatterns.setup({
  highlighters = {
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    hack  = { pattern = "%f[%w]()HACK()%f[%W]",  group = "MiniHipatternsHack" },
    todo  = { pattern = "%f[%w]()TODO()%f[%W]",  group = "MiniHipatternsTodo" },
    note  = { pattern = "%f[%w]()NOTE()%f[%W]",  group = "MiniHipatternsNote" },
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

-- All animations off for now, flip any `enable` to true to re-enable.
-- (scroll is the one paired with the <C-d>/<C-u> maps in keymaps.lua)
require("mini.animate").setup({
  cursor = { enable = false },
  scroll = { enable = false },
  resize = { enable = false },
  open   = { enable = false },
  close  = { enable = false },
})
require("mini.indentscope").setup({
  symbol = "│",
  options = { try_as_border = true },
})
require("mini.extra").setup()

local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    { mode = "n", keys = "<leader>" },
    { mode = "x", keys = "<leader>" },
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },
    { mode = "n", keys = "g" },
    { mode = "x", keys = "g" },
    { mode = "n", keys = "z" },
    { mode = "x", keys = "z" },
    { mode = "n", keys = '"' },
    { mode = "x", keys = '"' },
    { mode = "i", keys = "<C-r>" },
    { mode = "c", keys = "<C-r>" },
    { mode = "n", keys = "<C-w>" },
  },
  clues = {
    { mode = "n", keys = "<leader>f", desc = "+find" },
    { mode = "n", keys = "<leader>s", desc = "+search" },
    { mode = "n", keys = "<leader>g", desc = "+git" },
    { mode = "n", keys = "<leader>c", desc = "+code" },
    { mode = "n", keys = "<leader>b", desc = "+buffer" },
    { mode = "n", keys = "<leader>l", desc = "+lsp" },
    { mode = "n", keys = "<leader>t", desc = "+toggle" },
    { mode = "n", keys = "<leader>T", desc = "+test" },
    { mode = "n", keys = "<leader>d", desc = "+debug" },
    { mode = "n", keys = "<leader>p", desc = "+plugins" },
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
  window = {
    delay = 300,
    config = { width = "auto", border = "rounded" },
  },
})

require("mini.pick").setup({
  mappings = {
    move_down = "<C-j>",
    move_up   = "<C-k>",
  },
  window = { config = { border = "rounded" } },
})

require("mini.files").setup({
  -- Swap l/L so `l` (the natural "open") closes the explorer when the target
  -- is a file (go_in_plus). On directories it still just descends, so nav is
  -- unchanged. `L` keeps the explorer open to open + browse on.
  mappings = {
    go_in      = "L",
    go_in_plus = "l",
  },
  windows = { preview = true, width_focus = 30, width_preview = 60 },
  options = { use_as_default_explorer = true },
})

require("mini.tabline").setup()
require("mini.statusline").setup({ use_icons = true })

require("mini.bufremove").setup()
require("mini.bracketed").setup()
require("mini.splitjoin").setup()
require("mini.cursorword").setup({ delay = 200 })
require("mini.jump").setup()        -- enhanced f/F/t/T (multi-line, ; repeats)
require("mini.trailspace").setup()

require("mini.misc").setup()
MiniMisc.setup_restore_cursor()

require("mini.operators").setup({
  evaluate = { prefix = "g="  },
  exchange = { prefix = "gX"  }, -- moved (gx = URL open in 0.10+)
  multiply = { prefix = "gm"  },
  replace  = { prefix = ""    }, -- disabled (conflicts with grr = LSP references)
  sort     = { prefix = "gs"  },
})

local snip = require("mini.snippets")
snip.setup({
  snippets = {
    snip.gen_loader.from_lang(),
  },
})

local starter = require("mini.starter")
starter.setup({
  evaluate_single = true,
  items = {
    starter.sections.builtin_actions(),
    starter.sections.recent_files(10, false),
    starter.sections.recent_files(10, true),
  },
  content_hooks = {
    starter.gen_hook.adding_bullet("  "),
    starter.gen_hook.aligning("center", "center"),
  },
  header = table.concat({
    "  ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
    "  ████╗  ██║██║   ██║██║████╗ ████║",
    "  ██╔██╗ ██║██║   ██║██║██╔████╔██║",
    "  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
    "  ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
    "  ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
  }, "\n"),
  footer = "",
})
