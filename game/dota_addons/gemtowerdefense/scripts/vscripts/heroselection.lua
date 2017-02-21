
SELECTION_DURATION_LIMIT = 60

if HeroSelection == nil then
	HeroSelection = class({})
end


function HeroSelection:Init()

	self.PlayersPicked = 0
	self.PlayerHeroes = {}

	HeroSelection.TimeLeft = SELECTION_DURATION_LIMIT
	Timers:CreateTimer( 0.04, HeroSelection.Tick )
	
	EmitAnnouncerSound("announcer_ann_custom_mode_01")

	self.PickedListener = CustomGameEventManager:RegisterListener( "player_picked_hero", Dynamic_Wrap(HeroSelection, 'OnHeroPicked'))

	self.SelectListener = CustomGameEventManager:RegisterListener( "player_selected_hero", Dynamic_Wrap(HeroSelection, 'OnHeroSelected'))

end

function HeroSelection:Tick() 

	if HeroSelection.TimeLeft >= 0 then
		CustomGameEventManager:Send_ServerToAllClients( "picking_time_update", {time = HeroSelection.TimeLeft} )
	end

	HeroSelection.TimeLeft = HeroSelection.TimeLeft - 1

	if HeroSelection.TimeLeft == -1 then
		return nil

	elseif HeroSelection.TimeLeft >= 0 then
		return 1

	else
		return nil

	end
end


function HeroSelection:AllPicked()

    if self.PlayersPicked == PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) then
        return true
    else
        return false    
    end
end


function HeroSelection:IncremetHeroPickCount()

    self.PlayersPicked = self.PlayersPicked + 1

end


function HeroSelection:OnHeroSelected(data)
	local hero = data.hero
	local player = data.PlayerID

	CustomGameEventManager:Send_ServerToAllClients("player_selected_hero_client", {hero = hero, player = player})

end


function HeroSelection:OnHeroPicked(data)

	local hero = data.hero
	local player = data.PlayerID
	
	print(data)

	if HeroSelection.PlayerHeroes[ player ] == nil then
		HeroSelection:IncremetHeroPickCount()
		HeroSelection.PlayerHeroes[ player ] = hero

		CustomNetTables:SetTableValue("game_state", "pickedHeroes", { picked = HeroSelection.PlayerHeroes })
	end

	if HeroSelection:AllPicked() then
		HeroSelection.TimeLeft = 0
		HeroSelection:Tick()
		HeroSelection:EndPicking()
	end

end


function HeroSelection:EndPicking()

	CustomGameEventManager:UnregisterListener(self.SelectListener)
	CustomGameEventManager:UnregisterListener(self.PickedListener)

	for player, hero in pairs( HeroSelection.PlayerHeroes ) do
		HeroSelection:AssignHero( player, hero )
	end

	CustomGameEventManager:Send_ServerToAllClients( "picking_done", {} )

end


function HeroSelection:AssignHero( player, hero )
	PlayerResource:ReplaceHeroWith( player, hero, 0, 0 )
	HeroSelection:UnlockAbilities(player)
end


function HeroSelection:UnlockAbilities(player)
	local player = PlayerResource:GetPlayer(player)
	local hero = player:GetAssignedHero()

	HeroSelection:RemoveTalents(hero)

	hero:AddAbility("gem_build_tower"):SetLevel(1)
	hero:FindAbilityByName("gem_build_tower"):SetAbilityIndex(0)
	
	hero:AddAbility("gem_remove_tower"):SetLevel(1)
	hero:FindAbilityByName("gem_remove_tower"):SetAbilityIndex(1)
	--[[
	hero:AddAbility("gem_heal_throne"):SetLevel(1)
	hero:FindAbilityByName("gem_heal_throne"):SetAbilityIndex(1)
	]]
	hero:AddAbility("gem_tower_level"):SetLevel(1)
	hero:FindAbilityByName("gem_tower_level"):SetAbilityIndex(2)
end


function HeroSelection:RemoveTalents(hero)

	for i = 0,17 do

		local ability = hero:GetAbilityByIndex(i)

		if ability and string.match(ability:GetName(), "special_bonus") then

			hero:RemoveAbility(ability:GetName())

		end
	end
end
