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

        for i, j in pairs(v) do

            if j == false then

                return false

            end

        end

    end

    return true


end