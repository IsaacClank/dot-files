vim.g.mapleader = " " -- Set leader to <Space>. Should already be set by mini.nvim.basics.

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.expandtab = true -- In insert mode, expand tabs into spaces.
vim.opt.scrolloff = 10   -- Minimum lines offset on top and bottom. Used to add padding.
vim.opt.shiftwidth = 2   -- Number of spaces used for auto-indent.
vim.opt.tabstop = 2      -- Number of spaces to render tabs in a file. This does **not** modify the file.

-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  ------------------------ ESSENTIALS ------------------------
  {
    {
      "echasnovski/mini.nvim",
      branch = "stable",
      config = function()
        require('mini.basics').setup()
        require('mini.pairs').setup()
        require('mini.surround').setup({
          mappings = {
            add = 'ys',
            delete = 'ds',
            find = '',
            find_left = '',
            highlight = '',
            replace = 'cs',
            update_n_lines = '',

            -- Add this only if you don't want to use extended mappings
            suffix_last = '',
            suffix_next = '',
          },
          search_method = 'cover_or_next',
        })
      end,
    },
    {
      "ggandor/leap.nvim",
      branch = "main",
      config = function()
        vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward)')
        vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Plug>(leap-backward)')
      end
    },
    {
      "folke/which-key.nvim",
      tag = "v1.6.0",
      enabled = function() return vim.g.vscode ~= 1 end,
      config = function()
        require("which-key").setup()
      end
    },
    {
      "nvim-tree/nvim-tree.lua",
      tag = "v1.6.0",
      config = function()
        require("nvim-tree").setup {
          view = {
            width = "15%"
          }
        }

        require("which-key").register(
          {
            e = { "<cmd>NvimTreeToggle<cr>", "Toggle explorer" }
          },
          { prefix = "<leader>" }
        )
      end
    }
  },
  ------------------------ THEME ------------------------
  {
    {
      "nvim-tree/nvim-web-devicons",
      branch = "master",
      enabled = function()
        return vim.g.vscode ~= 1;
      end
    },
  },
  ------------------------ GIT ------------------------
  {
    {
      'kdheepak/lazygit.nvim',
      branch = 'main',
      enabled = function()
        return vim.g.vscode ~= 1;
      end,
      config = function()
        require('which-key').register(
          {
            g = {
              g = { "<cmd>LazyGit<cr>", "LazyGit" }
            }
          },
          { prefix = '<leader>' }
        )
      end
    },
    {
      "lewis6991/gitsigns.nvim",
      tag = "v0.7",
      enabled = function()
        return vim.g.vscode ~= 1;
      end,
      config = function()
        require("gitsigns").setup {
          current_line_blame = true,
          current_line_blame_opts = { delay = 300 },
        }

        require("which-key").register(
          {
            g = {
              name = "Git",
              n = { "<cmd>Gitsigns next_hunk<cr>", "Next hunk" },
              p = { "<cmd>Gitsigns prev_hunk<cr>", "Previous hunk" },
              s = {
                name = "Stage",
                s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage hunk" },
                a = { "<cmd>Gitsigns stage_buffer<cr>", "Stage file" },
              },
              u = {
                name = "Unstage",
                u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Unstage hunk" },
                a = { "<cmd>Gitsigns reset_buffer_index<cr>", "Reset file" },
              },
              r = {
                name = "Reset",
                r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset hunk" },
                a = { "<cmd>Gitsigns reset_buffer<cr>", "Reset file" },
              }
            },
          },
          { prefix = "<leader>" }
        )

        require("which-key").register(
          {
            g = {
              name = "Git",
              s = {
                name = "Stage",
                s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage selection" },
              },
              u = {
                name = "Unstage",
                u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Unstage selection" },
              },
              r = {
                name = "Reset",
                r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset selection" },
              }
            },
          },
          { mode = "v", prefix = "<leader>" }
        )
      end
    },
    {
      "sindrets/diffview.nvim",
      branch = "main",
      enabled = function() return vim.g.vscode ~= 1 end,
    }
  },
  ------------------------ NAVIGATION ------------------------
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    enabled = function()
      return vim.g.vscode ~= 1;
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      if vim.g.vscode == 1 then
        return;
      end

      require('which-key').register(
        {
          s = {
            name = "Search",
            f = { "<cmd>Telescope find_files<cr>", "File browser" },
            F = { "<cmd>Telescope find_files hidden=true<cr>", "File browser" },
            g = { "<cmd>Telescope live_grep<cr>", "Text" },
            s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols" },
            S = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace symbols" },
          },
        },
        { prefix = "<leader>" }
      )
    end
  },
  ------------------------ INTELLISENSE ------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    -- tag = 'v0.9.2',
    branch = 'master',
    enabled = function()
      return vim.g.vscode ~= 1;
    end,
    config = function()
      require("nvim-treesitter.configs").setup {
        auto_install = true,
        ensure_installed = {
          "bash",
          "c_sharp",
          "json",
          "lua",
          "typescript",
          "vimdoc",
          "yaml",
        }
      }
    end
  },
  {
    "williamboman/mason.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip"
    },
    build = ":MasonUpdate",
    enabled = function()
      return vim.g.vscode ~= 1;
    end,
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()

      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
          { name = 'buffer' }
        })
      })

      local lspconfig = require('lspconfig')
      local completion_capabilities = require('cmp_nvim_lsp').default_capabilities()

      lspconfig.bashls.setup {
        capabilities = completion_capabilities,
        filetypes = { "sh", "bash" },
        single_file_support = true,
      }

      lspconfig.jsonls.setup {
        capabilities = completion_capabilities,
      }

      lspconfig.lua_ls.setup {
        capabilities = completion_capabilities,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }

      lspconfig.omnisharp.setup {
        cmd = { "/home/isaac/.local/share/nvim/mason/packages/omnisharp/omnisharp" },
        capabilities = completion_capabilities,
        root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj", "function.json"),
        filetypes = { "cs" },
        settings = {
          msbuild = {
            enabled = true
          },
          FormattingOptions = {
            EnableEditorConfigSupport = true,
            OrganizeImports = true,
          },
          RoslynExtensionsOptions = {
            EnableImportCompletion = true
          }
        }
      }

      -- lspconfig.prisma.setup {
      --   capabilities = completion_capabilities,
      -- }

      lspconfig.tsserver.setup {
        capabilities = completion_capabilities,
      }

      require("which-key").register(
        {
          l = {
            name = "Lsp",
            a = { function() vim.lsp.buf.code_action() end, "Code Action" },
            d = { function() vim.lsp.buf.definition() end, "Definition" },
            f = { function() vim.lsp.buf.format() end, "Format" },
            i = { function() vim.lsp.buf.implementation() end, "Implementation" },
            k = { function() vim.lsp.buf.hover() end, "Hover" },
            K = { function() vim.diagnostic.open_float() end, "Hover diagnostic" },
            r = { "<cmd>Telescope lsp_references<cr>", "References" },
            n = { function() vim.lsp.buf.rename() end, "Rename" },
          },
        },
        { prefix = "<leader>" }
      )
    end,
  }
})
