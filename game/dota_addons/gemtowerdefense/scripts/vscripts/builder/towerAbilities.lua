
function AbilityConfirmTower(keys)

	print("Ability confirm tower called!")

	local caster = keys.caster
	local owner =  caster:GetOwner()
	local playerID = owner:GetPlayerID()

	
	Builder:ConfirmTower(caster, owner, playerID)

end


function AbilityDowngradeTower(keys)

	local caster = keys.caster
	local owner = caster:GetOwner()
	local playerID = owner:GetPlayerID()

	Builder:DowngradeTower(caster, owner, playerID)
	
end

function AbilityMergeTower(keys)
	print("Merging in "..Rounds.State)
	local caster = keys.caster
	local owner = caster:GetOwner()
	local playerID = owner:GetPlayerID()
	if Rounds.State == "BUILD" then
		Builder:CreateMergeableTower(playerID, caster, owner)
	else
		Builder:WaveCreateMergedTower(playerID, caster, owner)
	end

end

function AbilityMergeTower_2(keys)

	local caster = keys.caster
	local owner = caster:GetOwner()
	local playerID = owner:GetPlayerID()
	if Rounds.State == "BUILD" then
		Builder:CreateMergeableTower_2(playerID, caster, owner)
	else
		Builder:WaveCreateMergedTower_2(playerID, caster, owner)
	end

end

function CallibrateTreePosition(Vector)

	Vector.z = Vector.z - 90

	return Vector

end

function AbilityOneShotUpgradeTower(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local playerID = owner:GetPlayerID()

	
	Builder:OneShotUpgradeTower(caster, owner, playerID)
end

function AbilityOneShotUpgradeTower_2(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local playerID = owner:GetPlayerID()

	
	Builder:OneShotUpgradeTower_2(caster, owner, playerID)
end