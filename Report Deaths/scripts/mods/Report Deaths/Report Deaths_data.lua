local mod = get_mod("Report Deaths")

-- Everything here is optional. You can remove unused parts.
return {
	name = "Report Deaths",                               -- Readable mod name
	description = mod:localize("mod_description"),  -- Mod description
	is_togglable = true,                            -- If the mod can be enabled/disabled
	options = {
		widgets = {
			{
				setting_id    = "report_deaths",
				type          = "checkbox",
				default_value = true
			},
			{
				setting_id    = "report_knocked",
				type          = "checkbox",
				default_value = false
			},
			{
				setting_id    = "report_bots",
				type          = "checkbox",
				default_value = false
			},
			{
				setting_id    = "report_cause",
				type          = "checkbox",
				default_value = true
			},
		}
	}
}