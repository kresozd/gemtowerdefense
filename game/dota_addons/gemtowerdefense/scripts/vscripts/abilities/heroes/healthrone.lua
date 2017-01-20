function HealThrone(keys)

    local throne = Throne:GetThrone()
    local caster = keys.caster
    local healValue = 5
    
    throne:SetHealth(throne:GetHealth() + healValue)

    CustomNetTables:SetTableValue( "game_state", "gem_castle_health", { value = tostring(throne:GetHealth()) } )
end