if Players == nil then
	Players = class({})
	
end

function Players:Init()

    self.pAmount = 0
    self.Picked = {}
    self.PlayerHero = {}

end

function Players:SetHero(playerID, hero)

    self.PlayerHero[playerID] = hero


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

    print("All Picked!")
    return true
    
end
--[[
function Players:RemoveTalents(hero)

	local start = 2

	for i = 0,10 do

		local ability = hero:GetAbilityByIndex(i)

		if ability and string.match(ability:GetName(), "special_bonus") then

			hero:RemoveAbility(ability:GetName())

		end

	end

end


]]--

function Players:UnlockAbilities()

    for key, hero in pairs(self.PlayerHero) do

	    hero:FindAbilityByName("gem_build_tower"):SetLevel(1)
	    hero:FindAbilityByName("gem_remove_tower"):SetLevel(1)

    end

end
