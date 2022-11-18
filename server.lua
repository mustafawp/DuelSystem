db = dbConnect("sqlite","dueveriler.db")

local g_currentDuel = {}
local g_duelChallenger = {}
local g_duelChallengePrice = {}

local g_duelReady = {}
local g_duelSpawn = {}
local g_duelRound = {}
local g_duelTimer = {}
local g_duelPoint = {}
local mapi 
local g_lastPosition = {}
local g_savedWeapons = {}

kontroller = { "fire", "aim_weapon" }

addEvent('onPlayerStartDuel',true)
addEvent('onPlayerDuelReady',true)

addEvent('onDuelStarting',true)
addEvent('onDuelRoundStarting',true)
addEvent('onDuelRoundStarted',true)
addEvent('onDuelRoundEnd',true)
addEvent('onDuelEnd',true)
addEvent('onDuelEnded',true)

function challengePlayer(plr,cmd,challenger,price,maps)
    mapi = maps
    if plr and challenger then
        if isElement(g_currentDuel[plr]) then
            exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Zaten bir düellodasın!",plr,255,255,255,true)
            return
        end
        local opp = tostring(challenger)
        if opp then
            local players = getPlayersWithName(opp)
            if #players == 0 then
                exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Oyuncu bulunamadı, lütfen tekrar dene.",plr,255,255,255,true)
                return
            end
            if #players == 1 and players[1] == plr then
                exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Kendinle düelloya giremezsin, sakin..",plr,255,255,255,true)
                return
            end
            if #players > 1  then
                exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Yazdığınız isime benzer oyuncular:",plr,255,255,255,true)
                for i,v in pairs(players) do
                    exports["solyazi"]:dm(getPlayerName(v),plr,255,255,255,true)
                end
                return
            end
            if #players == 1 and players[1] ~= plr then
                local price = tonumber(price) or 0
                if price < 0 then
                    price = 0
                end
                price = math.ceil(price)
                
                if not g_duelChallenger[players[1]] then
                    g_duelChallenger[players[1]] = nil
                end
                if isElement(g_currentDuel[players[1]]) then
                    exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF oyuncu zaten düelloda",plr,255,255,255,true)
                    return
                end
                if isElement(g_duelChallenger[players[1]]) then
                    exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Zaten bu oyuncuya meydan okumuştun, daha sonra tekrar dene.",plr,255,255,255,true)
                    return
                end
                local money = getPlayerMoney(plr)
                local money2 = getPlayerMoney(players[1])
                if money >= price then
                    if money2 >= price then
                        exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF "..getPlayerName(players[1]).."#FFFFFFİsimli oyuncuya #00FF00$"..price.." için düello teklif ettin.",plr,255,255,255,true)
                        exports["solyazi"]:dm("#FF7f00[MG]#FFFFFF "..getPlayerName(plr).."#FFFFFF İsimli oyuncu seni #00FF00$"..price.." için bir düelloya davet etti.",players[1],255,255,255,true)
                        exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Düelloyu kabul etmek için /duellokabul yazmalısın.",players[1],255,255,255,true)
                        g_duelChallenger[players[1]] = plr
                        g_duelChallengePrice[players[1]] = price
                        
                        setTimer(function(plr)
                            if isElement(plr) and g_duelChallenger[plr] then
                                g_duelChallenger[plr] = nil
                            end
                        end,15000,1,players[1])
                        
                        return true
                    else
                        exports["solyazi"]:dm("#FF7f00[MG]#FFFFFF oyuncunun düelloya girebilmek için bu kadar parası yok.",plr,255,255,255,true)
                    end
                else
                    exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Düello için yeterli paran yok.",plr,255,255,255,true)
                end
            end
        end
    end
end
addCommandHandler("dusdfdsfel",challengePlayer)
addEvent("duellobaslat",true)
addEventHandler("duellobaslat", root, challengePlayer)

function acceptPlayer(plr,cmd)
    if plr then
        if isElement(g_currentDuel[plr]) then
            exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Zaten düellodasın??",plr,255,255,255,true)
            return
        end
        if isElement(g_currentDuel[g_duelChallenger[plr]]) then
            exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Bu oyuncu başka bir düelloda.",plr,255,255,255,true)
            return
        end
        if g_duelChallenger[plr] and isElement(g_duelChallenger[plr]) and getElementType(g_duelChallenger[plr]) == 'player' then
            local money = getPlayerMoney(plr)
            local money2 = getPlayerMoney(g_duelChallenger[plr])
            if money >= g_duelChallengePrice[plr] then
                if money2 >= g_duelChallengePrice[plr] then
                    exports["solyazi"]:dm("#FF7F00[MG] #FFFFFF"..getPlayerName(g_duelChallenger[plr]).." 'in#FFFFFF düello isteğini kabul ettin!",plr,255,255,255,true)
                    exports["solyazi"]:dm("#FF7F00[MG] #FFFFFF"..getPlayerName(plr).."#FFFFFF Senin düello isteğini kabul etti.",g_duelChallenger[plr],255,255,255,true)
                    
                    g_currentDuel[plr] = g_duelChallenger[plr]
                    g_currentDuel[g_duelChallenger[plr]] = plr
                    
                    g_duelReady[plr] = nil
                    g_duelReady[g_duelChallenger[plr]] = nil
                    
                    g_duelChallengePrice[g_duelChallenger[plr]] = g_duelChallengePrice[plr]
                   
                    triggerEvent('onPlayerStartDuel',plr)
                    triggerEvent('onPlayerStartDuel',g_duelChallenger[plr])
                    
                    g_duelChallenger[plr] = nil
                    
                    return true
                else
                    exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Davet gönderdiğiniz kişinin, turnuva için yeterli parası yok.",plr,255,255,255,true)
                end
            else
                exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Düelloya katılmak için yeterli paranız yok.",plr,255,255,255,true)
            end
        else
            exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Rakip Bulunamadı.",plr,255,255,255,true)
        end
    end
end
addCommandHandler("duellokabül",acceptPlayer)
addCommandHandler("duellokabul",acceptPlayer)

function endDuel(plr)
    if plr and isElement(plr) and getElementType(plr) == 'player' then
        takeAllWeapons(plr)
        
        local s1 = g_lastPosition[plr]
        local spawn1 = spawnPlayer(plr,s1.x,s1.y,s1.z,s1.rot,s1.skin,s1.int,s1.dim)
        
        local w1 = g_savedWeapons[plr]
        if spawn1 then
            for wep,ammo in pairs(w1) do
                giveWeapon(plr,wep,ammo)
            end
        end
        
       
        g_currentDuel[plr] = nil
        
        g_duelChallenger[plr] = nil
        
        g_duelReady[plr] = nil
        
        g_duelRound[plr] = 0
        
        g_duelPoint[plr] = 0
        
        g_duelTimer[plr] = nil
        
        g_lastPosition[plr] = nil
        
        g_savedWeapons[plr] = nil
        
        g_duelChallengePrice[plr] = nil
        
        fadeCamera(plr,true)
        
        triggerEvent("onDuelEnded",plr)
        triggerClientEvent(plr,'onDuelEnded',plr)
        return true
    end
end

addEventHandler('onPlayerStartDuel',root,
    function()
        local x,y,z = getElementPosition(source)
        local int,dim = getElementInterior(source), getElementDimension(source)
        local rx,ry,rz = getElementRotation(source)
        local skin = getElementModel(source) or 0
        local weapons = getWeapons(source) or {}
        g_lastPosition[source] = {x=x,y=y,z=z,int=int,dim=dim,rot=rz,skin=skin}
        g_savedWeapons[source] = weapons
        takeAllWeapons(source)
        setPlayerMoney(source,getPlayerMoney(source)-g_duelChallengePrice[source])
        
        fadeCamera(source,false)
        g_duelReady[source] = true
        
        triggerClientEvent(source,'onClientPlayerStartDuel',source)
        triggerEvent('onPlayerDuelReady',source)
    end
)

addEventHandler('onPlayerDuelReady',root,
    function()
        local opp = g_currentDuel[source]
        if opp and isElement(opp) then
            if g_duelReady[opp] == true then
                exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Düello Başlamak Üzere! Bol şans..",source,255,255,255,true)
                exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Düello Başlamak Üzere! Bol şans..",opp,255,255,255,true)
                triggerEvent("onDuelStarting",resourceRoot,source,opp)
            else
                exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Rakip Bekleniyor..",source,255,255,255,true)
            end
        end
    end
)

addEventHandler('onDuelStarting',root,
    function(plr1,plr2)
        local position = getDuelSpawns(mapi)
        local dimension = getFreeDuelDimension()
        
        if position and dimension then
            
            local skin1 = getElementModel(plr1) or 0
            local skin2 = getElementModel(plr2) or 0
            
            local pos1 = {x=tonumber(position[1][1]),y=tonumber(position[1][2]),z=tonumber(position[1][3]),rot=tonumber(position[1][4]),int=tonumber(position[1][5]),dim=tonumber(dimension),skin=skin1}
            local pos2 = {x=tonumber(position[2][1]),y=tonumber(position[2][2]),z=tonumber(position[2][3]),rot=tonumber(position[2][4]),int=tonumber(position[2][5]),dim=tonumber(dimension),skin=skin2}
            
            if pos1 and pos2 then
                g_duelSpawn[plr1] = pos1
                g_duelSpawn[plr2] = pos2
                
                g_duelRound[plr1] = 0
                g_duelRound[plr2] = g_duelRound[plr1]
                
                g_duelPoint[plr1] = 0
                g_duelPoint[plr2] = 0
                
                triggerEvent('onDuelRoundStarting',resourceRoot,plr1,plr2)
                fadeCamera(plr1,true)
                fadeCamera(plr2,true)
            end
        end
    end
)

addEventHandler('onDuelRoundStarting',root,
    function(plr1,plr2)
    
        g_duelRound[plr1] = g_duelRound[plr1]+1
        g_duelRound[plr2] = g_duelRound[plr1]
        
        exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF RAUND: "..g_duelRound[plr1].." BAŞLIYOR!",plr1,255,127,0,true)
        exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF RAUND: "..g_duelRound[plr1].." BAŞLIYOR!",plr2,255,127,0,true)
        
        if g_duelSpawn[plr1] and g_duelSpawn[plr2] then
            local s1 = g_duelSpawn[plr1]
            local s2 = g_duelSpawn[plr2]
            local spawn1 = spawnPlayer(plr1,s1.x,s1.y,s1.z,s1.rot,s1.skin,s1.int,s1.dim)
            local spawn2 = spawnPlayer(plr2,s2.x,s2.y,s2.z,s2.rot,s2.skin,s2.int,s2.dim)
            if spawn1 and spawn2 then
            
                takeAllWeapons(plr1)
                takeAllWeapons(plr2)
                
                local duelWeps = getDuelWeapons() or {}
                for wep,ammo in pairs(duelWeps) do
                    local newWep = tonumber(wep) or 0
                    local newAmmo = tonumber(ammo) or 0
                    giveWeapon(plr1,newWep,newAmmo)
                    giveWeapon(plr2,newWep,newAmmo)
                end
                
                setElementFrozen(plr1,true)
                setElementFrozen(plr2,true)
                
                fadeCamera(plr1,true)
                fadeCamera(plr2,true)
                
                if isTimer(g_duelTimer[plr1]) then
                    killTimer(g_duelTimer[plr1])
					end
				for i,kontrl in pairs(kontroller) do toggleControl(plr2, kontrl, false) end
                for i,kontrl in pairs(kontroller) do toggleControl(plr1, kontrl, false) end
                g_duelTimer[plr1] = setTimer(function(plr1,plr2)
                    if not isElement(plr1) then
                        endDuel(plr2)
                    elseif not isElement(plr2) then
                        endDuel(plr1)
                    end
                    if isElement(plr1) and isElement(plr2) then
                        triggerEvent("onDuelRoundStarted",resourceRoot,plr1,plr2)
                    end
					for i,kontrl in pairs(kontroller) do toggleControl(plr1, kontrl, true) end
					for i,kontrl in pairs(kontroller) do toggleControl(plr2, kontrl, true) end
                end,5000,1,plr1,plr2)
                g_duelTimer[plr2] = g_duelTimer[plr1]
                local remaining = getTimerDetails(g_duelTimer[plr2])
                triggerClientEvent(plr1,getResourceName(getThisResource())..":sendTimerToClient",plr1,remaining)
                triggerClientEvent(plr2,getResourceName(getThisResource())..":sendTimerToClient",plr2,remaining)
            end
        end
    end
)

addEventHandler('onDuelRoundStarted',root,
    function(plr1,plr2)
        exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Raund Başladı! Hadi Aslan göreyim seni! #FF7F00"..getPlayerName(plr1),plr1,255,255,255,true)
        exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Raund Başladı! Hadi Göreyim Seni! #FF7F00"..getPlayerName(plr2),plr2,255,255,255,true)
        setElementFrozen(plr1,false)
        setElementFrozen(plr2,false)
    end
)

addEventHandler('onDuelRoundEnd',root,
    function(plr1,plr2)
        fadeCamera(plr1,false)
        fadeCamera(plr2,false)
        if g_duelRound[plr1] == getMaxDuelRounds() then
            triggerEvent('onDuelEnd',resourceRoot,plr1,plr2)
            return
        end
        triggerEvent('onDuelRoundStarting',resourceRoot,plr1,plr2)
    end
)

addEventHandler('onDuelEnd',root,
    function(plr1,plr2)
        takeAllWeapons(plr1)
        takeAllWeapons(plr2)
        local kisi1 = getAccountName(getPlayerAccount(plr1))
        local kisi2 = getAccountName(getPlayerAccount(plr2))
        local kisiname1 = getPlayerName(plr1)
        local kisiname2 = getPlayerName(plr2):gsub('#%x%x%x%x%x%x', '')
		kisiname1 = kisiname1:gsub('#%x%x%x%x%x%x', '')
		kisiname2 = kisiname2:gsub('#%x%x%x%x%x%x', '')
        local sonuc = g_duelPoint[plr1].." - "..g_duelPoint[plr2]
        local kazandi = "Kazandın"
        local kaybettin = "Kaybettin"
        local time = getRealTime()
        local hours = time.hour
        local minutes = time.minute
        local seconds = time.second
        local monthday = time.monthday
        local month = time.month
        local year = time.year
        local gerceksaat = string.format("%04d-%02d-%02d %02d:%02d:%02d", year + 1900, month + 1, monthday, hours, minutes, seconds)
        
        exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Düello Sona erdi!",plr1,255,255,255,true)
        exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Düello Sona erdi!",plr2,255,255,255,true)
        if g_duelPoint[plr1] > g_duelPoint[plr2] then
            dbExec(db,"INSERT INTO veriler (account,nicki,rakip,sonuc,durum,tarih) VALUES (?,?,?,?,?,?)",kisi1,kisiname1,kisiname2,sonuc,kazandi,gerceksaat)
            dbExec(db,"INSERT INTO veriler (account,nicki,rakip,sonuc,durum,tarih) VALUES (?,?,?,?,?,?)",kisi2,kisiname2,kisiname1,sonuc,kaybettin,gerceksaat)
            exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Düelloyu #FF7F00"..getPlayerName(plr1).." #FFFFFFKazandı! Tebrikler.",plr1,255,255,255,true)
            exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Düelloyu #ff7f00"..getPlayerName(plr1).."#FFFFFF Kazandı! Tebrikler.",plr2,255,255,255,true)
            setPlayerMoney(plr1,getPlayerMoney(plr1)+tonumber(g_duelChallengePrice[plr1]*2))
        elseif g_duelPoint[plr2] > g_duelPoint[plr1] then
            dbExec(db,"INSERT INTO veriler (account,nicki,rakip,sonuc,durum,tarih) VALUES (?,?,?,?,?,?)",kisi1,kisiname1,kisiname2,sonuc,kaybettin,gerceksaat)
            dbExec(db,"INSERT INTO veriler (account,nicki,rakip,sonuc,durum,tarih) VALUES (?,?,?,?,?,?)",kisi2,kisiname2,kisiname1,sonuc,kazandi,gerceksaat)
            exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Düelloyu #ff7f00"..getPlayerName(plr2).."#FFFFFF Kazandı! Tebrikler.",plr2,255,255,255,true)
            exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Düelloyu #ff7f00"..getPlayerName(plr2).."#FFFFFF Kazandı! Tebrikler.",plr1,255,255,255,true)
            setPlayerMoney(plr2,getPlayerMoney(plr2)+tonumber(g_duelChallengePrice[plr2]*2))
        elseif g_duelPoint[plr2] == g_duelPoint[plr1] then
            exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Düello berabere bitti, kazanan olmadı. Emeğinize sağlık gençler.",plr1,255,255,255,true)
            exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Düello berabere bitti, kazanan olmadı. Emeğinize sağlık gençler.",plr2,255,255,255,true)
        else
            exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Düellonun kazananı belirlenemedi.",plr1,255,255,255,true)
            exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Düellonun kazananı belirlenemedi.",plr2,255,255,255,true)
        end
        
        endDuel(plr1)
        endDuel(plr2)
        
    end
)
        
addEventHandler('onPlayerWasted',root,
    function()
        local roundWinner = g_currentDuel[source] 
        if roundWinner then
            fadeCamera(source,false)
            fadeCamera(roundWinner,false)
            if getElementHealth(roundWinner) > 0 then
                g_duelPoint[roundWinner] = g_duelPoint[roundWinner]+1
                exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Raundu #00ff4cKazandın! #ffffffDurum: (#00FF00"..g_duelPoint[roundWinner].."#FFFFFF-#FF0000"..g_duelPoint[source].."#FFFFFF)",roundWinner,255,255,255,true)
                exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Raundu #ff0000Kaybettin. #ffffffDurum: (#00FF00"..g_duelPoint[source].."#FFFFFF-#FF0000"..g_duelPoint[roundWinner].."#FFFFFF)",source,255,255,255,true)
                triggerEvent('onDuelRoundEnd',resourceRoot,roundWinner,source)
                cancelEvent()
            else
                exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Her iki oyuncuda öldü. Raund Tekrar başlatılıyor..",roundWinner,255,255,255,true)
                exports["solyazi"]:dm("#FF7F00[MG]#FFFFFF Her iki oyuncuda öldü. Raund Tekrar başlatılıyor..",source,255,255,255,true)
                g_duelRound[roundWinner] = g_duelRound[roundWinner]-1
                g_duelRound[source] = g_duelRound[roundWinner]
                triggerEvent('onDuelRoundEnd',resourceRoot,roundWinner,source)
                cancelEvent()
            end
        end
    end
)
           
addEventHandler('onVehicleEnter',root,
    function(plr)
        if g_currentDuel[plr] and isElement(g_currentDuel[plr]) then
            destroyElement(source)
        end
    end
)

addEvent(getResourceName(getThisResource())..":takeMyWepInDuel",true)
addEventHandler(getResourceName(getThisResource())..":takeMyWepInDuel",root,
    function(id)
        if id then
            if id ~= 0 and not getDuelWeapons()[id] then
                takeWeapon(source,id)
                --giveWeapon(source,31,1000)
                --giveWeapon(source,28,1000)
            end
        end
    end
)

addEvent(getResourceName(getThisResource())..":destroyVehicleInDuel",true)
addEventHandler(getResourceName(getThisResource())..":destroyVehicleInDuel",root,
    function(veh)
        if veh and isElement(veh) then
            destroyElement(veh)
        end
    end
)


addEventHandler('onPlayerQuit',root,
    function()
        local opp = g_currentDuel[source]
        if opp then
            local money = tonumber(g_duelChallengePrice[opp])
            if money then
                setPlayerMoney(opp,getPlayerMoney(opp)+tonumber(money*2))
            end
            endDuel(opp)
        end
    end
)    

function isPlayerInDuel(plr)
    if plr and isElement(plr) and getElementType(plr) == 'player' then
        if g_currentDuel[plr] then
            return true
        end
    end
end

local kisi

function gecmis(veriler)
	local result = dbPoll(veriler, 0)
    triggerClientEvent(kisi,"gecmislistes",kisi,result)
end

addEvent("gecmisilistele",true)
addEventHandler("gecmisilistele",root,function()
    local hesap = getAccountName(getPlayerAccount(source))
    kisi = source
    dbQuery(gecmis,db,"SELECT * FROM veriler WHERE account = ? ",hesap)
end)