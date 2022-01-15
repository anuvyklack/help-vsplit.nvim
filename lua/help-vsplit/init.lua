local api = vim.api
local bo = vim.bo
local fn = vim.fn
local M = {}

M.config = {
   always = false, -- always open help in vertical split
   side = 'right', -- 'left' or 'right'
   buftype = { 'help' },
   filetype = { 'man' },
}

function M.setup(config)
   M.config = vim.tbl_deep_extend('force', M.config, config or {})

   vim.cmd([[
      augroup HelpSplit
         autocmd!
         autocmd WinNew * autocmd BufEnter * ++once lua _G.NewHelpSplit()
      augroup end
   ]])
end

local function condition()
   for _, btype in ipairs(M.config.buftype) do
      if bo.buftype == btype then return true end
   end
   for _, ftype in ipairs(M.config.filetype) do
      if bo.filetype == ftype then return true end
   end
   return false
end

function M.open_help_split()
   if condition() then
      ---The ID of the origin window from which help window was opened:
      ---i.e. last accessed window.
      local origin_win = fn.win_getid(fn.winnr('#'))
      local origin_buf = api.nvim_win_get_buf(origin_win)

      local origin_textwidth = bo[origin_buf].textwidth
      if origin_textwidth == 0 then origin_textwidth = 80 end

      if M.config.always or
         api.nvim_win_get_width(origin_win) >= origin_textwidth + 80
      then
         local help_buf = fn.bufnr()

         ---Origin 'bufhidden' property or the help buffer.
         local bufhidden = bo.bufhidden
         bo.bufhidden = 'hide'

         local old_help_win = api.nvim_get_current_win()
         api.nvim_set_current_win(origin_win)

         api.nvim_win_close(old_help_win, false)

         vim.cmd 'vsplit' -- Create new help vertical split window and make it active.
         api.nvim_win_set_buf( api.nvim_get_current_win(), help_buf )
         bo.bufhidden = bufhidden

         if M.config.side == 'left' then
            vim.cmd 'wincmd r'
         end
      end
   end
end

function _G.NewHelpSplit()
   M.open_help_split()
end

return M
