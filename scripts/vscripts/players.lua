if Players == nil then
	Players = class({})
	
end

function Players:Init()

    self.pAmount = 0
    self.Picked = {}

end

function Players:SetAmount(value)

    self.pAmount = value

end

function Players:SetPicked(playerID, bool)

    self.Picked[playerID] = bool

end


function Players:CheckIfAllPicked()

    for k, v in pairs(self.Picked) do
        
        if v == false then

            return false

        end
    end

    CustomNetTables:SetTableValue( "game_state", "all_picked", { value = "pick" } )
    print("All Picked!")
    return true
    


end