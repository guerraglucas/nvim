# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration built on [LazyVim](https://lazyvim.github.io/). The config uses `lazy.nvim` as the plugin manager and follows LazyVim's conventions for extending and overriding defaults.

## Code Style

Lua formatting is enforced by `stylua` (config in `stylua.toml`):
- 2-space indentation
- 120 column width

Format a file: `stylua lua/plugins/yourfile.lua`

Use comments sparingly — only for complex or ambiguous code, not to describe what is self-evident.

## Architecture

### Entry Point

`init.lua` → `lua/config/lazy.lua` (bootstraps lazy.nvim, loads LazyVim + custom plugins)

### Config Layer (`lua/config/`)

These files extend LazyVim defaults — they are auto-loaded by LazyVim at specific lifecycle events:
- `options.lua` — loaded before lazy.nvim startup
- `keymaps.lua` — loaded on `VeryLazy` event
- `autocmds.lua` — loaded on `VeryLazy` event

### Plugin Layer (`lua/plugins/`)

Every `.lua` file here is auto-loaded by lazy.nvim. Each file returns a list of plugin specs following lazy.nvim's spec format. To override a LazyVim plugin, use the same plugin name/source in your spec — opts are deep-merged.

Current custom plugin files:
- `debug.lua` — DAP adapters for JS/TS (pwa-node), Kotlin, plus Mason auto-install for Java/Kotlin/Go/JS debug adapters
- `ai.lua` — placeholder (currently empty)
- `example.lua` — template/reference (guarded with `if true then return {} end`, never actually loaded)

### LazyVim Extras (`lazyvim.json`)

Active extras (managed via `:LazyExtras` UI):
- `lazyvim.plugins.extras.ai.claudecode`
- `lazyvim.plugins.extras.dap.core`
- `lazyvim.plugins.extras.lang.docker`
- `lazyvim.plugins.extras.lang.go`
- `lazyvim.plugins.extras.lang.java`
- `lazyvim.plugins.extras.lang.kotlin`
- `lazyvim.plugins.extras.lang.python`
- `lazyvim.plugins.extras.lang.sql`
- `lazyvim.plugins.extras.lang.typescript`

Do not edit `lazyvim.json` manually — use `:LazyExtras` inside Neovim.

## Adding Plugins

Create or edit a file in `lua/plugins/`. Return a table of lazy.nvim plugin specs:

```lua
return {
  {
    "author/plugin-name",
    opts = { ... },
  },
}
```

To disable a LazyVim default plugin: `{ "author/plugin-name", enabled = false }`

To extend opts without overwriting lists, use the `opts` function form with `vim.list_extend`.

## DAP Debug Adapters

Adapters are configured in `lua/plugins/debug.lua`. Mason auto-installs: `java-debug-adapter`, `java-test`, `kotlin-debug-adapter`, `js-debug-adapter`, `delve`. The JS adapter uses `pwa-node` type via `js-debug-adapter` from Mason's data path.
