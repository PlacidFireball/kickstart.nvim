-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {},
  },
  { 'famiu/bufdelete.nvim' },
  {
    'scalameta/nvim-metals',
    ft = { 'scala', 'sbt', 'java' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'j-hui/fidget.nvim',
        opts = {},
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>cW", function() require('metals').hover_worksheet() end,               desc = "Metals Worksheet" },
      { "<leader>cM", function() require('telescope').extensions.metals.commands() end, desc = "Telescope Metals Commands" },
    },
    init = function()
      local metals_config = require('metals').bare_config()
      require('metals').setup_dap()

      metals_config.settings = {
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        superMethodLensesEnabled = true,
      }

      local function get_operating_system()
        if jit then
          return jit.os
        end

        local fh, err = assert(io.popen('uname -o 2>/dev/null', 'r'))

        if fh then
          return fh:read()
        else
          return 'Windows'
        end
      end

      operating_system = get_operating_system()

      if operating_system == 'Darwin' or operating_system == 'OSX' then
        -- print('Setting gradleScript/javaHome.')
        -- print(operating_system)
        metals_config.settings.gradleScript = '/opt/gradle/gradle-8.0.2/bin/gradle'
        metals_config.settings.javaHome = '/Library/Java/JavaVirtualMachines/liberica-jdk-17.jdk/Contents/Home'
      else
        print 'This is not an apple system. Not setting up gradle/java home'
        -- print(operating_system)
      end

      metals_config.init_options.statusBarProvider = 'on'
      metals_config.capabilities = require('cmp_nvim_lsp').default_capabilities()

      local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'scala', 'sbt' },
        callback = function()
          require('metals').initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
    dependencies = 'nvim-treesitter/nvim-treesitter',
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    keys = {
      { '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
    },
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        group_empty_dirs = true,
        window = {
          mappings = {
            ['\\'] = 'close_window',
          },
        },
      },
    },
  },
  {
    'alexghergh/nvim-tmux-navigation',
    config = function()
      local nvim_tmux_nav = require 'nvim-tmux-navigation'

      nvim_tmux_nav.setup {
        disable_when_zoomed = true,
        keybindings = {
          left = '<C-h>',
          down = '<C-j>',
          up = '<C-k>',
          right = '<C-l>',
          last_active = '<C-\\>',
          next = '<C-Space>',
        },
      }
    end,
  },
}
