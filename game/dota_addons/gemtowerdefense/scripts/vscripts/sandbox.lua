
if Sandbox == nil then
	Sandbox = class({})
	
end

--class is not included yet in addon_file

function Sandbox:Init()


    CustomGameEventManager:RegisterListener( "sandbox_clear_wave", Dynamic_Wrap(Sandbox, 'KillAllEnemies'))
    CustomGameEventManager:RegisterListener( "sandbox_reset_level", Dynamic_Wrap(Sandbox, 'ResetLevel'))
    CustomGameEventManager:RegisterListener( "sandbox_level_up", Dynamic_Wrap(Sandbox, 'LevelUp'))
    CustomGameEventManager:RegisterListener( "sandbox_hit_throne", Dynamic_Wrap(Sandbox, 'DamageThrone'))
    CustomGameEventManager:RegisterListener( "sandbox_heal_throne", Dynamic_Wrap(Sandbox, 'HealThrone'))

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

function Sandbox:DamageThrone(keys)
    local DAMAGE_VALUE = 10
    local throne = Throne:GetThrone()
    throne:SetHealth(throne:GetHealth() - DAMAGE_VALUE)
    CustomNetTables:SetTableValue( "game_state", "gem_castle_health", { value = throne:GetHealth() } )

    Throne:IsDead()
end

function Sandbox:HealThrone(keys)
    local HEAL_VALUE = 10
    local throne = Throne:GetThrone()
    throne:SetHealth(throne:GetHealth() + HEAL_VALUE)
    CustomNetTables:SetTableValue( "game_state", "gem_castle_health", { value = throne:GetHealth() } )
end


function Sandbox:ResetLevel(keys)

    --local MAX_UNITS_ON_WAVE = 10
    --local unitCount = Containers.TableLength(Wave:GetEnemies())
     if  Wave:GetState() == "WAVE" and Wave.AllSpawned == true then
        Wave:DeleteAllUnits()
        Wave:WaveInit()
    else
        
    end
end


function Sandbox:LevelUp(keys)

    local playerID = keys.PlayerID
    local player = PlayerResource:GetPlayer(playerID)
	local hero = player:GetAssignedHero()
    hero:HeroLevelUp(true)
end

function Sandbox:KillAllEnemies(keys)

    
    local unitCount = Containers.TableLength(Wave:GetEnemies())
    if  Wave:GetState() == "WAVE" and Wave.AllSpawned == true then
        local eventData = {state = "BUILD"}
	    FireGameEvent("round_end", eventData)

        Wave:DeleteAllUnits()
        Wave:UpdateWaveData()
    else    
        print("Can't use that while placing!")

    end
end

function Sandbox:OnRoundChanged()

    if Wave:GetState() == "BUILD" then
        Wave:SetRoundNumber(value)
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


