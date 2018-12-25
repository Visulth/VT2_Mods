local mod = get_mod("Report Deaths")

local function ReportEvent(report, player, text)

	if (not report) then
		return
	end
	
	if (player.bot_player) then -- can be nil sometimes
		
		if (mod:get("report_bots")) then
			mod:echo("[BOT] %s %s", player:name(), text)
		end
	
	else
	
		local profile = SPProfiles[player:profile_index()]
		local characterName = Localize(profile.character_name)
		mod:echo("%s [%s] %s", characterName, player:name(), text)
	
	end
end

mod:hook_safe(PlayerUnitHealthExtension, "set_dead", function (self)
	
	ReportEvent(mod:get("report_deaths"), self.player, mod:localize("has_died"))
	
end)

mod:hook_safe(PlayerUnitHealthExtension, "knock_down", function (self)
    
	ReportEvent(mod:get("report_knocked"), self.player, mod:localize("knocked_down"))
	
end)