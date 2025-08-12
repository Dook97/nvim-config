return {
	cmd = { "gopls" },
	root_markers = { "go.mod", "go.sum" },
	filetypes = { "go" },
	settings = {
		gopls = {
			staticcheck = true,
			linksInHover = false,
		},
	},
}
