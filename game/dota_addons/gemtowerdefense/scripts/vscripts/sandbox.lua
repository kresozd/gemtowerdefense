
if Sandbox == nil then
	Sandbox = class({})
	
end

--class is not included yet in addon_file

function Sandbox:Init()


    CustomGameEventManager:RegisterListener( "debug_clear_wave", Dynamic_Wrap(Sandbox, 'KillAllEnemies'))
    CustomGameEventManager:RegisterListener( "debug_reset_level", Dynamic_Wrap(Sandbox, 'ResetLevel'))
    CustomGameEventManager:RegisterListener( "debug_level_up", Dynamic_Wrap(Sandbox, 'LevelUp'))

    self.Devs = 
    {
        ["cro_madbomber"]   = "76561198004060808",
        ["Burusomazu"]      = "76561198074443940"
        --All need to be added, PhysicsGuy, zach, eric yohansa, xemon, potato, monohlyra, king, windblown, skinpop
    }

    ListenToGameEvent("player_chat", Dynamic_Wrap(Sandbox, "OnPlayerChat"), self)

    function IsDev(playerID)

        if self.Devs[PlayerResource:GetSteamID(playerID)] then
            return true
        else
            return false
        end  
    end
end

function Sandbox:DamageThrone()
end

function Sandbox:HealThrone()
end


function Sandbox:ResetLevel(keys)

    local units = Rounds:GetEnemies()
    if Rounds:GetAmountSpawned() == 10 and Rounds:GetState() == "WAVE" then
        for key, unit in pairs(units) do
            unit:Destroy()
            units[key] = nil
        end
        local data = {state = "WAVE"}
	    FireGameEvent("reset_round", data)
    else
        print("Wait for all to spawn!")
    end
end

function Sandbox:LevelUp(keys)

    for i = 0, PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) - 1 do
        local player = PlayerResource:GetPlayer(i)
        local playerID = player:GetPlayerID()
		local hero = player:GetAssignedHero()
        hero:HeroLevelUp(true)
    end
end

function Sandbox:KillAllEnemies(keys)

    local units = Rounds:GetEnemies()
    if Rounds:GetAmountSpawned() == 10 then
        for key, unit in pairs(units) do
            unit:Destroy()
            units[key] = nil
        end
        local data = {state = "BUILD"}
	    FireGameEvent("reset_round", data)
    else
        print("Wait for all to spawn!")
    end
end

function Sandbox:OnRoundChanged()

    if Rounds:GetState() == "BUILD" then
        Rounds:SetRoundNumber(value)
    else
        --error cant build during wave phase
    end
end

function Sandbox:OnPlayerChat(keys)
    
    local teamonly = keys.teamonly
    --local userID = keys.userid
   -- local playerID = userID:GetPlayerID()
    local tokens =  string.split(string.trim(keys.text))

    print(tokens[1])

    if self.CommandList[tokens] and IsDev(playerID) then

        print("true")
       local command = Sandbox:ChangeRound()


    end

end


