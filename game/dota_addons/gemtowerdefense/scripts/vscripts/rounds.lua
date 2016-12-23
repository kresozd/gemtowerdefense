
if Rounds == nil then
	Rounds = class({})
	
end


function Rounds:Init()

	self.State = "0"  	--0 Build Phase, 1 Wave Phase
    self.AmountKilled 	= 0
	self.AmountSpawned 	= 0
    self.SpawnedCreeps 	= {}
    self.RoundNumber 	= 1
    self.SpawnPosition 	= Entities:FindByName(nil, "enemy_spawn"):GetAbsOrigin()
	self.BaseHealth 	= 100

	self.TotalKilled 	= 0
	self.TotalLeaked 	= 0
	self.DelayBetweenSpawn = 1
	self.WaveData = wavesKV


end

function Rounds:WaveInit()


	Rounds:SpawnUnits()





end


function Rounds:SpawnUnits()

	local unitDamage 	= wavesKV[tostring(self.RoundNumber)]["Damage"]
	local unitName 		= wavesKV[tostring(self.RoundNumber)]["Creep"]
	local unitSpeed 	= wavesKV[tostring(self.RoundNumber)]["MoveSpeed"]
	
	local unitXPBounty 	= wavesKV[tostring(self.RoundNumber)]["XPBounty"]

	print("UnitName", unitName)
	print("UnitSpeed", unitSpeed)
	print("UnitDamage", unitDamage)


	Timers:CreateTimer( function()
		
		self.AmountSpawned = self.AmountSpawned + 1
       
		local creep = CreateUnitByName(unitName, self.SpawnPosition, false, nil, nil, DOTA_TEAM_BADGUYS)
		local eHandle = creep:GetEntityHandle()

		Rounds:InsertByHandle(eHandle, creep)
		
		creep.Damage 			= unitDamage
		creep.Name 				= unitName
		creep.XPBounty			= unitXPBounty
	

		--creep:SetBaseMoveSpeed(unitSpeed*SpeedDifficulty)

		creep:SetHullRadius(0)
			
		creep:AddAbility("gem_collision_movement"):SetLevel(1)
			
		Grid:MoveUnit(creep)

		if self.AmountSpawned == 10 then

			self.AmountSpawned = 0
        	return nil
				
		else

			return 1

		end

    end)

end



function Rounds:Spawn()

    Timers:CreateTimer( function()
		
		self.AmountSpawned = self.AmountSpawned + 1
       
		local creep = CreateUnitByName(unitName, self.SpawnPosition, false, nil, nil, DOTA_TEAM_BADGUYS)
		local eHandle = creep:GetEntityHandle()

		Rounds:InsertByHandle(eHandle, creep)
		


		creep:SetBaseMoveSpeed(unitSpeed*SpeedDifficulty)

		creep:SetHullRadius(0)
			
		creep:AddAbility("gem_collision_movement"):SetLevel(1)
			
		Grid:MoveUnit(creep)

		if self.AmountSpawned == 10 then

			self.AmountSpawned = 0
        	return nil
				
		else

			return 1

		end

    end)
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

	Rounds:AddHeroAbilitiesOnRound()

end


function Rounds:InsertByHandle(index, unit)

	self.SpawnedCreeps[index] = unit 

end

function Rounds:DeleteByHandle(index)

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


function Rounds:DecrementBaseHealth(value)

	self.BaseHealth = self.BaseHealth - value

end

function Rounds:IncrementTotalLeaked()

	self.TotalLeaked = self.TotalLeaked + 1


end

function Rounds:GetBaseHealth()

	return self.BaseHealth

end
