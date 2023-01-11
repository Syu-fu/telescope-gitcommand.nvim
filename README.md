# telescope-gitcommand.nvim

Command pallet of Git commands

## Usage

```
# As a command
:Telescope gitcommand

# As a lua function
require('telescope').extensions.gitcommand.gitcommand()
```

## Requirements

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [vim-fugitive](https://github.com/tpope/vim-fugitive)

## Configuration

You can set commands not to be displayed

```lua
require('telescope').setup({
  -- Telescope settings
  extensions = {
    gitcommand = {
      ignore = { 'push', 'push --force', 'pull' }, -- Write the command name as it appears in the command palette
    },
  },
})
```
