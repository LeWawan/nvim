local M = {}

local state = {
  buf = nil,
  win = nil,
}

local function win_config()
  return {
    relative = "editor",
    width = math.floor(vim.o.columns * 0.9),
    height = math.floor(vim.o.lines * 0.9),
    row = math.floor(vim.o.lines * 0.05),
    col = math.floor(vim.o.columns * 0.05),
    border = "rounded",
  }
end

local function enter_insert()
  local keys = vim.api.nvim_replace_termcodes("i", true, false, true)
  vim.api.nvim_feedkeys(keys, "n", false)
end

local function open_terminal()
  if state.buf and vim.api.nvim_buf_is_valid(state.buf)then
    state.win = vim.api.nvim_open_win(state.buf, true, win_config())
    enter_insert()
    return
  end

  state.buf = vim.api.nvim_create_buf(false, true)
  state.win = vim.api.nvim_open_win(state.buf, true, win_config())

  vim.fn.jobstart("glab-tui", {
    term = true,
    on_exit = function()
      state.buf = nil
      state.win = nil
    end
  })

  enter_insert()
end

local function close_terminal()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, false)
  end
  state.win = nil
end

function M.toggle()
  if vim.fn.executable("glab-tui") == 0 then
    vim.notify("glab-tui not found in PATH", vim.log.levels.ERROR)
    return
  end

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    close_terminal()
  else
    open_terminal()
  end
end


function M.setup()
  vim.api.nvim_create_user_command("GlabTui", function() M.toggle() end, {})
end

return M
