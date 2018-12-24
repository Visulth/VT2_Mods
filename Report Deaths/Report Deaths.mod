return {
	run = function()
		fassert(rawget(_G, "new_mod"), "Report Deaths must be lower than Vermintide Mod Framework in your launcher's load order.")

		new_mod("Report Deaths", {
			mod_script       = "scripts/mods/Report Deaths/Report Deaths",
			mod_data         = "scripts/mods/Report Deaths/Report Deaths_data",
			mod_localization = "scripts/mods/Report Deaths/Report Deaths_localization"
		})
	end,
	packages = {
		"resource_packages/Report Deaths/Report Deaths"
	}
}
