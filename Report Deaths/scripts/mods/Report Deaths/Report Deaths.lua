local mod = get_mod("Report Deaths")

--https://github.com/Aussiemon/Vermintide-2-Source-Code/blob/002963bc62f33428b41d40380a438ba862a21e24/scripts/network_lookup/network_lookup.lua#L227
local DamageSourceNames = {
	skaven_slave = "a Slave Rat",
	skaven_clan_rat = "a Clan Rat",
	skaven_clan_rat_with_shield = "a Shield Clan Rat",
	skaven_storm_vermin = "a Stormvermin",
	skaven_storm_vermin_commander = "a Stormvermin",
	skaven_storm_vermin_with_shield = "a Shield Stormvermin",
	skaven_plague_monk = "a Plague Monk",
	chaos_marauder = "a Chaos Marauder",
	chaos_marauder_with_shield = "a Shield Chaos Marauder",
	chaos_raider = "a Chaos Mauler",
	chaos_fanatic = "a Chaos Fanatic",
	chaos_warrior = "a Chaos Warrior",
	chaos_berzerker = "a Chaos Berserker",
	beastmen_bestigor = "a Bestigor",
	beastmen_gor = "a Gor",
	beastmen_ungor = "an Ungor",
	beastmen_ungor_archer = "an Ungor Archer",
	beastmen_standard_bearer = "a Standard Bearer",
	
	--specials
	skaven_ratling_gunner = "a Ratling Gunner",
	skaven_poison_wind_globadier = "a Globadier",
	skaven_gutter_runner = "a Gutter Runner",
	skaven_pack_master = "a Pack Master",
	skaven_warpfire_thrower = "a Warpfire Thrower",
	chaos_plague_sorcerer = "a Plague Sorcerer",
	chaos_corruptor_sorcerer = "a Lifeleech",
	chaos_vortex_sorcerer = "a Blightstormer",
	chaos_vortex = "a Blightstorm",
	
	--monsters
	chaos_spawn = "a Chaos Spawn",
	chaos_troll = "a Chaos Troll",
	skaven_rat_ogre = "a Rat Ogre",
	skaven_stormfiend = "a Stormfiend",
	beastmen_minotaur = "a Minotaur",
	
	--lords
	chaos_exalted_champion_warcamp = "Bödvarr Ribspreader",
	chaos_exalted_champion_norsca = "Gatekeeper Naglfahr",
	chaos_exalted_sorcerer = "Burblespue Halescourge",
	skaven_storm_vermin_warlord = "Skarrik Spinemanglr",
	skaven_storm_vermin_champion = "Chieftain Krench",
	chaos_plague_wave_spawner = "Burblespue Halescourge",
	skaven_stormfiend_boss = "Deathrattler",
	skaven_grey_seer = "Rasknitt",
	
	--damageTypes for sources not considered enemies
	vomit_ground = "acid", --used for buboes and troll bile
	vomit_face = "Chaos Troll bile",
	plague_face = "Chaos magic", --used for Rasknitt ground beam and Halescourge triple-slime DoT
	burninating = "fire", --lamp oil fire and UC explosive damage
	explosive_barrel = "an Explosive Barrel",
	knockdown_bleed = "bleeding out",
	kinetic = "falling",
	overcharge = "overheating",
	magic_barrel = "a Spark Barrel",
}

local function ReportEvent(player, text)

	local network_manager = Managers.state.network
	local is_server = network_manager.is_server
	local player_name = player:name()
	
	local profile = SPProfiles[player:profile_index()]
	local character_name_short = Localize(profile.ingame_short_display_name)
	
	if (is_server and player.bot_player) then
		
		if (mod:get("report_bots")) then
			mod:echo("[BOT] %s %s", character_name_short, text)
		end
	
	else
		local character_name = Localize (profile.character_name)
		if (not is_server and character_name == player_name) then
			--Crude way of checking for bots as client...
			mod:echo("[BOT] %s %s", character_name_short, text)
		else
			mod:echo("%s [%s] %s", character_name_short, player_name, text)
		end
	
	end
end

--Output localized player names or output strings associated with internal names
local function GetDamageSourceOutputString(damageSource)
	
	local damageSourceName = ""
	if (DamageUtils.is_player_unit(damageSource)) then
		local owner = Managers.player:owner(damageSource)
		local profile_index = owner:profile_index()		
		damageSourceName = Localize(SPProfiles[profile_index].character_name)
	else
		damageSourceName = DamageSourceNames[damageSource]
		if (damageSourceName == nil) then
			damageSourceName = "'" .. tostring(damageSource) .. "'"
		end
	end
	
	return damageSourceName
end

local function GetLastDamageSource(health_extension)

	local array_length = 0
	local damageSource = ""
	damage_info, array_length = health_extension:recent_damages()
	
	if (not array_length or array_length == 0) then
		--Alternate lookup for remote players on clients, on death, etc.
		local damage_buffers = health_extension.damage_buffers
		local system_data = health_extension.system_data
		local active_damage_buffer_index = system_data.active_damage_buffer_index
		local damage_queue = damage_buffers[active_damage_buffer_index]
		damage_info, array_length = pdArray.data(damage_queue)
	end
	
	if array_length > 0 then
		for i = 1, array_length / DamageDataIndex.STRIDE, 1 do
			local index = (i - 1) * DamageDataIndex.STRIDE
			local attacker_unit = damage_info[index + DamageDataIndex.ATTACKER]
			local damage_type = damage_info[index + DamageDataIndex.DAMAGE_TYPE]
			local damage_source_name = damage_info[index + DamageDataIndex.DAMAGE_SOURCE_NAME]
			
			--mod:echo("attacker_unit: [%s], damage_type: [%s], damage_source_name: [%s]", attacker_unit, damage_type, damage_source_name)
			
			if (DamageUtils.is_enemy(attacker_unit)) then
				damageSource = Unit.get_data(attacker_unit, "breed").name
			else				
				if (DamageSourceNames[damage_source_name]) then
				--e.g., gas, troll long acid pool, stormfiend ground-fire, rasknitt triple burst
					damageSource = damage_source_name
				elseif (DamageSourceNames[damage_type]) then
				--e.g., rasknitt ground beam, troll small acid pool, fire barrel report damage_type but no- or a non-descriptive- damage_source_name
					damageSource = damage_type
				elseif (DamageUtils.is_player_unit(attacker_unit)) then
					damageSource = attacker_unit
				end
			
			end				
		end
	--else				
		--damageSource = health_extension._recent_damage_type
		--worst case scenario, output the damage type
	end
	
	return damageSource
	
end

mod:hook_safe(PlayerUnitHealthExtension, "set_dead", function (self)
	
	if (not mod:get("report_deaths")) then
		return
	end
	
	local damageSource = GetLastDamageSource(self)
	if (damageSource ~= nil and damageSource ~= "") then
		ReportEvent(self.player, mod:localize("killed_by") .. GetDamageSourceOutputString(damageSource))
	else
		ReportEvent(self.player, mod:localize("has_died"))
	end
	
end)

mod:hook_safe(GenericStatusExtension, "set_knocked_down", function (self)
	if (not mod:get("report_knocked") or not self.knocked_down) then
		return
	end
	
	local damageSource = GetLastDamageSource(self.health_extension)
	if (damageSource ~= nil and damageSource ~= "") then
		ReportEvent(self.player, mod:localize("knocked_down_by") .. GetDamageSourceOutputString(damageSource))
	else
		ReportEvent(self.player, mod:localize("knocked_down"))
	end	
	
end)