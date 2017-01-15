function HealThrone(keys)

    local caster = keys.caster
    local healValue = 5
    local currentHP = Rounds:GetBaseHealth()
    local newHP = currentHP + healValue

    Rounds:SetBaseHealth(newHP)
    CustomNetTables:SetTableValue( "game_state", "gem_castle_health", { value = tostring(Rounds:GetBaseHealth()) } )
end