
if Sandbox == nil then
	Sandbox = class({})
	
end

--class is not included yet in addon_file

function Sandbox:Init()

--this shit will be put into kv file
    self.CommandList =
    {
     

    }
--aswel as this
    self.Devs = 
    {
        ["cro_madbomber"]   = "76561198004060808",
        ["Burusomazu"]      = "76561198074443940"
        --All need to be added, PhysicsGuy, zach, eric yohansa, xemon, potato, monohlyra, king, windblown, skinpop
    }

    ListenToGameEvent("player_chat", Dynamic_Wrap(Sandbox, "OnPlayerChat"), self)

    self.Commands = {}

    function IsDev(playerID)

        if self.Devs[PlayerResource:GetSteamID(playerID)] then
            return true
        else
            return false
        end  
    end
end




function Sandbox:ChangeRound()

    print("Change round called!")

    if Rounds:GetState() == "BUILD" then

        Rounds:SetRoundNumber(value)

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


