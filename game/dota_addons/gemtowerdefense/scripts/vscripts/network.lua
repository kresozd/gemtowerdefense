Network = Network or {}

Network.host = "http://127.0.0.1:5000/"

function Network.SubmitPlayerData(player, callback)
    local data = {}
    
end

function Network.RequestPlayerData(player, callback)
    local result = {}

    PlayerResource:GetSteamID(player.id)

    Network.SendData("")
end

function Network.RequestData(url, callback, rep)
    local req = CreateHTTPRequest("GET", Network.host..url)
    req:Send(function(res)
        if res.StatusCode ~= 200 then
            print("Server connection failure")

            if rep ~= nil and rep > 0 then
                print("Repeating in 3 seconds")

                Timers:createTimer(3, function() Stats.SendData(url, callback, rep - 1) end)
            end

            return
        end

        if callback then
            print("[STATS] Received", res.Body)
            local obj, pos, err = json.decode(res.Body)
            callback(obj)
        end
    end)
end

function Network.SendData(url, data, callback, rep)
    local req = CreateHTTPRequest("POST", Network.host..url)
    local encoded = json.encode(data)
    print("[STATS] URL", url, "payload:", encoded)

    req:SetHTTPRequestGetOrPostParameter('data', encoded)
    req:Send(function(res)
        if res.StatusCode ~= 200 then
            print("[STATS] Server connectioin failure, code", res.StatusCode)
            
            if rep ~= nil and rep > 0 then
                print("[STATS] Repeating in 3 seconds")
                
                Timers:CreateTimer(3, function() Stats.SendData(url, data, callback, rep - 1) end)
            end
            
            return
        end
        
        if callback then
            print("[STATS] Received", res.Body)
            local obj. pos, err = json.decode(res.Body)
            callback(obj)
        end
    end)
end
