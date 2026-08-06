-- Native vim.lsp.config() / vim.lsp.enable() (nvim 0.11+).
-- Rust LSP is handled by rustaceanvim, NOT enabled here.

vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = { ".clangd", "compile_commands.json", "compile_flags.txt", "Makefile", ".git" },
})

vim.lsp.config("zls", {
  cmd = { "zls" },
  filetypes = { "zig", "zir" },
  root_markers = { "zls.json", "build.zig", ".git" },
})

vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", ".git" },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = { checkThirdParty = false },
      -- lazydev handles `vim` (it injects $VIMRUNTIME into workspace.library),
      -- but the Mini* globals are created at runtime by each module's setup()
      -- and have no type defs anywhere: declare them or every use warns.
      diagnostics = {
        globals = {
          "vim",
          "MiniIcons", "MiniMisc", "MiniPick", "MiniFiles", "MiniTrailspace",
          "MiniAnimate", "MiniStarter", "MiniSnippets", "MiniClue", "MiniExtra",
        },
      },
      telemetry = { enable = false },
      hint = { enable = true },
    },
  },
})

vim.lsp.config("taplo", {
  cmd = { "taplo", "lsp", "stdio" },
  filetypes = { "toml" },
  root_markers = { "taplo.toml", ".taplo.toml", ".git" },
})

vim.lsp.config("jsonls", {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  root_markers = { ".git" },
  init_options = { provideFormatter = true },
})

vim.lsp.config("yamlls", {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose" },
  root_markers = { ".git" },
})

-- bashls shells out to shellcheck for diagnostics, install both to get them
vim.lsp.config("bashls", {
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "bash" },
  root_markers = { ".git" },
})

vim.lsp.config("marksman", {
  cmd = { "marksman", "server" },
  filetypes = { "markdown", "markdown.mdx" },
  root_markers = { ".marksman.toml", ".git" },
})

local ok, blink = pcall(require, "blink.cmp")
if ok then
  vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities() })
end

-- enable each server only if its binary is installed
local servers = { "clangd", "zls", "lua_ls", "taplo", "jsonls", "yamlls", "bashls", "marksman" }
for _, name in ipairs(servers) do
  local cfg = vim.lsp.config[name]
  local bin = cfg and cfg.cmd and cfg.cmd[1]
  if bin and vim.fn.executable(bin) == 1 then
    vim.lsp.enable(name)
  end
end

-- nvim 0.11+ already provides grn (rename), grr (references), gra (code action),
-- gri (implementation), grt (type def), K (hover), gO (symbols).
-- Only what's missing, or what we prefer aliased to leader, is added here.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
    end

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end

    map("n", "gd", vim.lsp.buf.definition, "LSP: definition")
    map("n", "gD", vim.lsp.buf.declaration, "LSP: declaration")
    -- through conform (same formatters as format-on-save), LSP as fallback
    map("n", "<leader>cf", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, "Format")
    map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
    map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev diagnostic")
    map("n", "]d", function() vim.diagnostic.jump({ count = 1,  float = true }) end, "Next diagnostic")
    map("n", "[e", function()
      vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR })
    end, "Prev error")
    map("n", "]e", function()
      vim.diagnostic.jump({ count = 1,  float = true, severity = vim.diagnostic.severity.ERROR })
    end, "Next error")
    map("n", "[w", function()
      vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.WARN })
    end, "Prev warning")
    map("n", "]w", function()
      vim.diagnostic.jump({ count = 1,  float = true, severity = vim.diagnostic.severity.WARN })
    end, "Next warning")
  end,
})
