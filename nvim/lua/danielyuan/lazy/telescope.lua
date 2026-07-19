return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    require("telescope").setup({
      extensions = {
        fzf = {},
      },
    })
    require("telescope").load_extension("fzf")

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
    -- --no-ignore-vcs bypasses .gitignore but keeps the always-ignore lists
    -- (fd/ignore and ripgrep/config in the dotfiles repo)
    local fd_bin = vim.fn.executable("fd") == 1 and "fd" or "fdfind"
    vim.keymap.set("n", "<leader>sF", function()
      builtin.find_files({
        find_command = { fd_bin, "--type", "f", "--color", "never", "--hidden", "--no-ignore-vcs" },
      })
    end, { desc = "[S]earch all [F]iles (gitignored too)" })
    vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
    vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sG", function()
      builtin.live_grep({
        additional_args = { "--hidden", "--no-ignore-vcs" },
      })
    end, { desc = "[S]earch by [G]rep (gitignored too)" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>sl", builtin.resume, { desc = "[S]earch [L]ast" })
    vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files" })
    vim.keymap.set("n", "<leader>sc", builtin.git_commits, { desc = "[S]earch git [C]ommits" })
    vim.keymap.set("n", "<leader>sb", builtin.git_branches, { desc = "[S]earch git [B]ranches" })
    vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "[S]earch [T]ODOs" })
    vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Find existing buffers" })
  end,
}
