-- This class is used to store all stats during game like amount of leaked, total killed, round reached, etc.

MAX_TOP_TOWERS = 5

if GameData == nil then
	GameData = class({})
end


function GameData:Init()

	ListenToGameEvent("throne_touch",Dynamic_Wrap(GameData, 'OnLeaked'), self)
	ListenToGameEvent("entity_killed", Dynamic_Wrap(GameData, 'OnEntityKilled'), self)
	ListenToGameEvent("entity_hurt", Dynamic_Wrap(GameData, 'OnEntityHurt'), self)

	self.LeakCount = {}
	self.Killed = 0
	self.Round  = 0
	self.TowerDamage = {}
	self.topDamage = {}

end


function GameData:OnLeaked(keys)
    
end


function GameData:OnEntityKilled(keys)
    self.Killed = self.Killed + 1
end


function GameData:OnEntityHurt(keys)

	if keys.entindex_attacker ~= nil then

		local entity = EntIndexToHScript(keys.entindex_attacker)
		local entityIndex = entity:GetEntityIndex()
		local damage = math.floor(keys.damage)

		if damage <= 0 then
			damage = 0
		end

		if entity:IsHero() then
			return
		end

		local totalDamage = self.TowerDamage[entityIndex]

		if totalDamage == nil then
			totalDamage = 0
		end

		totalDamage = totalDamage + damage
		self.TowerDamage[entityIndex] = totalDamage

		if GameData:isWorthToUpdate(totalDamage) then
			GameData:SortDamageTable()
		end

	end

end


function GameData:isWorthToUpdate(totalDamage)
    if self.topDamage[#self.topDamage] == nil or #self.topDamage < MAX_TOP_TOWERS then
		return true
	elseif totalDamage > self.topDamage[#self.topDamage].damage then
		return true
	else
		return false
	end
end


function spairs(t, order)
    
	local keys = {}
	for k in pairs(t) do keys[#keys+1] = k end

	if order then
		table.sort(keys, function(a,b) return order(t, a, b) end)
	else
		table.sort(keys)
	end

	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end


function GameData:SortDamageTable()
	self.topDamage = {}
	local i = 0
	local totalDmg = 0

	for k, v in spairs(self.TowerDamage, function(t, a, b) return t[b] < t[a] end) do
		self.topDamage[i] = {}
		self.topDamage[i].index = k
		self.topDamage[i].damage = v
		totalDmg = totalDmg + v
		i = i + 1
		
		if i > MAX_TOP_TOWERS - 1 then
			break
		end
	end

	CustomGameEventManager:Send_ServerToAllClients( "update_tower_stats_damage", {damageTable = self.topDamage, totalDamage = totalDmg} )
end