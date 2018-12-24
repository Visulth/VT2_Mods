local mod = get_mod("Report Deaths")

-- Everything here is optional. You can remove unused parts.
return {
	name = "Report Deaths",                               -- Readable mod name
	description = mod:localize("mod_description"),  -- Mod description
	is_togglable = true,                            -- If the mod can be enabled/disabled
	is_mutator = false,                             -- If the mod is mutator
	mutator_settings = {},                          -- Extra settings, if it's mutator
	options_widgets = {                             -- Widget settings for the mod options menu
		{
			["setting_name"] = "report_deaths",
			["widget_type"] = "checkbox",
			["text"] = mod:localize("title"),
			["tooltip"] = mod:localize("deaths_tip"),
			["default_value"] = true
		},
		{
			["setting_name"] = "report_knocked",
			["widget_type"] = "checkbox",
			["text"] = mod:localize("report_knocked"),
			["tooltip"] = mod:localize("knocked_tip"),
			["default_value"] = false
		},
		{
			["setting_name"] = "report_bots",
			["widget_type"] = "checkbox",
			["text"] = mod:localize("report_bots"),
			["tooltip"] = mod:localize("bots_tip"),
			["default_value"] = false
		}
	}
}