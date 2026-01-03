return {
	cmd = { "clangd", "--background-index", "--header-insertion=never" },
	root_markers = {
		".clangd",
		".clang-tidy",
		".clang-format",
		"compile_commands.json",
		"compile_flags.txt",
		"configure.ac",
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
}
