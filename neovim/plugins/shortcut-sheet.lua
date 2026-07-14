-- Searchable shortcut sheet (Ctrl+/) — the nvim sibling of the zsh/tmux
-- shortcut sheets (terminal/shortcut-sheet.zsh, tmux prefix-?).
--
-- A custom Telescope picker over normal-mode keymaps only (the ones
-- executable from the picker), with <Plug> internals and vim's
-- ":help X-default" placeholder maps hidden. Rows are grouped into
-- sections; three columns — section tag, key, description (or the mapped
-- command). The tag is part of each row so it survives filtering, and
-- typing e.g. "git" surfaces that whole section. Enter executes the
-- selection.

-- Section order controls how groups appear with an empty query
local sections = {
  "help", "file", "find", "move", "git", "lsp", "diag",
  "code", "edit", "term", "debug", "ui", "misc",
}

local function section_of(lhs, text)
  local t = text:lower()
  -- lhs-based rules first (most reliable), then keyword fallbacks
  if lhs == "<C-/>" or lhs == "<C-_>" or lhs == "<F1>" then return "help" end
  if lhs:match("^,x") then return "diag" end
  if lhs:match("^,g") then return "git" end
  if lhs:match("^,[fwrS]$") or lhs:match("^,s[pw]$") then return "find" end
  if lhs:match("^,d[bciou]$") then return "debug" end
  if lhs:match("^,t[fsv]$") or lhs == "<C-\\>" then return "term" end
  if lhs == ",t" then return "code" end
  if lhs == ",ne" or lhs == ",n<Space>" or lhs == ",n" or lhs == "gx" then return "file" end
  if lhs:match("^,h[%dam]") then return "move" end
  if lhs:match("^,w[arl]$") or lhs:match("^,[cr][an]$") then return "lsp" end
  if lhs:match("^<C%-[TQ]>$") or lhs:match("^<M%-[jk]>$") then return "move" end
  if lhs:match("^,[lmcsq]$") or lhs:match("^,c[rt]$") or lhs:match("^,n[dh]$") or lhs == ",h" or lhs == ",bd" then return "ui" end
  if lhs == "<CR>" or lhs == "<S-CR>" or lhs == "p" or lhs == "P" then return "edit" end
  if t:match("git") or t:match("hunk") then return "git" end
  if t:match("lsp") or t:match("symbol") or t:match("reference") or t:match("definition")
      or t:match("implementation") or t:match("rename") or t:match("code_action") or t:match("codelens") then return "lsp" end
  if t:match("diagnostic") or t:match("trouble") or t:match("quickfix") then return "diag" end
  if t:match("telescope") or t:match("find") or t:match("grep") or t:match("search") or t:match("spectre") then return "find" end
  if t:match("harpoon") or t:match("buffer") or t:match("window") or t:match("resize")
      or t:match("bnext") or t:match("bprevious") or t:match("tab") then return "move" end
  if t:match("comment") or t:match("surround") or t:match("outline") or t:match("aerial") or t:match("format") then return "code" end
  if t:match("empty line") or t:match("move line") then return "edit" end
  if t:match("terminal") then return "term" end
  if t:match("breakpoint") or t:match("step") or t:match("dap") or t:match("debug") or t:match("continue") then return "debug" end
  if t:match("lazy") or t:match("mason") or t:match("notification") or t:match("colorizer") or t:match("session") then return "ui" end
  return "misc"
end

local M = {}

function M.open()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local entry_display = require("telescope.pickers.entry_display")
  local utils = require("telescope.utils")

  local rank = {}
  for i, s in ipairs(sections) do rank[s] = i end

  local keymaps = {}
  for _, source in ipairs({ vim.api.nvim_get_keymap("n"), vim.api.nvim_buf_get_keymap(0, "n") }) do
    for _, km in ipairs(source) do
      local lhs = utils.display_termcodes(km.lhs)
      local desc = km.desc or km.rhs or "(lua function)"
      -- hide <Plug> internals and vim's ":help X-default" placeholder maps
      if not lhs:find("<Plug>") and not desc:match("^:help .*%-default") then
        table.insert(keymaps, {
          keymap = km,
          lhs = lhs,
          desc = desc,
          section = section_of(lhs, desc),
        })
      end
    end
  end
  table.sort(keymaps, function(a, b)
    if a.section ~= b.section then return rank[a.section] < rank[b.section] end
    return a.lhs < b.lhs
  end)

  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 5 },
      { width = 16 },
      { remaining = true },
    },
  })

  pickers.new({}, {
    prompt_title = "Shortcut Sheet (Enter executes)",
    finder = finders.new_table({
      results = keymaps,
      entry_maker = function(item)
        return {
          valid = true,
          value = item,
          ordinal = item.section .. " " .. item.lhs .. " " .. item.desc,
          display = function()
            return displayer({ { item.section, "TelescopeResultsComment" }, item.lhs, item.desc })
          end,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes(selection.value.keymap.lhs, true, false, true), "t", true)
        end
      end)
      return true
    end,
  }):find()
end

return M
