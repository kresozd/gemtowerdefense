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
    self.DamageFromTowers = {}
end


function GameData:OnLeaked(keys)
    
end

function GameData:OnEntityKilled(keys)
    self.Killed = self.Killed + 1
end


function GameData:OnEntityHurt(keys)

local allDamage = Wave.TowerDamage
local topFiveTowers = {
  [1]={},
  [2]={},
  [3]={},
  [4]={},
  [5]={}
}

local maxDamage={
  [1]=0,
  [2]=0,
  [3]=0,
  [4]=0,
  [5]=0
}
for i,j in pairs(allDamage) do
  if j>=maxDamage[1] then
    topFiveTowers[1][i]=j
    maxDamage[1]=j
  elseif j>maxDamage[2] then
    topFiveTowers[2][i]=j
    maxDamage[2]=j
  elseif j>maxDamage[3] then
    topFiveTowers[3][i]=j
    maxDamage[3]=j
  elseif j>maxDamage[4] then
    topFiveTowers[4][i]=j
    maxDamage[4]=j
  elseif j>maxDamage[5] then
    topFiveTowers[5][i]=j
    maxDamage[5]=j        
  end
end

    CustomGameEventManager:Send_ServerToAllClients( "update_tower_stats_damage", {damageTable = topFiveTowers} )
    --print("Entity hurt!")
end