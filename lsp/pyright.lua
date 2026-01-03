return {
	cmd = { "pyright-langserver", "--stdio" },
	root_markers = { "requirements.txt" },
	filetypes = { "python" },
	settings = {
		pyright = {
			disableOrganizeImports = true,
		},
		python = {
			analysis = {
				typeCheckingMode = "off",
			},
		},
	},
}
