# **dim.nvim**

A time-based color dimming engine for Neovim.

`dim.nvim` gradually desaturates and compresses the contrast of your existing colorscheme, making Neovim visually “less attractive” outside working hours — without changing the colorscheme itself.

It works like **f.lux / Night Shift**, but for your editor.

______________________________________________________________________

## Features

- Works with any colorscheme
- Preserves your theme — no switching
- Smooth time-based dimming
- Fully reversible
- Supports manual and automatic modes
- Lua override hooks (weekends, holidays, focus mode, etc.)
- Works with lualine, file trees, LSP highlights, etc.

______________________________________________________________________

## Installation

### lazy.nvim

```lua
{
  "ademkin/dim.nvim",
  config = function()
    require("dim").setup({
      enabled = true,
      schedule = {
        ["06:00"] = 1.0,
        ["08:00"] = 0.0,
        ["16:00"] = 0.0,
        ["20:00"] = 1.0,
      },
    })
  end
}
```

### packer.nvim

```lua
use {
  "ademkin/dim.nvim",
  config = function()
    require("dim").setup({
      enabled = true,
      schedule = {
        ["06:00"] = 1.0,
        ["08:00"] = 0.0,
        ["16:00"] = 0.0,
        ["20:00"] = 1.0,
      },
    })
  end
}
```

______________________________________________________________________

## Quick start (manual mode)

You can use dim.nvim without any configuration:

```
:Dim tint 0.5
```

This applies a static dim (0 = none, 1 = maximum).

______________________________________________________________________

## Time-based schedule

Automatically increase dimming in the evening:

```lua
require("dim").setup({
  enabled = true,
  schedule = {
    ["06:00"] = 1.0,
    ["08:00"] = 0.0,
    ["16:00"] = 0.0,
    ["18:00"] = 0.7,
    ["20:00"] = 1.0,
  },
})
```

The dim level will smoothly interpolate between those values during the day.

______________________________________________________________________

## Weekend override

You can override the schedule with Lua logic.

Example: always dim heavily on weekends:

```lua
require("dim").setup({
  enabled = true,
  schedule = {
    ["06:00"] = 1.0,
    ["08:00"] = 0.0,
    ["16:00"] = 0.0,
    ["18:00"] = 0.7,
    ["20:00"] = 1.0,
  },
  override = function()
    local day = os.date("%A")
    if day == "Saturday" or day == "Sunday" then
      return 0.9
    end
  end,
})
```

If `override()` returns a value, it replaces the schedule.
If it returns `nil`, the schedule is used.
The `override()` function is called on every tic, so don\`t put any heavy stuff here.

______________________________________________________________________

## Commands

| Command | Description |
| ------------------ | ----------------------- |
| `:Dim enable` | Enable dimming |
| `:Dim disable` | Disable dimming |
| `:Dim toggle` | Toggle on/off |
| `:Dim tint {0..1}` | Apply static dim |
| `:Dim start` | Start scheduled dimming |
| `:Dim stop` | Stop scheduled dimming |
| `:Dim state` | Show internal state |

______________________________________________________________________

## How it works

dim.nvim transforms all highlight colors in-place using a perceptual grayscale + contrast compression model.

It does **not**:

- change your colorscheme
- define new highlight groups
- touch your config files

It only mutates colors at runtime and can always restore the original values.

______________________________________________________________________

## Philosophy

Working late is often encouraged by beautiful UIs.
dim.nvim makes Neovim visually boring when it should be.

Your brain notices.
