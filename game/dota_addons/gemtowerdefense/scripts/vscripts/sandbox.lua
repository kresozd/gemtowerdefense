
if Sandbox == nil then
	Sandbox = class({})
	
end
--[[
--class is not included yet in addon_file

function Sandbox:Init()

--this shit will be put into kv file
    self.CommandList =
    {
        "set_round",
        "set_health",
        "kill_enemies"
    }
--aswel as this
    self.Devs = 
    {
        ["cro_madbomber"]   = "76561198004060808",
        ["Burusomazu"]      = "76561198074443940"
        --All need to be added, PhysicsGuy, zach, eric yohansa, xemon, potato, monohlyra, king, windblown, skinpop
    }

    ListenToGameEvent("player_chat", Dynamic_Wrap(GemTowerDefenseReborn, "OnPlayerChat"), self)

    self.Commands = {}

    function IsDev()

        if self.Devs[PlayerResource:GetSteamID()] then
            return true
        else
            return false
        end  
    end
end


function SandBox:SetRound()

    if Rounds:GetState() == "BUILD" then

        
        Rounds:SetRoundNumber(value)

    

end


function Sandbox:OnPlayerChat(keys)
    
    local teamonly = keys.teamonly
    local userID = keys.userid
    local playerID = userID:GetPlayerID()
    local text = keys.text

    if self.CommandList[text] and IsDev() then

        --call commands

    end

end

]]--
