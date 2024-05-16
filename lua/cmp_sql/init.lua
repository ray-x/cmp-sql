local defaults = {
  keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%([\-]\w*\)*\)]],
  get_bufnrs = function()
    return { vim.api.nvim_get_current_buf() }
  end,
}

local source = {}
if lprint == nil then
  lprint = function(...) end
end

local sql_keys = require('cmp_sql.sql')
source.new = function()
  local self = setmetatable({}, { __index = source })
  self.sql = {}
  return self
end

source.get_keyword_pattern = function(_, params)
  params = params or {}
  params.option = params.option or {}
  params.option = vim.tbl_deep_extend('keep', params.option, defaults)
  vim.validate({
    keyword_pattern = {
      params.option.keyword_pattern,
      'string',
      '`opts.keyword_pattern` must be `string`',
    },
  })
  -- lprint('get keyword pattern', params.option.keyword_pattern)
  return params.option.keyword_pattern
end

function source:is_available()
  return true
end


source.get_debug_name = function()
  return 'sql'
end

function source:complete(params, callback)
  -- params = params or { context = { cursor_before_line = 'as' }, offset = 0 }
  -- callback = callback or lprint
  -- lprint('complete', params)
  local input = string.sub(params.context.cursor_before_line, params.offset)
  local items = {}
  local words = {}

  for _, word in ipairs(sql_keys) do
    if not words[word] and input ~= word then
      words[word] = true
      local w = word
      if #w > 25 then
        w = string.sub(w, 1, 25) .. '…'
      end
      table.insert(items, {
        label = w,
        insertText = word,
        dup = 0,
        cmp = { kind_hl_group = '@keyword.sql', kind_text = 'sql' },
      })
    end
  end
  -- lprint('items', items)
  callback({ items = items, isIncomplete = false })
end

return source
