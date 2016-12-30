if Builder == nil then
	Builder = class({})
	
end



function Builder:Init()


	function RemoveHeroAbilities(caster)

		caster:FindAbilityByName("gem_build_tower"):SetLevel(0)
		caster:FindAbilityByName("gem_remove_tower"):SetLevel(0)

	end

	function AddTowerConfirmAbility(playerID)

    	for key, tower in pairs(self.RoundTowers[playerID]) do 

			tower:AddAbility("gem_pick_tower"):SetLevel(1)
        
    	end

	end

	function AddTowerDowngradeAbility(playerID)

		for key, tower in pairs(self.RoundTowers[playerID]) do

			if tonumber(tower.Level) == 1 then

			elseif tonumber(tower.Level) >= 2 then

				tower:AddAbility("gem_downgrade_tower"):SetLevel(1)

			end

		end

	end

	function HasBuilderPlaced(playerID)

		if Builder:TableLength(self.RoundTowers[playerID]) == 5 then

			return true

		else

			return false

		end

	end

	function AllPicked()

		if self.PickCount == PlayerResource:GetTeamPlayerCount() then
			
			return true

		else

			return false

		end


	end

	function CheckIfMergeable(playerID)



    	for key, tower in pairs(self.RoundTowers[playerID]) do
    		local mergeTest =	{false,false,false}
        	local towerName = tower:GetUnitName()

        	local pairsTest = 0
        	for i, towerPair in pairs(self.RoundTowers[playerID]) do
        		local towerNameTest = towerPair:GetUnitName()       		
        		if towerName == towerNameTest then
        			pairsTest=pairsTest+1
        		end
        	end

        	if pairsTest>1 and not tower:FindAbilityByName("gem_oneShotUpgrade") then
				tower:AddAbility("gem_oneShotUpgrade"):SetLevel(1)
			end
			if pairsTest>3 and not tower:FindAbilityByName("gem_oneShotUpgrade_2") then
				tower:AddAbility("gem_oneShotUpgrade_2"):SetLevel(1)
			end        		

			print("Tower name when checking for merge:", towerName)
        	local mergesInto =  towersKV[tostring(towerName)]["MergesInto"]


        	for k, v in pairs(mergesInto) do

            	print("Key:", k, "value: ", v)

            	local checkTower = towersKV[tostring(v)]["Requirements"]


            	for i, j in pairs(self.RoundTowers[playerID]) do

                	local fullTower = j:GetUnitName()
                	
                    	if fullTower==checkTower["1"]  then

	                    	mergeTest[1]=true
	                    	print("True for:", fullTower)

                    	elseif fullTower==checkTower["2"] then

	                    	mergeTest[2]=true
	                    	print("True for:", fullTower)

                    	elseif fullTower==checkTower["3"] then

	                    	mergeTest[3]=true
	                    	print("True for:", fullTower)

                		else

                    	print("Is not a part of this merging")

                		end
            	end
				print("Requirement 1 ", mergeTest[1])
		    	print("Requirement 2 ", mergeTest[2])
		    	print("Requirement 3 ", mergeTest[3])
		    	if mergeTest[1] and mergeTest[2] and mergeTest[3] then

                	tower.MergesInto = tostring(v)
					table.insert(self.TowerMergeable[playerID], tower)

		    	end
        	end
		end

	end

	
	function AddTowerMergeAbility(playerID)

		for key, value in pairs(self.TowerMergeable[playerID]) do

			print("Merge value in Builder:AddMergeAbility:", value.MergesInto)

			local mergeName = value.MergesInto

			if value then

				print("Tower name:", value:GetUnitName())
				if value:FindAbilityByName("gem_merge_tower") then
					value:AddAbility("gem_merge_tower_2"):SetLevel(1)
					local ModMaster = CreateItem("item_modifier_master", nil, nil) 
				--	ModMaster:ApplyDataDrivenModifier(value, value, "modifier_"..tostring(mergeName),nil)

				else
					value:AddAbility("gem_merge_tower"):SetLevel(1)
					local ModMaster2 = CreateItem("item_modifier_master", nil, nil) 
				--	ModMaster2:ApplyDataDrivenModifier(value, value, "modifier_"..tostring(mergeName),nil)
				end
			else

				print("No towers to add!")
			end
		end
	end


	self.PlayerCount = 0
	self.RoundTowers =
	 {
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {}
	 } 

	self.PickCount = 0
	self.GlobalTowers = {}
	self.GlobalMergeable = {} 
	self.DummyTowers = {} 
	self.TowerMergeable = 
	{
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {}
	}

end

function Builder:SetPlayerCount(count)

	self.PlayerCount = count

end

function Builder:IncrementPlayerCount()

	self.PlayerCount = self.PlayerCount + 1

end

function Builder:CreateTower(playerID, owner, position, caster)

	CustomNetTables:SetTableValue( "game_state", "current_round", { value = Rounds:GetRoundNumber() } )

	local generatedName = tostring(Random:GenerateWardName())	
	local generatedLevel = tostring(Random:GenerateWardLevel())
	local mergedName = tostring(generatedName..generatedLevel)

    local tower = CreateUnitByName(mergedName, position, false, nil, nil, DOTA_TEAM_GOODGUYS)
	local eHandle = tower:GetEntityHandle()

	tower:SetOwner(owner)
    tower:SetControllableByPlayer(playerID, true)
	
	tower.Level = generatedLevel
	tower.Name = mergedName
	
	self.RoundTowers[playerID][eHandle] = tower
	
	if HasBuilderPlaced(playerID) then

		RemoveHeroAbilities(caster)
		AddTowerConfirmAbility(playerID)
		AddTowerDowngradeAbility(playerID)

		CheckIfMergeable(playerID)
		AddTowerMergeAbility(playerID)

	end
	
end

function Builder:RemoveTower(caster, target, position)
	
	if target:GetUnitName() == "gem_dummy" then
	
		target:Destroy()
		
		Grid:FreeNavigationSquare(position, "odd")
		Grid:FindPath()
		
	else

	end

end

function Builder:ConfirmTower(caster, owner, playerID)

	self.PickCount = self.PickCount + 1

	local entityHandle = caster:GetEntityHandle()
	local entityIndex = caster:GetEntityIndex()
	local entityName = caster:GetUnitName()

	for key, value in pairs(self.RoundTowers[playerID]) do

		if entityIndex == value:GetEntityIndex() then

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName(entityName, position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			value:Destroy()
			
			tower:SetControllableByPlayer(playerID, true)
			tower:SetOwner(owner)
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			self.GlobalTowers[eHandle] = tower


		else

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			self.DummyTowers[eHandle] = tower

			tower:SetAbsOrigin(CallibrateTreePosition(position))

			tower:SetRenderColor(103, 135, 35)
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)

			value:Destroy()

			Builder:CallibrateTreePosition(position)
		end

	end

	for key, value in pairs(self.RoundTowers[playerID]) do

		self.RoundTowers[playerID][key] = nil

	end


	for key, value in pairs(self.TowerMergeable[playerID]) do

		self.TowerMergeable[playerID][key] = nil

	end

	if self.PickCount >= self.PlayerCount then

		Builder:WaveCheckIfMergeable()
		self.PickCount = 0
		Rounds:WaveInit()

	end
end

function Builder:OneShotUpgradeTower(caster, owner, playerID)

	self.PickCount = self.PickCount + 1

	local entityHandle = caster:GetEntityHandle()
	local entityIndex = caster:GetEntityIndex()
	local towerCurrentLevel = caster.Level
	local entityName = caster.Name
	local towerNewLevel = towerCurrentLevel+1
	local entityNewName = entityName:sub(1, -2)..tostring(towerNewLevel)

	for key, value in pairs(self.RoundTowers[playerID]) do

		if entityIndex == value:GetEntityIndex() then

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName(entityNewName, position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			value:Destroy()
			
			tower:SetControllableByPlayer(playerID, true)
			tower:SetOwner(owner)
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			self.GlobalTowers[eHandle] = tower


		else

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			self.DummyTowers[eHandle] = tower

			tower:SetAbsOrigin(CallibrateTreePosition(position))

			tower:SetRenderColor(103, 135, 35)
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)

			value:Destroy()

			Builder:CallibrateTreePosition(position)
		end

	end

	for key, value in pairs(self.RoundTowers[playerID]) do

		self.RoundTowers[playerID][key] = nil

	end


	for key, value in pairs(self.TowerMergeable[playerID]) do

		self.TowerMergeable[playerID][key] = nil

	end

	if self.PickCount >= self.PlayerCount then

		self.PickCount = 0
		Rounds:WaveInit()

	end
end

function Builder:OneShotUpgradeTower_2(caster, owner, playerID)

	self.PickCount = self.PickCount + 1

	local entityHandle = caster:GetEntityHandle()
	local entityIndex = caster:GetEntityIndex()
	local towerCurrentLevel = caster.Level
	local entityName = caster.Name
	local towerNewLevel = towerCurrentLevel+2
	local entityNewName = entityName:sub(1, -2)..tostring(towerNewLevel)
	print(entityNewName)
	for key, value in pairs(self.RoundTowers[playerID]) do

		if entityIndex == value:GetEntityIndex() then

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName(entityNewName, position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			value:Destroy()
			
			tower:SetControllableByPlayer(playerID, true)
			tower:SetOwner(owner)
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			self.GlobalTowers[eHandle] = tower


		else

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			self.DummyTowers[eHandle] = tower

			tower:SetAbsOrigin(CallibrateTreePosition(position))

			tower:SetRenderColor(103, 135, 35)
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)

			value:Destroy()

			Builder:CallibrateTreePosition(position)
		end

	end

	for key, value in pairs(self.RoundTowers[playerID]) do

		self.RoundTowers[playerID][key] = nil

	end


	for key, value in pairs(self.TowerMergeable[playerID]) do

		self.TowerMergeable[playerID][key] = nil

	end

	if self.PickCount >= self.PlayerCount then

		self.PickCount = 0
		Rounds:WaveInit()

	end
end


function Builder:DowngradeTower(caster, owner, playerID)

	self.PickCount = self.PickCount + 1

	local entityHandle = caster:GetEntityHandle()
	local entityIndex = caster:GetEntityIndex()
	local towerCurrentLevel = caster.Level
	local entityName = caster.Name
	local towerNewLevel = Random:Downgrade(tonumber(towerCurrentLevel))
	local entityNewName = entityName:sub(1, -2)..tostring(towerNewLevel)
	print(entityNewName)
	for key, value in pairs(self.RoundTowers[playerID]) do

		if entityIndex == value:GetEntityIndex() then


			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName(entityNewName, position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle=tower:GetEntityHandle() 			
			value:Destroy()

			tower:SetControllableByPlayer(playerID, true)
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)

			self.GlobalTowers[eHandle] = tower


		else

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)

			value:Destroy()

			tower:SetRenderColor(103, 135, 35)
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			tower:SetAbsOrigin(CallibrateTreePosition(position))

			Builder:CallibrateTreePosition(position)

		end

	end
	
	for key, value in pairs(self.RoundTowers[playerID]) do

		self.RoundTowers[playerID][key] = nil

	end


	for key, value in pairs(self.TowerMergeable[playerID]) do

		self.TowerMergeable[playerID][key] = nil

	end
	
	if self.PickCount >= self.PlayerCount then

		self.PickCount = 0
		Rounds:WaveInit()

	end

end

function Builder:CallibrateTreePosition(Vector)

	Vector.z = Vector.z - 90

	return Vector

end

function Builder:CheckTowerCount(caster, playerID)

	print("Table count: ", Builder:TableLength(self.RoundTowers[playerID]))

    if Builder:TableLength(self.RoundTowers[playerID]) == 5 then

		caster:AddSpeechBubble(1, "Select a Gem!", 1,0, -15)
		
		Builder:RemoveBuildAbility(caster)
		Builder:AbilityAddPick(playerID, table1)
		Builder:AddDowngradeAbility(playerID, table1)

		Builder:CheckIfMergeable(playerID)
		Builder:AddMergeAbility(playerID)

		
		
	end

end

function Builder:CreateMergeableTower(playerID, caster, owner)

	self.PickCount = self.PickCount + 1

	local entityIndex = caster:GetEntityIndex()

	for key, value in pairs(self.TowerMergeable[playerID]) do

		if entityIndex == value:GetEntityIndex() then

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName(value.MergesInto, position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			tower:SetControllableByPlayer(playerID, true)
			tower:SetOwner(owner)
			tower:SetHullRadius(TOWER_HULL_RADIUS)

			self.GlobalTowers[eHandle] = tower

			value:Destroy()

		else

			local position = value:GetAbsOrigin()
			self.GlobalTowers[value:GetEntityHandle()] = nil

			local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			self.DummyTowers[eHandle] = tower

			value:Destroy()

			tower:SetRenderColor(103, 135, 35)
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			tower:SetAbsOrigin(CallibrateTreePosition(position))

			Builder:CallibrateTreePosition(position)

		end

	end

	for key, value in pairs(self.RoundTowers[playerID]) do

		if not value:IsNull() then

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()

			self.DummyTowers[eHandle] = tower

			tower:SetAbsOrigin(CallibrateTreePosition(position))

			tower:SetRenderColor(103, 135, 35)
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)

			value:Destroy()

			Builder:CallibrateTreePosition(position)
		end

	end
	
	for key, value in pairs(self.TowerMergeable[playerID]) do

		self.TowerMergeable[playerID][key] = nil

	end

	for key, value in pairs(self.RoundTowers[playerID]) do

		self.RoundTowers[playerID][key] = nil
	end

	print(Rounds.State)
	if self.PickCount == self.PlayerCount and Rounds.State ~= "WAVE" then
	print("Start Wave")
		self.PickCount = 0
		Rounds:WaveInit()

	end

end


function Builder:AddHeroAbilitiesOnRound()
	
	for i = 0, self.PlayerCount - 1 do

		local Player = PlayerResource:GetPlayer(i)
		local Hero = Player:GetAssignedHero()
	
		Hero:FindAbilityByName("gem_build_tower"):SetLevel(1)
		Hero:FindAbilityByName("gem_remove_tower"):SetLevel(1)

	end

end

function Builder:AddAbilitiesOnStart(hero)

    hero:AddAbility("gem_build_tower"):SetLevel(1)
	hero:FindAbilityByName("gem_build_tower"):SetAbilityIndex(0)
	hero:AddAbility("gem_remove_tower"):SetLevel(1)
	hero:FindAbilityByName("gem_remove_tower"):SetAbilityIndex(1)

end

function Builder:RemoveBuildAbility(caster)

	caster:FindAbilityByName("gem_build_tower"):SetLevel(0)
	caster:FindAbilityByName("gem_remove_tower"):SetLevel(0)
	
end


function Builder:TableLength(table)
  local count = 0
  for _ in pairs(table) do count = count + 1 end
  return count
end


function Builder:WaveCheckIfMergeable()


	for key, tower in pairs(self.GlobalTowers) do
		local mergeTest =	{false,false,false}

    	local towerName = tower:GetUnitName()
		print("Tower name when checking for merge:", towerName)
    	local mergesInto =  towersKV[tostring(towerName)]["MergesInto"]


    	for k, v in pairs(mergesInto) do

        	print("Key:", k, "value: ", v)

        	local checkTower = towersKV[tostring(v)]["Requirements"]


        	for i, j in pairs(self.GlobalTowers) do

            	local fullTower = j:GetUnitName()
            	
                	if fullTower==checkTower["1"]  then

                    	mergeTest[1]=true
                    	print("True for:", fullTower)

                	elseif fullTower==checkTower["2"] then

                    	mergeTest[2]=true
                    	print("True for:", fullTower)

                	elseif fullTower==checkTower["3"] then

                    	mergeTest[3]=true
                    	print("True for:", fullTower)

            		else

                	print("Is not a part of this merging")

            		end
        	end
			print("Requirement 1 ", mergeTest[1])
	    	print("Requirement 2 ", mergeTest[2])
	    	print("Requirement 3 ", mergeTest[3])
	    	if mergeTest[1] and mergeTest[2] and mergeTest[3] then

            	tower.MergesInto = tostring(v)
				table.insert(self.GlobalMergeable, tower)

	    	end
    	end
	end

end


function Builder:WaveAddTowerMergeAbility()

	for key, value in pairs(self.GlobalMergeable) do

		print("Merge value in Builder:WaveAddTowerMergeAbility:", value.MergesInto)

		local mergeName = value.MergesInto

		if value then

			value:AddAbility("gem_merge_"..tostring(mergeName))

		end

	end


end


--[[
			print("Tower name:", value:GetUnitName())
			if value:FindAbilityByName("gem_merge_tower") then
				value:AddAbility("gem_merge_tower_2"):SetLevel(1)
				local ModMaster = CreateItem("item_modifier_master", nil, nil) 
				ModMaster:ApplyDataDrivenModifier(value, value, "modifier_"..tostring(mergeName),{duration=10})

			else
				value:AddAbility("gem_merge_tower"):SetLevel(1)
				local ModMaster2 = CreateItem("item_modifier_master", nil, nil) 
				ModMaster2:ApplyDataDrivenModifier(value, value, "modifier_"..tostring(mergeName),{duration=10})
			end
		else

			print("No towers to add!")
		end
	end
]]--