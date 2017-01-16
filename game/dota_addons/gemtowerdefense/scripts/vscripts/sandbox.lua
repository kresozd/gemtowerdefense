
if Sandbox == nil then
	Sandbox = class({})
	
end

--class is not included yet in addon_file

function Sandbox:Init()


    CustomGameEventManager:RegisterListener( "sandbox_clear_wave", Dynamic_Wrap(Sandbox, 'KillAllEnemies'))
    CustomGameEventManager:RegisterListener( "sandbox_reset_level", Dynamic_Wrap(Sandbox, 'ResetLevel'))
    CustomGameEventManager:RegisterListener( "sandbox_level_up", Dynamic_Wrap(Sandbox, 'LevelUp'))

    self.Enabled = false

    function IsDev(playerID)
        print("Testing if ", PlayerResource:GetSteamID(playerID), " is a dev")
        if self.Devs[tostring(PlayerResource:GetSteamID(playerID))] then
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
    local player = PlayerResource:GetPlayer(keys.userid - 1)
    local playerID = player:GetPlayerID()

    local tokens =  string.split(string.trim(keys.text))

    if self.CommandList[tokens[1]] and IsDev(playerID) then

        print("Command is correct and player is a dev")
       --local command = Sandbox:ChangeRound()
    end
    print(tokens[1], self.CommandList[tokens[1]])
end

function string.trim(s)
    return s:match "^%s*(.-)%s*$"
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.split(s, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(s, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end


