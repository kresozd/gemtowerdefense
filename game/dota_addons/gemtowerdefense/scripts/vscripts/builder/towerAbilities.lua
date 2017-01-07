
function AbilityConfirmTower(keys)

	print("Ability confirm tower called!")

	local caster = keys.caster
	local owner =  caster:GetOwner()
	local playerID = owner:GetPlayerID()

	
	Builder:ConfirmTower(caster, owner, playerID)

end


function AbilityDowngradeTower(keys)

	local caster = keys.caster
	local owner = caster:GetOwner()
	local playerID = owner:GetPlayerID()

	Builder:DowngradeTower(caster, owner, playerID)
	
end

function AbilityMergeTower(keys)
	print("Merging in "..Rounds.State)
	local caster = keys.caster
	local owner = caster:GetOwner()
	local playerID = owner:GetPlayerID()
	if Rounds.State == "BUILD" then
		Builder:CreateMergeableTower(playerID, caster, owner)
	else
		Builder:WaveCreateMergedTower(playerID, caster, owner)
	end

end

function AbilityMergeTower_2(keys)

	local caster = keys.caster
	local owner = caster:GetOwner()
	local playerID = owner:GetPlayerID()
	if Rounds.State == "BUILD" then
		Builder:CreateMergeableTower_2(playerID, caster, owner)
	else
		Builder:WaveCreateMergedTower_2(playerID, caster, owner)
	end

end

function CallibrateTreePosition(Vector)

	Vector.z = Vector.z - 90

	return Vector

end

function AbilityOneShotUpgradeTower(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local playerID = owner:GetPlayerID()

	
	Builder:OneShotUpgradeTower(caster, owner, playerID)
end

function AbilityOneShotUpgradeTower_2(keys)
	local caster = keys.caster
	local owner =  caster:GetOwner()
	local playerID = owner:GetPlayerID()

	
	Builder:OneShotUpgradeTower_2(caster, owner, playerID)
end

function Ability_Split_Shot( keys )
 
        local caster = keys.caster
        local target = keys.target


        local radius = caster:GetAttackRange() +100
        local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
        local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BUILDING
        local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_NONE
        local group = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetOrigin(),nil,radius,teams,types,flags,FIND_CLOSEST,true)
        local attack_count = keys.attack_count or 0
        local attack_effect = keys.attack_effect or "particles/units/heroes/hero_lina/lina_base_attack.vpcf"
        local attack_unit = {}
        for i,unit in pairs(group) do
                if (#attack_unit)==attack_count then
                    break
                end

                if unit~=target then
                    if unit:IsAlive() then
                            table.insert(attack_unit,unit)
                    end
                end
        end

        for i,unit in pairs(attack_unit) do
                local info =
                {
                    Target = unit,
                    Source = caster,
                    Ability = keys.ability,
                    EffectName = attack_effect,
                    bDodgeable = false,
                    iMoveSpeed = 1200,
                    bProvidesVision = false,
                    iVisionRadius = 0,
                    iVisionTeamNumber = caster:GetTeamNumber(),
                    iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
                }
                projectile = ProjectileManager:CreateTrackingProjectile(info)
        end
end

function Ability_Split_Shot_Damage( keys )
    local caster = keys.caster
    local target = keys.target
    local attack_damage = caster:GetAttackDamage()
    local damageTable = {victim=target,
    attacker=caster,
    damage_type=DAMAGE_TYPE_PHYSICAL,
    damage=attack_damage}
    ApplyDamage(damageTable)
end

function Ability_ruby_splash (keys)
    local caster = keys.caster
    local target = keys.target
    local radius = keys.Radius
    local percentDam = keys.Percentage
    local direUnits = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                              target:GetAbsOrigin(),
                              nil,
                              radius,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                              FIND_ANY_ORDER,
                              false)
    for key,unit in pairs(direUnits) do
        local attack_damage = keys.Damage
        local damage = attack_damage*percentDam
        local damageTable = {
            victim=unit,
            attacker=caster,
            damage_type=DAMAGE_TYPE_PURE,
            damage=damage
        }
        ApplyDamage(damageTable)

    end
end 

function Ability_Emerald_Golem (keys)
    local caster = keys.caster
    caster:FindAbilityByName("medusa_stone_gaze"):SetLevel(1)

    local newOrder = 
    {
        UnitIndex = caster:entindex(), 
        OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
        TargetIndex = nil, --Optional.  Only used when targeting units
        AbilityIndex = caster:FindAbilityByName("medusa_stone_gaze"):entindex(), --Optional.  Only used when casting abilities
        Position = nil, --Optional.  Only used when targeting the ground
        Queue = 0 --Optional.  Used for queueing up abilities
    }
    ExecuteOrderFromTable(newOrder)
end

function Ability_Egypt_Gold( keys )
    local caster = keys.caster
    local gold_count = RandomInt(1,50)

    if gold_count >= 100 then
        EmitGlobalSound("General.CoinsBig")
    else
        EmitGlobalSound("General.Coins")
    end
    local ii = 0
    for ii = 0, 20 do
        if ( PlayerResource:IsValidPlayer( ii ) ) then
            local player = PlayerResource:GetPlayer(ii)
            local playergold = player:GetGold()
            if player ~= nil then
                PlayerResource:SetGold(ii, playergold+gold_count, true)
            end
        end
    end
end

function Ability_Arc_Lightning_counter( keys )
    local caster = keys.caster
    local target = keys.target
 
    keys.ability.AttackCount = (keys.ability.AttackCount or 0) + 1
 
    if keys.ability.AttackCount>=keys.AttackCount then
        keys.ability.AttackCount = 0
        Ability_Arc_Lightning( caster,caster,target,keys.ability,keys.Radius,1,keys.Count,{} )
    end
end

function Ability_Arc_Lightning( caster,old,new,ability,radius,count,count_const,_group )
 
    if count>count_const then
        return nil
    end
     
    if IsValidEntity(old) and IsValidEntity(new) then
        if old:IsAlive() and new:IsAlive() then
            local p = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf",PATTACH_CUSTOMORIGIN,old)
            ParticleManager:SetParticleControlEnt(p,0,old,5,"attach_hitloc",old:GetOrigin(),true)
            ParticleManager:SetParticleControlEnt(p,1,new,5,"attach_hitloc",new:GetOrigin(),true)
 
            ability:ApplyDataDrivenModifier(caster,new,"modifier_Arc_Lightning_effect",nil)
 
            table.insert(_group,new)
 
            GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("Ability_Arc_Lightning"),function()
                local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
                local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
                local flags = DOTA_UNIT_TARGET_FLAG_NONE
                local group = FindUnitsInRadius(caster:GetTeamNumber(),new:GetOrigin(),nil,radius,teams,types,flags,FIND_CLOSEST,true)
 
                local unit  = nil
                local alive = true
                repeat
                    if #group<=0 then break end
 
                    unit = table.remove(group,1)
 
                    if IsValidEntity(unit) then
                        if unit:IsAlive() then
                            alive = true
                        else
                            alive = false
                        end
                    else
                        alive = false
                    end
 
                    for k,v in pairs(_group) do
                        if unit == v then
                            alive = false
                            break
                        end
                    end
 
                until(alive)
 
                Ability_Arc_Lightning( caster,new,unit,ability,radius,count+1,count_const,_group )
 
                return nil
            end,0.2)
        end
    end
 
end

function Shock( event )
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel() - 1
    local start_radius = ability:GetLevelSpecialValueFor("start_radius", level )
    local end_radius = ability:GetLevelSpecialValueFor("end_radius", level )
    local end_distance = ability:GetLevelSpecialValueFor("end_distance", level )
    local targets = ability:GetLevelSpecialValueFor("targets", level )
    local damage = ability:GetLevelSpecialValueFor("damage", level )
    local AbilityDamageType = ability:GetAbilityDamageType()
    local particleName = "particles/units/heroes/hero_shadowshaman/shadowshaman_ether_shock.vpcf"

    -- Make sure the main target is damaged
    local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(lightningBolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))   
    ParticleManager:SetParticleControl(lightningBolt,1,Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
    ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = AbilityDamageType})
    target:EmitSound("Hero_ShadowShaman.EtherShock.Target")

    local cone_units = GetEnemiesInCone( caster, start_radius, end_radius, end_distance )
    local targets_shocked = 1 --Is targets=extra targets or total?
    for _,unit in pairs(cone_units) do
        if targets_shocked < targets then
            if unit ~= target then
                -- Particle
                local origin = unit:GetAbsOrigin()
                local lightningBolt = ParticleManager:CreateParticle(particleName, PATTACH_WORLDORIGIN, caster)
                ParticleManager:SetParticleControl(lightningBolt,0,Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))   
                ParticleManager:SetParticleControl(lightningBolt,1,Vector(origin.x,origin.y,origin.z + unit:GetBoundingMaxs().z ))
            
                -- Damage
                ApplyDamage({ victim = unit, attacker = caster, damage = damage, damage_type = AbilityDamageType})

                -- Increment counter
                targets_shocked = targets_shocked + 1
            end
        else
            break
        end
    end
end


function GetEnemiesInCone( unit, start_radius, end_radius, end_distance)
    local DEBUG = false
    
    -- Positions
    local fv = unit:GetForwardVector()
    local origin = unit:GetAbsOrigin()

    local start_point = origin + fv * start_radius -- Position to find units with start_radius
    local end_point = origin + fv * (start_radius + end_distance) -- Position to find units with end_radius

    if DEBUG then
        DebugDrawCircle(start_point, Vector(255,0,0), 100, start_radius, true, 3)
        DebugDrawCircle(end_point, Vector(255,0,0), 100, end_radius, true, 3)
    end

    -- 1 medium circle should be enough as long as the mid_interval isn't too large
    local mid_interval = end_distance - start_radius - end_radius
    local mid_radius = (start_radius + end_radius) / 2
    local mid_point = origin + fv * mid_radius * 2
    
    if DEBUG then
        --print("There's a space of "..mid_interval.." between the circles at the cone edges")
        DebugDrawCircle(mid_point, Vector(0,255,0), 100, mid_radius, true, 3)
    end

    -- Find the units
    local team = unit:GetTeamNumber()
    local iTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
    local iType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
    local iFlag = DOTA_UNIT_TARGET_FLAG_NONE
    local iOrder = FIND_ANY_ORDER

    local start_units = FindUnitsInRadius(team, start_point, nil, start_radius, iTeam, iType, iFlag, iOrder, false)
    local end_units = FindUnitsInRadius(team, end_point, nil, end_radius, iTeam, iType, iFlag, iOrder, false)
    local mid_units = FindUnitsInRadius(team, mid_point, nil, mid_radius, iTeam, iType, iFlag, iOrder, false)

    -- Join the tables
    local cone_units = {}
    for k,v in pairs(end_units) do
        table.insert(cone_units, v)
    end

    for k,v in pairs(start_units) do
        if not tableContains(cone_units, k) then
            table.insert(cone_units, v)
        end
    end 

    for k,v in pairs(mid_units) do
        if not tableContains(cone_units, k) then
            table.insert(cone_units, v)
        end
    end

    --DeepPrintTable(cone_units)
    return cone_units

end

-- Returns true if the element can be found on the list, false otherwise
function tableContains(list, element)
    if list == nil then return false end
    for i=1,#list do
        if list[i] == element then
            return true
        end
    end
    return false
end

function Ability_Uranium_damage( keys )
    local caster = keys.caster
    local target = keys.target
    local attack_damage_lose = keys.attack_damage_lose or 0
    local attack_damage = caster:GetAttackDamage() * ((100-attack_damage_lose)/100)
    local damageTable = {victim=target,
    attacker=caster,
    damage_type=DAMAGE_TYPE_PHYSICAL,
    damage=attack_damage}
    ApplyDamage(damageTable)
end

function Ability_Uranium_damage_split( keys )
 
        local caster = keys.caster
        local target = keys.target
        if caster:IsRangedAttacker() then
                local radius = caster:GetAttackRange() +100
                local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
                local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BUILDING
                local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_NONE
                local group = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetOrigin(),nil,radius,teams,types,flags,FIND_CLOSEST,true)
                local attack_count = keys.attack_count or 0

                local attack_effect = keys.attack_effect or "particles/units/heroes/hero_razor/razor_static_link_projectile_a.vpcf"
                local attack_unit = {}

                for i,unit in pairs(group) do
                        if (#attack_unit)==attack_count then
                                break
                        end
 
                        if unit~=target then
                                if unit:IsAlive() then
                                        table.insert(attack_unit,unit)
                                end
                        end
                end
 
                for i,unit in pairs(attack_unit) do
                        local info =
                                                {
                                                        Target = unit,
                                                        Source = caster,
                                                        Ability = keys.ability,
                                                        EffectName = attack_effect,
                                                        bDodgeable = false,
                                                        iMoveSpeed = 1500,
                                                        bProvidesVision = false,
                                                        iVisionRadius = 0,
                                                        iVisionTeamNumber = caster:GetTeamNumber(),
                                                        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
                                                }
                        projectile = ProjectileManager:CreateTrackingProjectile(info)
 
                end
        end
end