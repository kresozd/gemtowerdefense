function AbilityAdd(keys)
	local gem = keys.Gem
	local chance = Random.TowerTypeChance[gem]
	chance = chance + 1
	print("Success of "..gem.." Ability",  chance)
end

function AbilityHealThrone(keys)
	local healVal = RandomInt(3,8)
	Throne:HealThrone(healVal)
	print("Success of Healing Throne")
end