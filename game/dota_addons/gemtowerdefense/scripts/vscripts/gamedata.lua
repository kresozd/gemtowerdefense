-- This class is used to store all stats during game like amount of leaked, total killed, round reached, etc.
if GameData == nil then
	GameData = class({})
end


function GameData:Init()

   ListenToGameEvent("throne_touch",Dynamic_Wrap(GameData, 'OnLeaked'), self)
   ListenToGameEvent("entity_killed", Dynamic_Wrap(GameData, 'OnEntityKilled'), self)
   --ListenToGameEvent("entity_hurt", Dynamic_Wrap(GameData, 'OnEntityHurt'), self)

    self.LeakCount = {}
    self.Killed = 0
    self.Round  = 0

end


function GameData:OnLeaked(keys)
    
end

function GameData:OnEntityKilled(keys)
    self.Killed = self.Killed + 1
end


function GameData:OnEntityHurt(keys)
--notes use setthink in the wave.lua in order to only update this every 0.5 seconds to save on memory

end