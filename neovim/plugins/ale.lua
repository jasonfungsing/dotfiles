-- ALE (Asynchronous Lint Engine) Configuration
-- Linting and code quality checks

vim.g.ale_linters_explicit = 1
vim.g.ale_fix_on_save = 1
vim.g.ale_sign_column_always = 1
vim.g.ale_linters = {
  javascript = { "eslint" },
  python = { "pylint", "flake8" },
  go = { "golint", "go vet" },
  java = { "eclipselsp" },
}
