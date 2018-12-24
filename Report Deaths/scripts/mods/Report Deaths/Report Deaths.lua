local mod = get_mod("Report Deaths")

function mod.ReportEvent(report, player, text)

	if (not report) then
		return
	end
	
	if (player.bot_player == true) then -- can be nil sometimes
		
		if (mod:get("report_bots")) then
			mod:echo("[BOT] %s %s", player:name(), text)
		end
	
	else
	
		local profile = SPProfiles[player:profile_index()]
		local characterName = Localize(profile.character_name)
		mod:echo("%s [%s] %s", characterName, player:name(), text)
	
	end
end

mod:hook(PlayerUnitHealthExtension, "set_dead", function (func, self)
	
	mod.ReportEvent(mod:get("report_deaths"), self.player, mod:localize("has_died"))
	
	func(self)
end)

mod:hook(PlayerUnitHealthExtension, "knock_down", function (func, self, unit)
	
	mod.ReportEvent(mod:get("report_knocked"), self.player, mod:localize("knocked_down"))
	
	func (self, unit)
end)