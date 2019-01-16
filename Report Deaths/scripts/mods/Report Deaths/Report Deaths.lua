local mod = get_mod("Report Deaths")

local function ReportEvent(player, text)

	local network_manager = Managers.state.network
	local is_server = network_manager.is_server
	local player_name = player:name()
	
	if (is_server and player.bot_player) then
		
		if (mod:get("report_bots")) then
			mod:echo("[BOT] %s %s", player_name, text)
		end
	
	else
	
		local profile = SPProfiles[player:profile_index()]
		local characterName = Localize(profile.character_name)
		if (not is_server and characterName == player_name) then
			--Crude way of checking if remote players are bots as client...
			mod:echo("[BOT] %s %s", player_name, text)
		else
			mod:echo("%s [%s] %s", characterName, player_name, text)
		end
	
	end
end

mod:hook_safe(PlayerUnitHealthExtension, "set_dead", function (self)
	
	if (not mod:get("report_deaths")) then
		return
	end
	
	ReportEvent(self.player, mod:localize("has_died"))
	
end)

mod:hook_safe(GenericStatusExtension, "set_knocked_down", function (self)
    
	if (not mod:get("report_knocked") or not self.knocked_down) then
		return
	end
	
	ReportEvent(self.player, mod:localize("knocked_down"))
	
end)