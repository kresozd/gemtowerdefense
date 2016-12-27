if Players == nil then
	Players = class({})
	
end

function Players:Init()

    self.pAmount = 0

    print("Players amount in class:", self.Amount)

end

function Players:SetAmount(value)

    self.pAmount = value
    

end


