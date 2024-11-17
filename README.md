# dap-jsonnet.nvim
This is a simple plugin that configures the jsonnet-debugger for nvim-dap

> [!IMPORTANT]
> Currently this needs my custom version of the [jsonnet-debugger](https://github.com/koskev/jsonnet-debugger) to support extvars

## Installation

lazy.nvim
```lua
{
	"koskev/dap-jsonnet.nvim",
	opts = {},
	dependencies = { 'mfussenegger/nvim-dap' }
},
```

## Configuration

Default config
```lua
require("dap-jsonnet").setup({
	debugger_binary = "jsonnet-debugger",
	debugger_args = { "--dap", "-s" },

	extvar = {
		values = {
			-- key: value
		},
		-- File in workdir containing all the extvars in the format {key: value}
		from_file = "extvars.json"
	},
	jpaths = {
		values = {
			-- value list
		},
		-- Json array containing all paths
		from_file = "jpaths.json"
	}
})
```
