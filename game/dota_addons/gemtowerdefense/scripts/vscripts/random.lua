
if Random == nil then
	Random = class({})
	
end

--local unitName 			= wavesKV[tostring(self.RoundNumber)]["Creep"]

function Random:Init()

	self.TowerXPLevel 		= 1
	self.TowerTypeChance =
	{
		["Amethyst"]	= 0,
		["Diamond"]		= 0,
		["Emerald"]		= 0,
		["Opal"]		= 0,
		["Aquamarine"]	= 0,
		["Ruby"]		= 0,
		["Sapphire"]	= 0,
		["Topaz"]		= 0	
	}


end

function Random:SetTowerXPLevel(level)

	self.TowerXPLevel = level

end

function Random:GetXPLevel()

	return self.TowerXPLevel

end

--ToRemake
--[[
  "DowngradeChances"
    {
        "2"
        {
            "1" "100"

        }
        "3"
        {
            "1" "40"
            "2" "100"

        }
        "4"
        {
            "1" "20"
            "2" "50"
            "3" "100"

        }
        "5"
        {
            "1" "15"
            "2" "30"
            "3" "50"
            "4" "100"
        }	
]]--
function Random:SpawnElite()

	local value = RandomInt(1,50)

		if value == 1 then

			return true

		else

			return false

		end

end

function Random:Downgrade(level)

	local downgradeTable = randomKV.DowngradeChances
	local value = RandomInt(1,100)

	print("Random Downgrade Called!")

	if level == 2 then

		print("Im here!")

		local nLevel = 1
		return nLevel

	elseif level == 3 then

		if value <= downgradeTable[tostring(level)]["1"] then

			local nLevel = 2
			return nLevel

		else

			local nLevel = 1
			return nLevel

		end

	elseif level == 4 then

		if value <= downgradeTable[tostring(level)]["1"] then

			local nLevel = 1
			return nLevel

		elseif value > downgradeTable[tostring(level)]["1"] and value <= downgradeTable[tostring(level)]["2"] then

			local nLevel = 2
			return nLevel

		else

			nLevel = 3
			return nLevel

		end

	elseif level == 5 then

		if value <= downgradeTable[tostring(level)]["1"] then

			newLevel = 1
		
		elseif value > downgradeTable[tostring(level)]["1"] and value <= downgradeTable[tostring(level)]["2"] then

			newLevel = 2


		elseif value > downgradeTable[tostring(level)]["2"] and randomValue <= downgradeTable[tostring(level)]["3"] then

			newLevel = 3

		else

			newLevel = 4

		end

	end
end

function Random:GenerateWardLevel()

	local levelTable = randomKV.Chances

	if self.TowerXPLevel == 1 then

		local level = 1
		return level

	elseif self.TowerXPLevel == 2 then

		local value = RandomInt(1,100)

		if value <= levelTable[tostring(self.TowerXPLevel)]["1"] then

			local level = 1
			return level

		else
			
			local level = 2
			return level
		
		end
	
	elseif self.TowerXPLevel == 3 then

		local value = RandomInt(1, 100)

		if value <= levelTable[tostring(self.TowerXPLevel)]["1"] then

			local level = 1
			return level

		elseif value >= levelTable[tostring(self.TowerXPLevel)]["2"] and value <= levelTable[tostring(self.TowerXPLevel)]["3"] then

			local level = 2
			return level

		else

			local level = 3
			return level

		end

	

	elseif self.TowerXPLevel == 4 then

		local value = RandomInt(1, 100)

		if value <= levelTable[tostring(self.TowerXPLevel)]["1"] then

			local level = 1
			return level

		elseif value >= levelTable[tostring(self.TowerXPLevel)]["2"] and value <= levelTable[tostring(self.TowerXPLevel)]["3"] then

			local level = 2
			return level

		elseif value >= levelTable[tostring(self.TowerXPLevel)]["3"] and value <= levelTable[tostring(self.TowerXPLevel)]["4"] then

			local level = 3
			return level

		else

			local level = 4
			return level

		end



	elseif self.TowerXPLevel == 5 then

		local value = RandomInt(1, 100)

		if value <= levelTable[tostring(self.TowerXPLevel)]["1"] then

			local level = 1
			return level

		elseif value >= levelTable[tostring(self.TowerXPLevel)]["2"] and value <= levelTable[tostring(self.TowerXPLevel)]["3"] then

			local level = 2
			return level

		elseif value >= levelTable[tostring(self.TowerXPLevel)]["3"] and value <= levelTable[tostring(self.TowerXPLevel)]["4"] then

			local level = 3
			return level

		elseif value >= levelTable[tostring(self.TowerXPLevel)]["4"] and value <= levelTable[tostring(self.TowerXPLevel)]["5"] then

			local level = 4
			return level

		else

			local level = 5
			return level

		end

	end
end


function Random:GenerateWardName()

	local nameTable = randomKV.Base
	local nameRand = RandomFloat(0,100)
	print(nameRand)
	local maxChance = 0
	local maxType = "Amethyst"
	for key, value in pairs(self.TowerTypeChance) do
		--print(key, value)
		if value > maxChance then
			maxChance = value
			maxType = key
		end
	end
	local chosenChance = 0.0431*maxChance*maxChance*maxChance-1.461*maxChance*maxChance+18.029*maxChance+12.5
	local otherChance = (100-chosenChance)/7
	local bound1 = 0
	local bound2 = 0
	local nameOut = ""
	for key, value in pairs(self.TowerTypeChance) do

		if maxType == key then 
			bound1=bound2
			bound2=bound1+chosenChance
		else
			bound1=bound2
			bound2=bound1+otherChance
		end

		if nameRand>=bound1 and nameRand<=bound2 then
			nameOut = key
		end

	end

	Random:ResetTowerTypeChance()
	local name = nameTable[nameOut]
	--local name = nameTable[tostring(RandomInt(3, 5))]
	return name

end

function Random:ResetTowerTypeChance()
	self.TowerTypeChance =
	{
		["Amethyst"]	= 0,
		["Diamond"]		= 0,
		["Emerald"]		= 0,
		["Opal"]		= 0,
		["Aquamarine"]	= 0,
		["Ruby"]		= 0,
		["Sapphire"]	= 0,
		["Topaz"]		= 0		
	}
end
