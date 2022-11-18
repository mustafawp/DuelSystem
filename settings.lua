-- #s_WeaponIDs = {[weapon ID]=ammo} // EXAMPLE
-- #s_MaxRounds = 5 // EXAMPLE

s_WeaponIDs = {[31]=1000,[28]=1000}
s_MaxRounds = 5



-- EDIT EVERYTHING ABOVE THIS IF YOU WANT
-- DONT EDIT ANYTHING ELSE BELOW UNLESS YOU KNOW WHAT YOU ARE DOING

s_duelSpawns1 = {
    -- x, y, z, rotation, interior
    {281.651, 1839.693, 7.727}, -- spawn 1
    {326.603, 1839.545, 7.727}, -- spawn 2
}

s_duelSpawns2 = {
    -- x, y, z, rotation, interior
    {2829.505, 1265.719, 10.772}, -- spawn 1
    {2828.541, 1314.894, 10.77}, -- spawn 2
}

s_duelSpawns3 = {
    -- x, y, z, rotation, interior
    {-1347.389, -484.552, 14.172}, -- spawn 1
    {-1378.308, -500.609, 14.172}, -- spawn 2
}

s_duelSpawns4 = {
    -- x, y, z, rotation, interior
    {2815.316, 2360.566, 10.82}, -- spawn 1
    {2854.35, 2360.676, 10.82}, -- spawn 2
}

s_duelSpawns5 = {
    -- x, y, z, rotation, interior
    {2555.113, 2782.376, 10.82}, -- spawn 1
    {2556.253, 2740.949, 10.813}, -- spawn 2
}




function getDuelSpawns(map)
    if map == "random" then
    local map2 = math.random(1,5)
	if map2 == 1 then
    return s_duelSpawns1
	elseif map2 == 2 then
	return s_duelSpawns2 
	elseif map2 == 3 then
	return s_duelSpawns3
	elseif map2 == 4 then
	return s_duelSpawns4
	elseif map2 == 5 then
	return s_duelSpawns5
	end
elseif map == "harita1" then
    return s_duelSpawns1
elseif map == "harita2" then
	return s_duelSpawns2 
elseif map == "harita3" then
	return s_duelSpawns3
elseif map == "harita4" then
	return s_duelSpawns4
elseif map == "harita5" then
	return s_duelSpawns5
end
end

function getFreeDuelDimension()
    count = 1
    for i,v in pairs(getElementsByType('player')) do
        if getElementInterior(v) == 3 then
            if getElementDimension(v) == count then
                count = count+1
            end
        end
    end
    return count
end

function getDuelWeapons()
    return s_WeaponIDs or {}
end

function getMaxDuelRounds()
    local max = tonumber(s_MaxRounds) or 5
    return max
end