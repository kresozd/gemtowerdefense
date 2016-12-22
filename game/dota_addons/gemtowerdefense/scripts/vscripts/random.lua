
if Random == nil then
	Random = class({})
	
end

--local unitName 			= wavesKV[tostring(self.RoundNumber)]["Creep"]

function Random:Init()

	self.XPLevel 		= 1


end

function Random:SetXPLevel(level)

	self.XPLevel = level

end

function Random:GetXPLevel()

	return self.XPLevel

end

--ToRemake

--[[
function Random:Downgrade(towerLevel)

	local randomValue = RandomInt(1, 100)
	local newLevel

	if towerLevel == 2 then

		newLevel = 1

	elseif towerLevel == 3 then

		if randomValue <= 60 then

			newLevel = 2

		else

			newLevel = 1

		end

	elseif towerLevel == 4 then

		if randomValue <= 50 then

			newLevel = 3

		elseif randomValue > 50 and randomValue <= 80 then

			newLevel = 2

		else

			newLevel = 1

		end

	elseif towerLevel == 5 then

		if randomValue <= 50 then

			newLevel = 4
		
		elseif randomValue > 50 and randomValue <= 75 then

			newLevel = 3


		elseif randomValue > 75 and randomValue <= 90 then

			newLevel = 2

		else

			newLevel = 1

		end

	end

	print("Returning new level...", newLevel)

	return newLevel




end
]]--
function Random:GenerateWardLevel()

	local levelTable = randomKV.Chances

	if self.XPLevel == 1 then

		local level = 1
		return level

	elseif self.XPLevel == 2 then

		local value = RandomInt(1,100)

		if value <= levelTable[self.XPLevel]["1"] then

			local level = 1
			return level

		else
			
			local level = 2
			return level
		
		end
	
	elseif self.XPLevel == 3 then

		local value = RandomInt(1, 100)

		if value <= levelTable[self.XPLevel]["1"] then

			local level = 1
			return level

		elseif value >= levelTable[self.XPLevel]["2"] and value <= levelTable[self.XPLevel]["3"] then

			local level = 2
			return level

		else

			local level = 3
			return level

		end

	

	elseif self.XPLevel == 4 then

		local value = RandomInt(1, 100)

		if value <= levelTable[self.XPLevel]["1"] then

			local level = 1
			return level

		elseif value >= levelTable[self.XPLevel]["2"] and value <= levelTable[self.XPLevel]["3"] then

			local level = 2
			return level

		elseif value >= levelTable[self.XPLevel]["3"] and value <= levelTable[self.XPLevel]["4"] then

			local level = 3
			return level

		else

			local level = 4
			return level

		end



	elseif self.XPLevel == 5 then

		local value = RandomInt(1, 100)

		if value <= levelTable[self.XPLevel]["1"] then

			local level = 1
			return level

		elseif value >= levelTable[self.XPLevel]["2"] and value <= levelTable[self.XPLevel]["3"] then

			local level = 2
			return level

		elseif value >= levelTable[self.XPLevel]["3"] and value <= levelTable[self.XPLevel]["4"] then

			local level = 3
			return level

		elseif value >= levelTable[self.XPLevel]["4"] and value <= levelTable[self.XPLevel]["5"] then

			local level = 4
			return level

		else

			local level = 5
			return level

		end

	end


	

end


function ShitLevelTest()

	local level = 1

	return level

end

function Random:GenerateWardName()

	local nameTable = {"gem_d", "gem_s", "gem_t"}
	local generatedTower = tostring(nameTable[RandomInt(1, 3)])

	return generatedTower

end


