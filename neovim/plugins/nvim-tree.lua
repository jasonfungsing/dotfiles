-- nvim-tree Configuration
-- File tree navigation and management

-- Compact git markers via the official user-decorator API (replaces the
-- built-in "Git" decorator): one merged component like "±+" instead of
-- "± +", since nvim-tree pads between separate components. Marker
-- language matches the zsh prompt: + new, ± modified, - deleted, ✓ staged.
local Decorator = require("nvim-tree.api").Decorator
local CompactGitDecorator = Decorator:extend()

function CompactGitDecorator:new()
  self.enabled = true
  self.highlight_range = "none"
  self.icon_placement = "before"
end

local function compact_git_marks(xys)
  local seen, out = {}, {}
  local function add(m)
    if not seen[m] then
      seen[m] = true
      out[#out + 1] = m
    end
  end
  for _, xy in ipairs(xys) do
    local x, y = xy:sub(1, 1), xy:sub(2, 2)
    if xy == "??" then
      add("+")
    elseif x == "D" or y == "D" then
      add("-")
    else
      if y:match("[MTCRAU]") then add("±") end
      if x:match("[MTCRAU]") then add("✓") end
    end
  end
  return table.concat(out)
end

-- Global icon padding is "" (see renderer.icons.padding below) so the
-- markers can sit flush against the name: this decorator emits " ±+" for
-- marked nodes and a plain " " spacer for clean ones, keeping the usual
-- gap between the file icon and what follows.
function CompactGitDecorator:icons(node)
  -- API nodes are plain tables: read the raw git_status (file XY string
  -- plus, for folders, the aggregated child statuses in dir.direct/indirect)
  local gs = node.git_status
  local xys = {}
  if gs then
    if gs.file then
      xys[#xys + 1] = gs.file
    end
    if gs.dir then
      for _, list in pairs({ gs.dir.direct, gs.dir.indirect }) do
        for _, xy in pairs(list or {}) do
          xys[#xys + 1] = xy
        end
      end
    end
  end
  local str = compact_git_marks(xys)
  if str == "" then
    return { { str = " ", hl = {} } }
  end
  return { { str = " " .. str, hl = { "NvimTreeGitDirtyIcon" } } }
end

require("nvim-tree").setup({
  view = {
    width = 30,
    side = "left",
    preserve_window_proportions = true,
  },
  renderer = {
    decorators = { CompactGitDecorator, "Open", "Hidden", "Modified", "Bookmark", "Diagnostics", "Copied", "Cut" },
    add_trailing = false,
    group_empty = false,
    highlight_git = false,
    full_name = false,
    highlight_opened_files = "none",
    root_folder_label = ":~:s?$?/..?",
    indent_width = 2,
    indent_markers = {
      enable = false,
      inline_arrows = true,
      icons = {
        corner = "└",
        edge = "│",
        item = "│",
        bottom = "─",
        none = " ",
      },
    },
    icons = {
      webdev_colors = true,
      git_placement = "before",
      -- No automatic padding between components: the compact git decorator
      -- above provides its own leading space, letting markers sit flush
      -- against the name ("±+name"). folder_arrow keeps its spacing.
      padding = { icon = "", folder_arrow = " " },
      symlink_arrow = " ➛ ",
      -- Default glyphs (nerd-font icons; per-filetype file icons come from
      -- nvim-web-devicons — the terminal font must be a Nerd Font), except
      -- the unstaged marker: ± to match the zsh prompt's dirty indicator
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        -- Outline folders, matching VS Code/Antigravity's Seti icon theme
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
        },
        git = {
          unstaged = "±",
          untracked = "+",
          deleted = "-",
        },
      },
    },
  },
  sync_root_with_cwd = true,
  git = {
    enable = true,
    ignore = false,
  },
  filters = {
    dotfiles = false,
    custom = { "^.git$" },
  },
  actions = {
    open_file = {
      quit_on_open = false,
    },
  },
})

-- Key mappings for nvim-tree
local keymap = vim.keymap.set

keymap("n", "<leader>ne", ":NvimTreeToggle<CR>", { noremap = true, silent = true, desc = "Toggle file tree" })
keymap("n", "<leader>n ", ":NvimTreeFindFile<CR>", { noremap = true, silent = true, desc = "Reveal file in tree" })

-- Open nvim-tree automatically when Neovim starts up if no files were specified
vim.api.nvim_create_autocmd("StdinReadPre", {
  callback = function()
    vim.g.std_in = 1
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 and vim.g.std_in ~= 1 then
      require("nvim-tree.api").tree.open()
    end
  end,
})
