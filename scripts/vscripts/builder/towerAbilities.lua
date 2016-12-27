
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

	Builder:DowngradeTower(playerID, owner, caster)
	
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
