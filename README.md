# cmp-sql

nvim-cmp source for sql keywords. It includes 800+ sql keywords (with postgresql keywords extensions)
Useful when editing sql without db connection

# Setup

```lua
require'cmp'.setup {
  sources = {
    { name = 'sql' }
  }
}
```
