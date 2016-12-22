if Abilities == nil then
	Abilities = class({})
end









function Abilities:AddDowngradeAbility(player)

    for k,v in pairs(RoundTowers[player]) do

        local Tower = v

        Tower:AddAbility("gem_downgrade_tower"):SetLevel(1)

    end

end







