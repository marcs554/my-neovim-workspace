vim.lsp.config('*', {
	root_markers = { '.git' },
})

vim.diagnostic.config({
	virtual_text  = true,
	severity_sort = true,
	float         = {
		style  = 'minimal',
		border = 'rounded',
		source = 'if_many',
		header = '',
		prefix = '',
	},
	signs         = {
		text = {
			[vim.diagnostic.severity.ERROR] = '✘',
			[vim.diagnostic.severity.WARN]  = '▲',
			[vim.diagnostic.severity.HINT]  = '⚑',
			[vim.diagnostic.severity.INFO]  = '»',
		},
	},
})
-- put early in lsp.lua
local orig = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts            = opts or {}
	opts.border     = opts.border or 'rounded'
	opts.max_width  = opts.max_width or 80
	opts.max_height = opts.max_height or 24
	opts.wrap       = opts.wrap ~= false
	return orig(contents, syntax, opts, ...)
end

-- 4) Per-buffer behavior on LSP attach (keymaps, auto-format, completion)
-- See :help LspAttach for the recommended pattern
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		local buf    = args.buf
		local map    = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, { buffer = buf }) end

		-- Keymaps (use builtin LSP buffer functions)
		map('n', 'K', vim.lsp.buf.hover)
		map('n', 'gd', vim.lsp.buf.definition)
		map('n', 'gD', vim.lsp.buf.declaration)
		map('n', 'gi', vim.lsp.buf.implementation)
		map('n', 'go', vim.lsp.buf.type_definition)
		map('n', 'gr', vim.lsp.buf.references)
		map('n', 'gs', vim.lsp.buf.signature_help)
		map('n', 'gl', vim.diagnostic.open_float)
		map('n', '<F2>', vim.lsp.buf.rename)
		map({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end)
		map('n', '<F4>', vim.lsp.buf.code_action)

		-- Put near your LSP on_attach
		local excluded_filetypes = {
			php = true,
			python = true,
			rust = true,
		}

		-- Auto-format on save (only if server can't do WillSaveWaitUntil)
		if not client:supports_method('textDocument/willSaveWaitUntil')
			and client:supports_method('textDocument/formatting')
			and not excluded_filetypes[vim.bo[buf].filetype]
		then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = vim.api.nvim_create_augroup('my.lsp.format', { clear = false }),
				buffer = buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})

-- 5) Define the Lua language server config (no mason/lspconfig)
-- See :help lsp-new-config and :help vim.lsp.config()
local caps = require('blink.cmp').get_lsp_capabilities()
vim.lsp.config['luals'] = {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
	capabilities = caps,
	settings = {
		Lua = {
			runtime = { version = 'LuaJIT' },
			diagnostics = { globals = { 'vim' } },
			workspace = {
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file('', true),
			},
			telemetry = { enable = false },
		},
	},
}


-- C/C++
vim.lsp.config['clangd'] = {
	cmd = {
		'clangd',
		'--clang-tidy',
		'--background-index',
		'--offset-encoding=utf-8',
	},
	root_markers = { 'clangd', 'compile_commands.json' },
	filetypes = { 'c', 'cpp', 'c', 'h', 'hpp' }
}

-- Rust
--vim.lsp.config['rust_ls'] = {
--	root_markers = { 'Cargo.toml', 'Cargo.lock' },
--	filetypes = { 'rs' },
--	servers = {
--		bacon_ls = {
--			enabled = diagnostics == "bacon-ls",
--		},
--		rust_analyzer = { enabled = false }
--	},
--}


vim.lsp.rust_analyzer = {
	capabilities = caps,
	settings = {
		['rust-analyzer'] = {
			assist = {
				importGranularity = "module",
				importPrefix = "by_self",
			},
			checkOnSave = {
				command = 'clippy', -- Enables clippy diagnostics on save
			},
			cargo = {
				allFeatures = true,   -- Enable all Cargo features
				loadOutDirsFromCheck = true, -- Load output directories from cargo check
				buildScripts = { enable = true }, -- Enable build scripts
			},
			procMacro = {
				enable = true,
				ignored = {
					['async-trait'] = { 'async_trait' },
					['napi-derive'] = { 'napi' },
					['async-recursion'] = { 'async_recursion' },
				},
			},
			files = {
				excludeDirs = {
					'.direnv', '.git', '.github', '.gitlab', 'bin', 'node_modules', 'target', 'venv', '.venv',
				},
			},
		},
	},
}


vim.lsp.config["ty"] = {
	cmd = { "ty", "server" },
	filetypes = { "python" },
	root_markers = { "ty.toml", "pyproject.toml", ".git" },
	capabilities = caps,
	settings = {

		ty = {
			diagnosticMode = "workspace",

			inlayHints = {
				variableTypes = true,
				callArgumentNames = true,
			},
			completions = {
				autoImport = true,
			},
		},
	},
}

vim.lsp.enable('luals')
vim.lsp.enable('clangd')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('ty')
