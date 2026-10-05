return {
	'saghen/blink.cmp',
	version = '1.*',
	opts = {
		keymap = {
			present = default,
			['<Tab>'] = { 'select_and_accept', 'fallback' },
			-- ['<CR>'] = { 'select_and_accept', 'fallback' },
		},

		completion = {
			documentation = {
				auto_show = true,
			},
		},

		sources = {
			default = { 'lsp', 'path', 'buffer' },
		},
	},
}
