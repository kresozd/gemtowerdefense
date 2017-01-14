function HealThrone(keys)

    print("f called heal throne")

    local caster = keys.caster
    local healValue = 5
    local currentHP = Rounds:GetBaseHealth()
    local newHP = currentHP + healValue

    

    if newHP > 100 then
        Rounds:SetBaseHealth(100)
        CustomNetTables:SetTableValue( "game_state", "gem_castle_health", { value = tostring(Rounds:GetBaseHealth()) } )

    else
        Rounds:SetBaseHealth(newHP)
        CustomNetTables:SetTableValue( "game_state", "gem_castle_health", { value = tostring(Rounds:GetBaseHealth()) } )
    end
end