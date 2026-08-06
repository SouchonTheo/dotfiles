-- treesitter (main branch: no setup() function, just install + start)
local parsers = {
  "rust", "lua", "vim", "vimdoc", "query",
  "markdown", "markdown_inline",
  "c", "zig", "toml", "json", "yaml", "bash", "regex", "diff",
}
require("nvim-treesitter").install(parsers)

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local ft = args.match
    local lang = vim.treesitter.language.get_lang(ft) or ft
    if vim.treesitter.language.add(lang) then
      pcall(vim.treesitter.start, args.buf, lang)
    end
  end,
})

require("nvim-treesitter-textobjects").setup({
  select = { lookahead = true },
  move = { set_jumps = true }, -- jumplist-aware
})

-- copilot: inline suggestions off, it feeds the blink menu via blink-copilot
require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
  filetypes = { ["*"] = true },
})

-- blink.cmp v2 needs a native fuzzy lib built on install/update
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local d = ev.data or {}
    if d.spec and d.spec.name == "blink.cmp" and (d.kind == "install" or d.kind == "update") then
      vim.notify("Building blink.cmp native lib...", vim.log.levels.INFO)
      pcall(function() require("blink.cmp").build():wait(60000) end)
    end
  end,
})

require("blink.cmp").setup({
  -- "enter" preset: <CR> accepts (falls back to newline when the menu is closed),
  -- <Tab>/<S-Tab> navigate snippets, <C-y> also accepts.
  keymap = { preset = "enter" },
  appearance = { nerd_font_variant = "mono" },
  snippets = { preset = "mini_snippets" },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 300 },
    ghost_text = { enabled = true },
  },
  signature = { enabled = true },
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "copilot", "lazydev" },
    providers = {
      copilot = {
        name = "copilot",
        module = "blink-copilot",
        score_offset = 100,
        async = true,
      },
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
    },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    rust = { "rustfmt" },
    c = { "clang-format" },
    zig = { "zigfmt" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    toml = { "taplo" },
  },
  -- Returning nil disables format-on-save for that buffer.
  -- Escape hatches (both toggled by <leader>tf / <leader>tF in keymaps.lua):
  --   vim.b.disable_autoformat = this buffer only
  --   vim.g.disable_autoformat = globally, for repos whose style isn't ours
  format_on_save = function(bufnr)
    if vim.b[bufnr].disable_autoformat or vim.g.disable_autoformat then return end
    if vim.api.nvim_buf_line_count(bufnr) > 5000 then return end
    return { lsp_format = "fallback", timeout_ms = 1500 }
  end,
})
