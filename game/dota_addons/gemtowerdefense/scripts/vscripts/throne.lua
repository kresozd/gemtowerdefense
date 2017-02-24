
if Throne == nil then
	Throne = class({})
	
end


function Throne:Init()

	self.ThroneEntity = nil
    self.StatusHealth = 100
end

    
function Throne:GetThrone()
	return self.ThroneEntity
end

function Throne:IsDead()
	local locthrone = self.ThroneEntity
	if locthrone:GetHealth() <= 0 then
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	end
end

function Throne:OnTouch(trigger)
	
	local locthrone = self.ThroneEntity
	print("Throne entity", locthrone)
	local unit = trigger.activator
	local handle = unit:GetEntityHandle()
	
	if unit and string.match(unit:GetUnitName(), "gem_round") then

		if string.match(unit:GetUnitName(), "final") then
			GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
		else
			local data = 
			{	
			handle = tostring(handle)
			}
			FireGameEvent("throne_touch", data)

			locthrone:SetHealth(locthrone:GetHealth() - unit:GetBaseDamageMax())
			print("Throne HP on touch:", locthrone:GetBaseMaxHealth())
			CustomNetTables:SetTableValue( "game_state", "gem_castle_health", { value = locthrone:GetHealth() } )
			EmitGlobalSound("BodyImpact_Common.Heavy")
			Throne:IsDead()
			unit:Destroy()
		end

	else
		print("Hero stepped in Throne!")
	end
end

function Throne:HealThrone(health)
	local locthrone = self.ThroneEntity
	if locthrone:GetHealth()<100 then
		locthrone:SetHealth(math.min(100,locthrone:GetHealth() + health))
		CustomNetTables:SetTableValue( "game_state", "gem_castle_health", { value = locthrone:GetHealth() } )
	end
end
--[[
function Throne:SpawnEntity()
	local thronePosition = Vector(1792, -1792, 0)
	local locthroneEntity = CreateUnitByName("gem_throne", thronePosition, false, nil, nil, DOTA_TEAM_GOODGUYS)
	locthroneEntity:SetForwardVector(Vector(-1,0,0))
end
]]
--[[
function Throne:SetHealth(health)
    self.StatusHealth = health
	if self.StatusHealth > 100 then
		self.StatusHealth = 100
	end
end

function Throne:GetHealth()
    return self.StatusHealth
end
]]
--[[
if Throne == nil then
	Throne = class({})
	
end


function Throne:Init()

	self.Throne = CreateUnitByName("gem_throne", Vector(1792, -1792, 0), false, nil,nil, DOTA_TEAM_GOODGUYS)
	self.Health = 100
    
end

function Throne:SetHealth(health)
    self.StatusHealth = health
	if self.StatusHealth > 100 then
		self.StatusHealth = 100
	end
end

function Throne:GetHealth()
    return self.StatusHealth
end

function Throne:IsDead()
	if self.StatusHealth <= 0 then
		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
	end
end

function Throne:OnTouch(trigger)
	
	local throne = self.Throne
	local unit = trigger.activator
	local handle = unit:GetEntityHandle()
	
	if unit and string.match(unit:GetUnitName(), "gem_round") then

		local data = 
		{	
			handle = tostring(handle)
		}
		FireGameEvent("throne_touch", data)
	
		self.StatusHealth = self.StatusHealth - unit:GetBaseDamageMax()
		CustomNetTables:SetTableValue( "game_state", "gem_castle_health", { value = self.StatusHealth } )
		Throne:IsDead()
		unit:Destroy()
	else
		print("Hero stepped in Throne!")
	end
end

function Throne:SpawnEntity()
	local thronePosition = Vector(1792, -1792, 0)
	local Throne = CreateUnitByName("gem_throne", thronePosition, false, nil, nil, DOTA_TEAM_GOODGUYS)
	Throne:SetForwardVector(Vector(-1,0,0))
end
]]--