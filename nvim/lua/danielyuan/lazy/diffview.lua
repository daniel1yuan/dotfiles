return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff view" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current file)" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "File history (full repo)" },
    { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
    {
      "<leader>gm",
      function()
        vim.ui.input({ prompt = "Diff against branch: ", default = "main" }, function(branch)
          if branch and branch ~= "" then
            vim.cmd("DiffviewOpen origin/" .. branch .. "...HEAD")
          end
        end)
      end,
      desc = "Diff against branch",
    },
  },
}
