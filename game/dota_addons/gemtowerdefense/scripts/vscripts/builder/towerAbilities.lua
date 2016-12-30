
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

	local caster = keys.caster
	local owner = caster:GetOwner()
	local playerID = owner:GetPlayerID()

	Builder:CreateMergeableTower(playerID, caster, owner)

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