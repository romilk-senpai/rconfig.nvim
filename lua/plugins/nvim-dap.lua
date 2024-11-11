return {
  'romilk-senpai/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'julianolf/nvim-dap-lldb',
    'leoluz/nvim-dap-go',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      { '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
      { '<F6>', dap.step_into, desc = 'Debug: Step Into' },
      { '<F7>', dap.step_over, desc = 'Debug: Step Over' },
      { '<F8>', dap.step_out, desc = 'Debug: Step Out' },
      { '<leader>b', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      {
        '<leader>B',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      { '<F4>', dapui.toggle, desc = 'Debug: See last session result.' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve',
      },
    }

    local lldb_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.11.1/bin'

    dapui.setup()

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    local vstuc_path = vim.env.HOME .. '/.vscode/extensions/visualstudiotoolsforunity.vstuc-1.0.4/bin/'
    dap.adapters.vstuc = {
      type = 'executable',
      command = 'dotnet',
      args = { vstuc_path .. 'UnityDebugAdapter.dll' },
      name = 'Attach to Unity',
    }

    require('dap-lldb').setup()
    -- dap.configurations.c = {
    --   {
    --     name = 'Launch debugger',
    --     type = 'lldb',
    --     request = 'launch',
    --     cwd = '${workspaceFolder}',
    --     program = function()
    --       local out = vim.fn.system { 'make', 'debug' }
    --       if vim.v.shell_error ~= 0 then
    --         vim.notify(out, vim.log.levels.ERROR)
    --         return nil
    --       end
    --       return 'path/to/executable'
    --     end,
    --   },
    -- }
    dap.configurations.cs = {
      {
        type = 'vstuc',
        request = 'attach',
        name = 'Attach to Unity',
        projectPath = function()
          local path = vim.fn.expand '%:p'
          while true do
            local new_path = vim.fn.fnamemodify(path, ':h')
            if new_path == path then
              return ''
            end
            path = new_path
            local assets = vim.fn.glob(path .. '/Assets')
            if assets ~= '' then
              return path
            end
          end
        end,
        endPoint = function()
          local system_obj = vim.system({ 'dotnet', vstuc_path .. 'UnityAttachProbe.dll' }, { text = true })
          local probe_result = system_obj:wait(2000).stdout
          if probe_result == nil or #probe_result == 0 then
            print 'No endpoint found (is unity running?)'
            return ''
          end
          for json in vim.gsplit(probe_result, '\n') do
            if json ~= '' then
              local probe = vim.json.decode(json)
              for _, p in pairs(probe) do
                if p.isBackground == false then
                  return p.address .. ':' .. p.debuggerPort
                end
              end
            end
          end
          return ''
        end,
      },
    }

    require('dap-go').setup {
      delve = {
        detached = vim.fn.has 'win32' == 0,
      },
      dap_configurations = {
        {
          type = 'go',
          name = 'Debug (Build Flags)',
          request = 'launch',
          program = '${file}',
          buildFlags = require('dap-go').get_build_flags,
        },
        {
          type = 'go',
          name = 'Debug (Build Flags & Arguments)',
          request = 'launch',
          program = '${file}',
          args = require('dap-go').get_arguments,
          buildFlags = require('dap-go').get_build_flags,
        },
      },
    }
  end,
}
