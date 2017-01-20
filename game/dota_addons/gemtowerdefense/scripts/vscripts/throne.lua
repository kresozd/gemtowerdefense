if Throne == nil then
	Throne = class({})
	
end


function Throne:Init()

	self.Throne = CreateUnitByName("gem_throne", Vector(1792, -1792, 0), false, nil,nil, DOTA_TEAM_GOODGUYS)
    
end

function Throne:GetThrone()
	return self.Throne
end

function Throne:IsDead()
	local throne = self.Throne
	if throne:GetHealth() <= 0 then
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

		throne:SetHealth(throne:GetHealth() - unit:GetBaseDamageMax())
		print("Throne HP on touch:", throne:GetBaseMaxHealth())
		CustomNetTables:SetTableValue( "game_state", "gem_castle_health", { value = throne:GetHealth() } )
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