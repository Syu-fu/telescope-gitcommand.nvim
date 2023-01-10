local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local Opt = require('gitcommand').Opt

local Commands = {
  { 'status', "lua require('telescope.builtin').git_status()" },
  { 'branch', "lua require('telescope.builtin').git_branches()" },
  { 'repo log', "lua require('telescope.builtin').git_commits()" },
  { 'file log', "lua require('telescope.builtin').git_bcommits()" },
  { 'stash', "lua require('telescope.builtin').git_stash()" },
  { 'commit', 'Git commit' },
  { 'commit --amend', 'Git commit --amend' },
  { 'commit --amend --no-edit', 'Git commit --amend --no-edit' },
  { 'push', 'Git push' },
  { 'push --force', 'Git push --force' },
  { 'fetch', 'Git fetch' },
  { 'pull', 'Git pull' },
}

local gitcommand = function(opts, table)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_title = 'git command',
      finder = finders.new_table({
        results = table,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry[1],
            ordinal = entry[1],
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.api.nvim_exec(selection.value[2], true)
        end)
        return true
      end,
    })
    :find()
end

local function setup(opt)
  -- vim.api.nvim_exec(vim.inspect(opt), true)
  require('gitcommand').Opt.ignore = opt.ignore or {}
  Opt.ignore = require('gitcommand').Opt.ignore
  -- Opt = { ignore = { 'commit', 'status' } }
end

local function run()
  gitcommand(Opt, List_of_commands())
end

local function ignore_contain(command, ignore_list)
  for i = 1, ignore_list and #ignore_list or 0 do
    if command == ignore_list[i] then
      return true
    end
  end
  return false
end

function List_of_commands()
  local results = {}
  for i = 1, #Commands do
    if not ignore_contain(Commands[i][1], Opt.ignore) then
      table.insert(results, Commands[i])
    end
  end
  return results
end

return require('telescope').register_extension({
  setup = setup,
  exports = {
    gitcommand = run,
  },
})
