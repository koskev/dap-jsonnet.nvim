local M = {}

local default_config = {
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
}

-- TODO: search all parent directories until one is found?
local function build_from_file(filename)
	local f = io.open(filename, "r")
	if f then
		local content = f:read "*all"
		local json_table = vim.json.decode(content)
		return json_table
	end
	return {}
end

local function build_jpaths(opts)
	local json_table = build_from_file(opts.jpaths.from_file)
	local merged_jpaths = opts.jpaths.values
	merged_jpaths = vim.tbl_deep_extend("force", opts.jpaths.values, json_table or {})
	return merged_jpaths
end

local function build_extvars(opts)
	local json_table = build_from_file(opts.extvar.from_file)
	local merged_extvar = opts.extvar.values
	merged_extvar = vim.tbl_deep_extend("force", opts.extvar.values, json_table or {})
	return merged_extvar
end

function M.setup(opts)
	local dap = require("dap")
	local config = vim.tbl_deep_extend("force", default_config, opts or {})

	local extvars = build_extvars(config)
	local jpaths = build_jpaths(config)

	dap.adapters.jsonnet = {
		type = "executable",
		command = config.debugger_binary,
		args = config.debugger_args,
	}
	dap.configurations.jsonnet = {
		{
			type = "jsonnet",
			request = "launch",
			name = "Debug Jsonnet",

			program = "${file}",
			extvars = extvars,
			jpaths = jpaths
		},
		-- TODO: launch config with different extvars?
	}
end

return M
