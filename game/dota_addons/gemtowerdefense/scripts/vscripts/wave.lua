
MAX_ROUND = 48
START_WAVE = 1

if Wave == nil then
	Wave = class({})	
end


function Wave:Init(keyvalue)

	ListenToGameEvent('entity_killed', Dynamic_Wrap(Wave, 'OnEntityKilled'), self)
	ListenToGameEvent('all_placed', Dynamic_Wrap(Wave, 'OnAllPlaced'), self)
	ListenToGameEvent('reset_round', Dynamic_Wrap(Wave, 'OnReset'), self)
	ListenToGameEvent('throne_touch', Dynamic_Wrap(Wave, 'OnThroneTouch'), self)
	ListenToGameEvent('kill_round', Dynamic_Wrap(Wave, 'OnForceKill'), self)

	self.PlayerCount = 0
	self.AllPicked = false
	self.State = "BUILD"  	--"BUILD" Build Phase, "WAVE" Wave Phase
	self.AmountKilled = 0
	self.IsEnd = false
	self.isRoundTerminated = false

	self.SpawnedCreeps = {}
	self.FinalBoss = nil
	self.AllSpawned = false
	self.RoundNumber = 1
	self.SpawnPosition = Entities:FindByName(nil, "enemy_spawn"):GetAbsOrigin()

	self.TotalKilled = 0
	self.TotalLeaked = 0
	self.DelayBetweenSpawn = 1
	self.Data = keyvalue

end


function Wave:WaveInit()
	
	self.State = "WAVE"
	self.isRoundTerminated = false
	GameData.TowerDamage = {}
	GameData.topDamage = {}
	CustomNetTables:SetTableValue( "game_state", "current_round", { value = tostring(self.RoundNumber) } )
	GameRules:SetTimeOfDay(0.8)

	if Wave:IsBoss() then

		if Wave:IsFinal() then
			Wave:SpawnDamageTest()
		else
			Wave:SpawnBoss()
		end
	else

		Wave:SpawnUnits()

	end

end

function Wave:AddUnitProperties(unit)

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

function Wave:OnReset(keys)
	Wave:WaveInit()
end

function Wave:SpawnUnits()

	self.State = "WAVE"
	local amountSpawned = 0
	local waveData = Wave:LoadWaveData()

	Timers:CreateTimer( function()
		
		if self.isRoundTerminated then
			return nil
		end

		local unit = CreateUnitByName(waveData.unitName, self.SpawnPosition, false, nil, nil, DOTA_TEAM_BADGUYS)
		local eHandle = unit:GetEntityHandle()
		amountSpawned = amountSpawned + 1
		self.SpawnedCreeps[eHandle] = unit

		Wave:AddCreepProperties(unit, waveData)
		unit:AddAbility("gem_collision_movement"):SetLevel(1)
			
		Grid:MoveUnit(unit)

		if amountSpawned == 10 then
			self.AllSpawned = true
        	return nil	
		else
			return self.DelayBetweenSpawn
		end
    end)
end

function Wave:SpawnBoss()

	local waveData = Wave:LoadWaveData()

	self.State = "WAVE"
	local boss = CreateUnitByName(waveData.unitName, self.SpawnPosition, false, nil, nil, DOTA_TEAM_BADGUYS)
	local eHandle = boss:GetEntityHandle()

	self.SpawnedCreeps[eHandle] = boss
	Wave:AddCreepProperties(boss, waveData)

	Grid:MoveUnit(boss, boss.type)
	boss:AddAbility("gem_collision_movement"):SetLevel(1)

end

function Wave:RemoveTalents(hero)

	local start = 2

	for i = 0,10 do

		local ability = hero:GetAbilityByIndex(i)

		if ability and string.match(ability:GetName(), "special_bonus") then

			hero:RemoveAbility(ability:GetName())

		end
	end

end

function GetState()
	return self.State
end

function Wave:GetEnemies()
	return self.SpawnedCreeps
end

function Wave:GetRoundNumber()
	return self.RoundNumber
end

function Wave:SetRoundNumber(value)
	self.RoundNumber = value
end

function Wave:InsertByHandle(index, unit)
	self.SpawnedCreeps[index] = unit 
end

function Wave:DeleteUnit(index)
	self.SpawnedCreeps[index] = nil
end

function Wave:DeleteAllUnits()
	for key, unit in pairs(self.SpawnedCreeps) do
		unit:Destroy()
		self.SpawnedCreeps[key] = nil
	end
end

function Wave:IncrementRound()
	self.RoundNumber = self.RoundNumber + 1
end

function Wave:IncrementKillNumber()
	self.AmountKilled = self.AmountKilled + 1
end

function Wave:ResetKillNumber()
	self.AmountKilled = 0
end

function Wave:IncrementTotalLeaked()
	self.TotalLeaked = self.TotalLeaked + 1
end


function Wave:GetState()

	return self.State

end
--[[
function Wave:OnTouchGemCastle(trigger)

	local unit = trigger.activator
	local eHandle = unit:GetEntityHandle()
	
	if unit.GoldBounty ~= nil then
		if unit and string.match(unit:GetUnitName(), "gem_round") then

			self.SpawnedCreeps[eHandle] = nil

			self.BaseHealth = self.BaseHealth - unit:GetBaseDamageMax()
			self.AmountKilled = self.AmountKilled + 1

			unit:Destroy()

			CustomNetTables:SetTableValue( "game_state", "gem_castle_health", { value = tostring(self.BaseHealth) } )
	
			if Wave:IsBoss() then

				Wave:UpdateWaveData()
				--print("")

				local data = {state = "BUILD"}

				FireGameEvent("round_end", data)

			elseif Wave:IsRoundCleared() then

				Wave:UpdateWaveData()
				FireGameEvent("round_end", data)

			end
			
		else

			--Hero stepped in

		end
	end
end
]]--

function Wave:OnEntityKilled(keys)

	local unit = EntIndexToHScript(keys.entindex_killed)
	local eHandle = unit:GetEntityHandle()

	Wave:AddHeroBountyOnKill(unit)

	self.SpawnedCreeps[eHandle] = nil

	if Wave:IsBoss() then

		Wave:UpdateWaveData()

		local data = {state = "BUILD"}
		
		FireGameEvent("round_end", data)

	elseif Wave:IsRoundCleared() then


		local data = {state = "BUILD"}

		Wave:UpdateWaveData()
		
		FireGameEvent("round_end", data)
		
	end
end

function Wave:OnAllPlaced(keys)

	Wave:WaveInit()

end

function Wave:IsBoss()

	if wavesKV[tostring(self.RoundNumber)]["Boss"] == "Yes" then

		return true

	else

		return false

	end
end

function Wave:IsRoundCleared()

	if Containers.TableLength(self.SpawnedCreeps) == 0 then
		return true
	else
		return false
	end
end

function Wave:UpdateWaveData()
	if not self.IsEnd then
		if Wave:IsBoss() then
			for i = 0, PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) - 1 do
				local player = PlayerResource:GetPlayer(i)
				local hero = player:GetAssignedHero()
				local playerID = player:GetPlayerID()
				hero:GiveMana(6)
			end
		end
		Wave:AddMVPAbility()
		self.State = "BUILD"
		self.AmountKilled = 0
		self.RoundNumber = self.RoundNumber + 1
		self.AllSpawned = false
	else
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
		--In post game we send data to server
	end


end

function Wave:AddMVPAbility()

	local maxDamage = 0
	local maxUnit = nil
	if GameData.TowerDamage then
		for key, value in pairs(GameData.TowerDamage) do
			if EntIndexToHScript(key).MVPLevel == nil or EntIndexToHScript(key).MVPLevel < 10 then
				if value>maxDamage then
					maxDamage = value
					for i , j in pairs(Builder.GlobalTowers) do
						if j:GetEntityIndex() == key then
							maxUnit = j
						end
					end
				end
			end
		end
	end

	if maxDamage ~= 0 and maxUnit ~= nil then
		Wave:Ability_MVP_Level_Up(maxUnit,1)
	end
end

function Wave:Ability_MVP_Level_Up(unit,upLevel)
    if upLevel == nil then
        upLevel = 1
    end
    if upLevel > 10 then
        upLevel = 10
    end

    if unit.MVPLevel == nil then
        unit.MVPLevel = 0
    end
    local a_name = "gem_MVP_"..unit.MVPLevel
    local m_name = "modifier_MVP_aura_"..unit.MVPLevel

	if unit:FindAbilityByName(a_name) then
		unit:RemoveAbility(a_name)
		unit:RemoveModifierByName(m_name)
	end

    unit.MVPLevel = unit.MVPLevel + upLevel
	if unit.MVPLevel > 10 then
    	unit.MVPLevel = 10
    end
    unit:AddAbility("gem_MVP_"..unit.MVPLevel)
    unit:FindAbilityByName("gem_MVP_"..unit.MVPLevel):SetLevel(1)
    local ModMasterMVP = CreateItem("item_modifier_master", nil, nil) 
	ModMasterMVP:ApplyDataDrivenModifier(unit, unit, "modifier_tower_MVP",{duration = 5.0})
end

function Wave:AddHeroBountyOnKill(unit)

	for i = 0, PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) - 1 do

		local player = PlayerResource:GetPlayer(i)
		local hero = player:GetAssignedHero()
		local playerID = player:GetPlayerID()

		hero:AddExperience(unit.GoldBounty, 0, false, false)
		PlayerResource:ModifyGold(i, unit:GetMaximumGoldBounty(), false, 0)
		

	end

end

function Wave:LoadWaveData()

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


function Wave:AddCreepProperties(unit, table)
	
	unit:SetBaseDamageMin(table.unitDamage)
	unit:SetBaseDamageMax(table.unitDamage)
	unit:SetBaseMoveSpeed(table.unitSpeed * table.difficultySpeed)
	unit:SetMaximumGoldBounty(table.unitGoldBounty)
	--unit:SetDeathXP(table.unitXPBounty)
	unit:SetBaseMaxHealth(table.unitHealth * table.difficultyHealth)
	unit:SetHullRadius(0)
	unit.GoldBounty = table.unitGoldBounty

end

function Wave:OnThroneTouch(keys)
	DeepPrintTable(keys)
	local handle = keys.handle--this shit gets casted to fucking string
	local enemy = self.SpawnedCreeps[handle]
	
	self.SpawnedCreeps[tonumber(handle)] = nil
	for k, v in pairs(self.SpawnedCreeps) do
		print(k,v)
	end
	local tLength = Containers.TableLength(self.SpawnedCreeps)
	print("Tlength on throne touch:", tLength)

	if Wave:IsBoss() or Wave:IsRoundCleared() then
		Wave:UpdateWaveData()
		local data = {state = "BUILD"}
		FireGameEvent("round_end", data)
	end
end

function Wave:IsFinal()
	if self.RoundNumber == MAX_ROUND then
		self.IsEnd = true
		return true
	else
		return false
	end
end

function Wave:SpawnDamageTest()

	local waveData = Wave:LoadWaveData()
 	self.FinalBoss = CreateUnitByName(waveData.unitName, self.SpawnPosition, false, nil, nil, DOTA_TEAM_BADGUYS)

	Grid:MoveUnit(self.FinalBoss)
	Wave:AddCreepProperties(self.FinalBoss, waveData)
	self.FinalBoss:AddAbility("gem_collision_movement"):SetLevel(1)
	
	CustomGameEventManager:Send_ServerToAllClients( "final_boss", {health = self.FinalBoss:GetHealth(), name = self.FinalBoss:GetUnitName()} )

end