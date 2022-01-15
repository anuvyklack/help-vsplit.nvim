# help-vsplit.nvim

Open vim help into a vertical split from the right or left of the current
window if there is enough space for it.  If space is not enough the help be
opened in the horizontal split as it by default in Vim.

To install and activate with packer:

```lua
use { 'anuvyklack/help-vsplit.nvim'
   config = function()
      require('help-vsplit').setup()
   end
}
```

## Configuration

In the `setup()` function you can pass the table with desired settings.
Defaults are the next:

```lua
{
   always = false, -- Always open help in a vertical split.
   side = 'right', -- 'left' or 'right'
   buftype = { 'help' },
   filetype = { 'man' }
}
```

## Open help in a vertical split on the far right

For this you don't need plugin. Add into file

```sh
$HOME/.config/nvim/after/ftplugin/help.vim
```

the next line

```vim
wincmd L
```
