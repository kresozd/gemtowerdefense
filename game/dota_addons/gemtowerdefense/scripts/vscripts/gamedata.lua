-- This class is used to store all stats during game like amount of leaked, total killed, round reached, etc.
if GameData == nil then
	GameData = class({})
end


function GameData:Init()

   -- ListenToGameEvent("throne_touch",Dynamic_Wrap(GameData, 'OnLeaked'), self)

   -- self.LeakCount = {}
    self.Killed = 0
    self.Round  = 0
end


function GameData:OnLeaked(keys)
self.LeakCount = self.LeakCount + 1
end

function GameData:OnEntityKilled(keys)
    self.Killed = self.Killed + 1
end