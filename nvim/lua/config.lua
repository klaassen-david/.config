require 'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "rust", "python", "vim", "lua" },
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  },
}


local rt = require 'rust-tools'
local opts = {
  tools = { -- rust-tools options
    runnables = {
      use_telescope = true
    },
    autoSetHints = true,
    inlay_hints = {
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },

  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
  server = {
    -- on_attach is a callback called when the language server attachs to the buffer
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "gc", rt.hover_actions.hover_actions, { buffer = bufnr, silent = true })
    end,
    settings = {
      -- to enable rust-analyzer settings visit:
      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
      ["rust-analyzer"] = {
        -- enable clippy on save
        checkOnSave = {
          command = "clippy"
        },
      }
    }
  },
}
rt.setup(opts)

require 'cmpconf'
require 'lspconfs'

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  callback = function() vim.lsp.buf.formatting_sync() end,
})

vim.api.nvim_create_autocmd({ "CursorHoldI" }, {
  callback = function() vim.diagnostic.open_float(nil, { focusable = false }) end,
})
