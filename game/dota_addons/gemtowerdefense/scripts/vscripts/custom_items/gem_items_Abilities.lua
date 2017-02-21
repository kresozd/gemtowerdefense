
function AbilityAddamethyst(keys)
	Random.TowerTypeChance["Amethyst"]=Random.TowerTypeChance["Amethyst"]+1
	print("Success of Amethyst Ability",Random.TowerTypeChance["Amethyst"])
end
function AbilityAdddiamond(keys)
	Random.TowerTypeChance["Diamond"]=Random.TowerTypeChance["Diamond"]+1
	print("Success of Diamond Ability",Random.TowerTypeChance["Diamond"])
end
function AbilityAddemerald(keys)
	Random.TowerTypeChance["Emerald"]=Random.TowerTypeChance["Emerald"]+1
	print("Success of Emerald Ability",Random.TowerTypeChance["Emerald"])
end
function AbilityAddopal(keys)
	Random.TowerTypeChance["Opal"]=Random.TowerTypeChance["Opal"]+1
	print("Success of Opal Ability",Random.TowerTypeChance["Opal"])
end
function AbilityAddaquamarine(keys)
	Random.TowerTypeChance["Aquamarine"]=Random.TowerTypeChance["Aquamarine"]+1
	print("Success of Aquamarine Ability",Random.TowerTypeChance["Aquamarine"])
end
function AbilityAddruby(keys)
	Random.TowerTypeChance["Ruby"]=Random.TowerTypeChance["Ruby"]+1
	print("Success of Ruby Ability",Random.TowerTypeChance["Ruby"])
end
function AbilityAddsapphire(keys)
	Random.TowerTypeChance["Sapphire"]=Random.TowerTypeChance["Sapphire"]+1
	print("Success of Sapphire Ability",Random.TowerTypeChance["Sapphire"])
end
function AbilityAddtopaz(keys)
	Random.TowerTypeChance["Topaz"]=Random.TowerTypeChance["Topaz"]+1
	print("Success of Topaz Ability",Random.TowerTypeChance["Topaz"])
end
function AbilityHealThrone(keys)
	local healVal = RandomInt(3,8)
	Throne:HealThrone(healVal)
	print("Success of Healing Throne")
end