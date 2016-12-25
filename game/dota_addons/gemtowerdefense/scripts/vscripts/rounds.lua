
if Rounds == nil then
	Rounds = class({})
	
end


function Rounds:Init(keyvalue)

	self.Nocturnal = false
	self.State = "BUILD"  	--"BUILD" Build Phase, "WAVE" Wave Phase
    self.AmountKilled 	= 0
	self.AmountSpawned 	= 0
    self.SpawnedCreeps 	= {}
    self.RoundNumber 	= 1
    self.SpawnPosition 	= Entities:FindByName(nil, "enemy_spawn"):GetAbsOrigin()
	self.BaseHealth 	= 100
	self.BuildLevel = 1

	self.TotalKilled 	= 0
	self.TotalLeaked 	= 0
	self.DelayBetweenSpawn = 1
	self.Data 				= keyvalue

	

	

end


function Rounds:WaveInit()

	if Rounds:IsBoss() then

		Rounds:SpawnBoss()

	else

		Rounds:SpawnUnits()


	end

	

end

function Rounds:SpawnUnits()

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

		--AddCreepProperties(creep)

		Rounds:InsertByHandle(eHandle, creep)
	
		creep.Damage 			= unitDamage
		creep.Name 				= unitName
		creep.XPBounty			= unitXPBounty
		creep.Speed 			= unitSpeed * 2
		creep.GoldBounty 		= unitGoldBounty
		creep.Type 				= unitType
		--creep.IsBoss 			=

		creep:SetBaseMoveSpeed(creep.Speed)

		creep:SetHullRadius(0)
			
		creep:AddAbility("gem_collision_movement"):SetLevel(1)
			
		Grid:MoveUnit(creep, creep.Type)

		if self.AmountSpawned == 10 then

			self.AmountSpawned = 0
        	return nil
				
		else

			return 1

		end

    end)

end

function Rounds:SpawnBoss()

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

function Rounds:AddHeroAbilitiesOnRound()

	local Player = PlayerResource:GetPlayer(0)
	local Hero = Player:GetAssignedHero()
	Hero:AddAbility("gem_build_tower"):SetLevel(1)
	Hero:FindAbilityByName("gem_build_tower"):SetAbilityIndex(0)
	Hero:AddAbility("gem_remove_tower"):SetLevel(1)
	Hero:FindAbilityByName("gem_remove_tower"):SetAbilityIndex(1)
	print("Ability adding succeeded....")
	
end

function Rounds:RemoveBuildAbility(caster)

	caster:RemoveAbility("gem_build_tower")
	caster:RemoveAbility("gem_remove_tower")
	
end

function Rounds:AddBuildAbility(caster)
	
	caster:AddAbility("gem_build_tower"):SetLevel(1)
	caster:AddAbility("gem_remove_tower"):SetLevel(1)

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

		self.AmountKilled = 0
		return true

	else

		return false
	
	end


end

function Rounds:GetRoundNumber()

	return self.RoundNumber

end

function Rounds:GetAmountOfKilled()

	return self.AmountKilled

end

function Rounds:ResetAmountOfKilled()

	self.AmountKilled = 0

end

function Rounds:Build()

	print("Build called!")

	CustomNetTables:SetTableValue( "game_state", "current_round", { value = Rounds:GetRoundNumber() } )
	Rounds:AddHeroAbilitiesOnRound()

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
