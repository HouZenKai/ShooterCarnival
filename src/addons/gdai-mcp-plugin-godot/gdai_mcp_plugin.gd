# Copyright 2025-present Delano Lourenco
# License: See LICENSE.md
# Website: https://gdaimcp.com
@tool
extends EditorPlugin


func _enable_plugin() -> void:
	if Engine.is_editor_hint():
		add_autoload_singleton("GDAIMCPRuntime", "res://addons/gdai-mcp-plugin-godot/gdai_mcp_runtime.gd")


func _disable_plugin() -> void:
	if Engine.is_editor_hint():
		remove_autoload_singleton("GDAIMCPRuntime")


func _enter_tree():
	var os = OS.get_name().to_lower()
	var arch = Engine.get_architecture_name().to_lower()
	
	const ALLOWED_OS = ["macos", "windows", "linux"]
	if os not in ALLOWED_OS:
		_print_err("GDAI MCP plugin does not support this Operating System (%s)!" % os)
		return
	
	const ALLOWED_ARCH = ["arm64", "x86_64"]
	if arch not in ALLOWED_ARCH:
		_print_err("GDAI MCP plugin does not support this CPU architecture (%s)!" % arch)
		return
	
	var shared_lib_path = _get_shared_lib_path(os, arch)
	if not FileAccess.file_exists(shared_lib_path) and not _is_debug():
		_print_err("Binary files for GDAI MCP plugin are missing, so the plugin wont be loaded. Please re-install the plugin from [url=https://gdaimcp.com]https://gdaimcp.com[/url] or disable the plugin in Project Settings.")
		return


func _get_shared_lib_path(p_os, p_arch):
	const BIN_PATH = "res://addons/gdai-mcp-plugin-godot/bin"
	var shared_lib_path = "%s/%s/libgdai-mcp-plugin-godot.%s.template_release.%s.%s" % [BIN_PATH, p_os, p_os, _get_suffix(p_os, p_arch), _get_ext(p_os)]
	return shared_lib_path.replace(".universal", "")


func _get_suffix(p_os, p_arch):
	if p_os == "macos":
		return "universal"
	return p_arch


func _get_ext(p_os: String):
	if p_os == "macos":
		return "dylib"
	if p_os == "linux":
		return "so"
	return "dll"


func _is_debug() -> bool:
	return DirAccess.dir_exists_absolute(ProjectSettings.globalize_path("res://addons/gdai-mcp-testsuite"))


func _print_err(p_bbcode: String):
	print_rich("[color=TOMATO][b]GDAIMCP::ERROR::[/b] " + p_bbcode + "[/color]")
