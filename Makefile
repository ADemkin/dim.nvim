vendor:
	uv sync

lint: vendor
	luacheck lua plugin
	uv run mdformat README.md

