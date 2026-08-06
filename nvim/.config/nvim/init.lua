-- nvim 0.12 minimal config, plugins managed by vim.pack.
--
-- Load order is constrained:
--   options       leader must be set before any plugin loads
--   plugins       vim.pack.add, puts plugins on rtp
--   setup.coding  before lsp (blink capabilities, treesitter)
--   setup.ide     before lsp (codesettings registers a before_init hook)

require("options")
require("plugins")

require("setup.mini")
require("setup.coding")
require("setup.editor")
require("setup.ide")

require("lsp")
require("autocmds")
require("keymaps")

pcall(vim.cmd.colorscheme, "catppuccin-mocha")
