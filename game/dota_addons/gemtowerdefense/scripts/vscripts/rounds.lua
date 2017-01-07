
if Rounds == nil then
	Rounds = class({})
	
end


function Rounds:Init(keyvalue)

	ListenToGameEvent('entity_killed', Dynamic_Wrap(Rounds, 'OnEntityKilled'), self)
	ListenToGameEvent('all_placed', Dynamic_Wrap(Rounds, 'OnAllPlaced'), self)

	self.PlayerCount 	= 0
	self.AllPicked 			= false
	self.State 				= "BUILD"  	--"BUILD" Build Phase, "WAVE" Wave Phase
    self.AmountKilled 		= 0
	self.AmountSpawned 		= 0
    self.SpawnedCreeps 		= {}
    self.RoundNumber 		= 1
    self.SpawnPosition 		= Entities:FindByName(nil, "enemy_spawn"):GetAbsOrigin()
	self.BaseHealth 		= 100
	self.BuildLevel 		= 1

	self.TotalKilled 		= 0
	self.TotalLeaked 		= 0
	self.DelayBetweenSpawn 	= 1
	self.Data 				= keyvalue

end


function Rounds:WaveInit()
	
	self.State = "WAVE"
	CustomNetTables:SetTableValue( "game_state", "current_round", { value = tostring(self.RoundNumber) } )
	
	if Rounds:IsBoss() then

		Rounds:SpawnBoss()

	else

		Rounds:SpawnUnits()

	end

end

function Rounds:AddUnitProperties(unit)

	unit.Damage 			= self.Data[tostring(self.RoundNumber)]["Damage"]
	unit.Name 				= self.Data[tostring(self.RoundNumber)]["unit"]
	unit.XPBounty			= self.Data[tostring(self.RoundNumber)]["XPBounty"]
	unit.GoldBounty 		= self.Data[tostring(self.RoundNumber)]["GoldBounty"]
	unit.Type 				= self.Data[tostring(self.RoundNumber)]["Type"]

end

--[[
"Difficulty"
        {
            "MoveSpeedQuocient" "1.1"
            "HitPointQuocient"  "1.2"
]]--


function Rounds:SpawnUnits()

	self.State = "WAVE"

	local waveData = Rounds:LoadWaveData()

	Timers:CreateTimer( function()
		
		self.AmountSpawned = self.AmountSpawned + 1
       
		local unit = CreateUnitByName(waveData.unitName, self.SpawnPosition, false, nil, nil, DOTA_TEAM_BADGUYS)
		local eHandle = unit:GetEntityHandle()

		self.SpawnedCreeps[eHandle] = unit

		Rounds:AddCreepProperties(unit, waveData)
		--unit:AddAbility("gem_collision_movement"):SetLevel(1)
			
		Grid:MoveUnit(unit)

		if self.AmountSpawned == 10 then

			self.AmountSpawned = 0
        	return nil
				
		else

			return self.DelayBetweenSpawn

		end
    end)
end

function Rounds:SpawnBoss()

	local waveData = Rounds:LoadWaveData()

	self.State = "WAVE"
	local boss = CreateUnitByName(waveData.unitName, self.SpawnPosition, false, nil, nil, DOTA_TEAM_BADGUYS)
	local eHandle = boss:GetEntityHandle()

	self.SpawnedCreeps[eHandle] = boss
	Rounds:AddCreepProperties(boss, waveData)

	Grid:MoveUnit(boss, boss.type)
	boss:AddAbility("gem_collision_movement"):SetLevel(1)

end

function Rounds:RemoveTalents(hero)

	local start = 2

	for i = 0,10 do

		local ability = hero:GetAbilityByIndex(i)

		if ability and string.match(ability:GetName(), "special_bonus") then

			hero:RemoveAbility(ability:GetName())

		end
	end

end

function Rounds:GetRoundNumber()

	return self.RoundNumber

end




function Rounds:InsertByHandle(index, unit)

	self.SpawnedCreeps[index] = unit 

end

function Rounds:DeleteUnit(index)

	self.SpawnedCreeps[index] = nil

end

function Rounds:IncrementRound()

	self.RoundNumber = self.RoundNumber + 1

end

function Rounds:IncrementKillNumber()

	self.AmountKilled = self.AmountKilled + 1

end

function Rounds:ResetKillNumber()

	self.AmountKilled = 0

end


function Rounds:RemoveHP(value)

	self.BaseHealth = self.BaseHealth - value

end

function Rounds:IncrementTotalLeaked()

	self.TotalLeaked = self.TotalLeaked + 1


end

function Rounds:GetBaseHealth()

	return self.BaseHealth

end

function Rounds:OnTouchGemCastle(trigger)

	local unit = trigger.activator
	local eHandle = unit:GetEntityHandle()
	
		
		if unit and string.match(unit:GetUnitName(), "gem_round") then

			self.SpawnedCreeps[eHandle] = nil

			self.BaseHealth = self.BaseHealth - unit:GetBaseDamageMax()
			self.AmountKilled = self.AmountKilled + 1

			unit:Destroy()

			CustomNetTables:SetTableValue( "game_state", "gem_castle_health", { value = tostring(self.BaseHealth) } )
	
			if Rounds:IsBoss() then

				Rounds:UpdateWaveData()
				--print("")
				FireGameEvent("round_end", {state = "BUILD"})

			elseif Rounds:IsRoundCleared() then

				Rounds:UpdateWaveData()
				FireGameEvent("round_end", {state = "BUILD"})

			end
			
		else

			--Hero stepped in

		end
end


function Rounds:OnEntityKilled(keys)

	local unit = EntIndexToHScript(keys.entindex_killed)
	local eHandle = unit:GetEntityHandle()

	Rounds:AddHeroBountyOnKill(unit)

	self.AmountKilled = self.AmountKilled + 1

	self.SpawnedCreeps[eHandle] = nil

	if Rounds:IsBoss() then

		Rounds:UpdateWaveData()
		FireGameEvent("round_end", {playerID = "0"})

	elseif Rounds:IsRoundCleared() then

			Rounds:UpdateWaveData()
			FireGameEvent("round_end", {state = "BUILD"})
			print("Firing game event!")

		
	end
end

function Rounds:OnAllPlaced(keys)

	Rounds:WaveInit()

end

function Rounds:IsBoss()

	if wavesKV[tostring(self.RoundNumber)]["Boss"] == "Yes" then

		return true

	else

		return false

	end
end

function Rounds:IsRoundCleared()

	if self.AmountKilled == 10 then

		return true

	else
		return false
	end
end

function Rounds:UpdateWaveData()

	self.State = "BUILD"
	self.AmountKilled = 0
	self.RoundNumber = self.RoundNumber + 1

end

function Rounds:AddHeroBountyOnKill(unit)

	for i = 0, PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) - 1 do

		local player = PlayerResource:GetPlayer(i)
		local hero = player:GetAssignedHero()
		local playerID = player:GetPlayerID()

		hero:AddExperience(unit.GoldBounty, 0, false, false)
		PlayerResource:ModifyGold(i, unit:GetMaximumGoldBounty(), false, 0)
		

	end

end

function Rounds:LoadWaveData()

	local loadWave = wavesKV[tostring(self.RoundNumber)]
	local loadDifficulty = settingsKV[tostring(tostring(PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)))]["Difficulty"]

	local TableData = 
	{
	
		unitDamage 		= loadWave["Damage"],
 		unitName 		= loadWave["Creep"],
 		unitSpeed 		= loadWave["MoveSpeed"],
		unitXPBounty 	= loadWave["XPBounty"],
		unitGoldBounty 	= loadWave["GoldBounty"],
		unitType 		= loadWave["Type"],
		unitHealth 		= loadWave["Health"],
		unitIsBoss		= loadWave["IsBoss"],

		difficultySpeed 	= loadDifficulty["MoveSpeedQuocient"],
 		difficultyHealth 	= loadDifficulty["HitPointQuocient"]

	}

	return TableData

end


function Rounds:AddCreepProperties(unit, table)
	
	unit:SetBaseDamageMin(table.unitDamage)
	unit:SetBaseDamageMax(table.unitDamage)
	unit:SetBaseMoveSpeed(table.unitSpeed * table.difficultySpeed)
	unit:SetMaximumGoldBounty(table.unitGoldBounty)
	--unit:SetDeathXP(table.unitXPBounty)
	unit:SetBaseMaxHealth(table.unitHealth * table.difficultyHealth)
	unit:SetHullRadius(0)
	unit.GoldBounty = table.unitGoldBounty

end
