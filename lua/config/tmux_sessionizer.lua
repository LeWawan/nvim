-- Telescope-based equivalent of tmux-sessionizer (see
-- bin/.local/bin/tmux-sessionizer for the shell version this mirrors),
-- driving tmux sessions directly from Neovim instead of shelling out to fzf.
local M = {}

local function candidate_dirs()
  local dirs = vim.fn.globpath(vim.fn.expand '~/Lab', '*', false, true)
  dirs = vim.tbl_filter(function(path)
    return vim.fn.isdirectory(path) == 1
  end, dirs)

  table.insert(dirs, vim.fn.expand '~/Lab/playground')
  table.insert(dirs, vim.fn.expand '~/.dotfiles')
  table.insert(dirs, vim.fn.expand '~/.config/nvim')

  return dirs
end

local function switch_or_create(path)
  local name = vim.fn.fnamemodify(path, ':t'):gsub('%.', '_')

  if vim.env.TMUX == nil and vim.fn.system('pgrep tmux'):gsub('%s+', '') == '' then
    vim.fn.system { 'tmux', 'new-session', '-ds', name, '-c', path }
  else
    vim.fn.system { 'tmux', 'has-session', '-t=' .. name }
    if vim.v.shell_error ~= 0 then
      vim.fn.system { 'tmux', 'new-session', '-ds', name, '-c', path }
    end
  end

  vim.fn.system { 'tmux', 'switch-client', '-t', name }
end

function M.open()
  local picker = require 'telescope.pickers'
  local finder = require('telescope.finders').new_table { results = candidate_dirs() }
  local sorter = require('telescope.sorters').get_generic_fuzzy_sorter()
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  picker.new({
    prompt_title = 'Tmux Sessionizer',
    finder = finder,
    sorter = sorter,
  }, {
    attach_mappings = function(_, map)
      local select = function(prompt_bufnr)
        local selection = action_state.get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        if selection then
          switch_or_create(selection[1])
        end
      end
      map('i', '<CR>', select)
      map('n', '<CR>', select)
      return true
    end,
  }):find()
end

return M
