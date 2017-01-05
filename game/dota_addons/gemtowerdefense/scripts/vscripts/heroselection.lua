if HeroSelection == nil then
	HeroSelection = class({})
	
end


function HeroSelection:Init()

    self.HeroesPicked = 0


end


function HeroSelection:AllPicked()

    if self.HeroesPicked == PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) then

        return true

    else

        return false    

    end
end

function HeroSelection:IncremetHeroPickCount()

    self.HeroesPicked = self.HeroesPicked + 1

end

function HeroSelection:UnlockAbilities()

    for i = 0, PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) -1 do

        local player = PlayerResource:GetPlayer(i)
		local hero = player:GetAssignedHero()

       HeroSelection:RemoveTalents(hero)
	
        hero:AddAbility("gem_build_tower"):SetLevel(1)
	    hero:FindAbilityByName("gem_build_tower"):SetAbilityIndex(0)
	    
        hero:AddAbility("gem_remove_tower"):SetLevel(1)
	    hero:FindAbilityByName("gem_remove_tower"):SetAbilityIndex(1)

    end
end


function HeroSelection:RemoveTalents(hero)

	for i = 0,10 do

		local ability = hero:GetAbilityByIndex(i)

		if ability and string.match(ability:GetName(), "special_bonus") then

			hero:RemoveAbility(ability:GetName())

		end
	end
end
