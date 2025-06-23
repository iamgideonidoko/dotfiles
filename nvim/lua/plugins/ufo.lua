return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  event = "BufReadPost",
  config = function()
    vim.o.foldcolumn = "1" -- show fold column
    vim.o.foldlevel = 99 -- set high so folds open by default
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    local ufo = require("ufo")
    vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
    vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })
    vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds, { desc = "Open folds except certain kinds" })
    vim.keymap.set("n", "zm", ufo.closeFoldsWith, { desc = "Close folds with level" })
    vim.keymap.set("n", "zK", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, { desc = "Peek Fold" })

    ufo.setup({
      provider_selector = function()
        return { "lsp", "indent" }
      end,
      open_fold_hl_timeout = 400,
      close_fold_kinds_for_ft = {
        -- default = { "imports", "comment" },
      },
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  ⟱ %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            table.insert(newVirtText, { chunkText, chunk[2] })
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end,
      preview = {
        win_config = {
          border = "rounded",
          winhighlight = "Normal:Folded",
          winblend = 0,
        },
      },
    })
  end,
}
