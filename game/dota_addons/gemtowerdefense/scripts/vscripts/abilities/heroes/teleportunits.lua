function Teleport(keys)

    local DISTANCE = 15
    local units = Wave:GetEnemies()
    local vectorMap = Grid:GetVectorMap()
    --local mapSize = table.getn(vectorMap)
    for key, unit in pairs(units) do
        local currentStep = unit.Step
        unit.Step = RandomInt(unit.Step - DISTANCE , unit.Step)
        unit:SetAbsOrigin(vectorMap[unit.Step])
    end

end