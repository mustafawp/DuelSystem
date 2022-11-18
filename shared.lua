function getPlayersWithName(str)
    if str and tostring(str) then
        local playerTable = {}
        local foundPlayer = getPlayerFromName(str) or getPlayerFromName(string.gsub(str,"#%x%x%x%x%x%x", ""))
        if foundPlayer then 
            playerTable[#playerTable+1] = foundPlayer
        else
            for i,player in pairs(getElementsByType('player')) do 
                local playerName = getPlayerName(player)
                if string.find(string.gsub(playerName:lower(),"#%x%x%x%x%x%x", ""), str:lower(), 1, true) then
                    playerTable[#playerTable+1] = player
                end
            end
        end
        return playerTable
    end
end  

function getWeapons(ped)
    local playerWeapons = {}
    if ped and isElement(ped) and getElementType(ped) == "ped" or getElementType(ped) == "player" then
        for i=1,12 do
            local wep = getPedWeapon(ped,i)
            local ammo = getPedTotalAmmo (ped,i) 
            if wep and wep ~= 0 and ammo then
                playerWeapons[wep] = ammo
            end
        end
        return playerWeapons
    end
end