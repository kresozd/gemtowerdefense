-- This class is used to store all stats during game like amount of leaked, total killed, round reached, etc.
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
    self.FinalBossDamage = 0
end


function GameData:OnLeaked(keys)
    
end

function GameData:OnEntityKilled(keys)
    self.Killed = self.Killed + 1
end


function GameData:OnEntityHurt(keys)

    --DEBUG
    local table = GameData:SortTopTenTowers(Wave.TowerDamage)
    for k, v in pairs(table) do
        print("tower", k, "damage", v)
    end

    -----------------------------------
    CustomGameEventManager:Send_ServerToAllClients( "update_tower_stats_damage", {damageTable = GameData:SortTopTenTowers(Wave.TowerDamage)} )
    print("Entity hurt!")
end



function GameData:SortTopTenTowers(t)

    local count = 0
    t = getKeysSortedByValue(t, function(a, b) return a < b end)
    local DamageData = {}
    for key, value in pairs(t) do
        
        if count < 10 then
            DamageData[key] = value
        else
            break
        end
        count = count + 1
    end
    return DamageData
end

function getKeysSortedByValue(tbl, sortFunction)
  local keys = {}
  for key in pairs(tbl) do
    table.insert(keys, key)
  end

  table.sort(keys, function(a, b)
    return sortFunction(tbl[a], tbl[b])
  end)

  return keys
end