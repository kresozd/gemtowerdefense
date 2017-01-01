
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

function Rounds:SpawnUnits()

	self.State = "WAVE"

	local unitDamage 	= wavesKV[tostring(self.RoundNumber)]["Damage"]
	local unitName 		= wavesKV[tostring(self.RoundNumber)]["Creep"]
	local unitSpeed 	= wavesKV[tostring(self.RoundNumber)]["MoveSpeed"]
	local unitXPBounty 	= wavesKV[tostring(self.RoundNumber)]["XPBounty"]
	local unitGoldBounty = wavesKV[tostring(self.RoundNumber)]["GoldBounty"]
	local unitType 		= wavesKV[tostring(self.RoundNumber)]["Type"]
	local unitIsBoss 	= wavesKV[tostring(self.RoundNumber)]["Boss"]

	Timers:CreateTimer( function()
		
		self.AmountSpawned = self.AmountSpawned + 1
       
		local creep = CreateUnitByName(unitName, self.SpawnPosition, false, nil, nil, DOTA_TEAM_BADGUYS)
		local eHandle = creep:GetEntityHandle()

		self.SpawnedCreeps[eHandle] = creep

		creep.Damage 			= unitDamage
		creep.Name 				= unitName
		creep.XPBounty			= unitXPBounty
		creep.GoldBounty 		= unitGoldBounty
		creep.Type 				= unitType

		creep:SetBaseDamageMin(unitDamage)
		creep:SetBaseDamageMax(unitDamage)
		creep:SetBaseMoveSpeed(unitSpeed)
		creep:SetMaximumGoldBounty(unitGoldBounty)
		creep:SetDeathXP(unitXPBounty)
		creep:SetBaseMaxHealth(50)

		creep:SetHullRadius(0)
			
		creep:AddAbility("gem_collision_movement"):SetLevel(1)
			
		Grid:MoveUnit(creep, creep.Type)

		if self.AmountSpawned == 10 then

			self.AmountSpawned = 0
        	return nil
				
		else

			return self.DelayBetweenSpawn

		end

    end)


end

function Rounds:SpawnBoss()

	self.State = "WAVE"

	local unitDamage 	= wavesKV[tostring(self.RoundNumber)]["Damage"]
	local unitName 		= wavesKV[tostring(self.RoundNumber)]["Creep"]
	local unitSpeed 	= wavesKV[tostring(self.RoundNumber)]["MoveSpeed"]
	local unitXPBounty 	= wavesKV[tostring(self.RoundNumber)]["XPBounty"]
	local unitGoldBounty = wavesKV[tostring(self.RoundNumber)]["GoldBounty"]
	local unitType 		= wavesKV[tostring(self.RoundNumber)]["Type"]
	local unitIsBoss 	= wavesKV[tostring(self.RoundNumber)]["Boss"]

	local boss = CreateUnitByName(unitName, self.SpawnPosition, false, nil, nil, DOTA_TEAM_BADGUYS)
	local eHandle = boss:GetEntityHandle()

	self.SpawnedCreeps[eHandle] = boss

		boss.Damage 			= unitDamage
		boss.Name 				= unitName
		boss.XPBounty			= unitXPBounty
		boss.Speed 				= unitSpeed * 2
		boss.GoldBounty 		= unitGoldBounty
		boss.Type 				= unitType

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
			self.TotalLeaked = self.TotalLeaked + 1
			self.AmountKilled = self.AmountKilled + 1

			unit:Destroy()

			CustomNetTables:SetTableValue( "game_state", "gem_castle_health", { value = tostring(self.BaseHealth) } )

	
			if Rounds:IsBoss() then

				self.State = "BUILD"
				self.RoundNumber = self.RoundNumber + 1
				Rounds:InitBuild()

			else

				local eventData = {"a"}
				
				if self.AmountKilled == 10 then


				self.AmountKilled = 0
				self.State = "BUILD"
				self.RoundNumber = self.RoundNumber + 1
				Rounds:InitBuild()
				end
			end

		else

			--Hero stepped in

		end
	

end


function Rounds:OnEntityKilled(keys)

	local unit = EntIndexToHScript(keys.entindex_killed)
	local eHandle = unit:GetEntityHandle()

	for i = 0, PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) - 1 do

		local player = PlayerResource:GetPlayer(i)
		local hero = player:GetAssignedHero()
		local playerID = player:GetPlayerID()

		hero:AddExperience(unit:GetDeathXP(), 0, false, false)
		PlayerResource:ModifyGold(i, unit:GetMaximumGoldBounty(), false, 0)
		

	end

	self.AmountKilled = self.AmountKilled + 1

	self.SpawnedCreeps[eHandle] = nil

	if Rounds:IsBoss() then

		Rounds:UpdateWaveData()
		FireGameEvent("round_end", {playerID = "0"})

	else

		if Rounds:IsRoundCleared() then

			Rounds:UpdateWaveData()
			FireGameEvent("round_end", {state = "BUILD"})

		end
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
