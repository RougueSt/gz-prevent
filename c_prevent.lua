local data = {}
local INTERVAL = 20 --ms INCREASE TO IMPROVE PERFORMANCE
local timer = {}
local fontSize = 1 --FLOAT
local font = dxCreateFont('Lato-Thin.ttf', 9, false, 'default')


function wall(comando, arg1)
    player = getCameraTarget(localPlayer)
    if not isElement(player) then
        return
    end
    a, b, c = getElementPosition(player)
    ped = getElementsWithinRange(a, b, c, 500 , "player")
    car = getElementsWithinRange(a, b, c, 500 , "vehicle")
    for i,j in pairs(car) do
        
        x, y, z = getElementPosition(j)
        distance = getDistanceBetweenPoints3D(a,b,c, x,y,z)
        if distance < 500 then 
            Px, Py, Pz = getScreenFromWorldPosition(x, y, z)
            if Px and Py then
                dxDrawText(getVehicleName(j).. '| '.. math.floor(Pz).. 'm', Px-1, Py+2, Px, Py, tocolor(0,0,0), fontSize, font)
                dxDrawText(getVehicleName(j).. '| '.. math.floor(Pz).. 'm', Px, Py, Px, Py, tocolor(250,250,250), fontSize, font)
            end
                
        end
    end
    for i,j in pairs(ped) do
        x, y, z = getElementPosition(j)
        distance = getDistanceBetweenPoints3D(a,b,c, x,y,z)
        if distance < 500 then 
            Px, Py, Pz = getScreenFromWorldPosition(x, y, z)
            if Px and Py then
                if getPlayerTeam(j) == false then
                    r, g, b = 255, 50, 50
                else
                    r, g, b = getTeamColor(getPlayerTeam(j))
                end
                local health = getElementHealth(j)
                if getPedArmor(j) > 0 then
                    armor = getPedArmor(j)
                else
                    armor = 0
                end
                --dxDrawText(getPlayerName(j)..' | ' .. math.floor(Pz).. 'm', Px+1, Py + 7, Px, Py, tocolor(0,0,0), fontSize, font)
                if j ~= localPlayer then
                    dxDrawText(getPlayerName(j)..' | ' .. math.floor(Pz).. 'm', Px, Py + 5, Px, Py, tocolor(0, 0, 0), fontSize, "default-bold")
                    dxDrawText(getPlayerName(j)..' | ' .. math.floor(Pz).. 'm', Px-1, Py + 3, Px, Py, tocolor(r, g, b), fontSize, "default-bold")
                    dxDrawText('Health: '.. tostring(tonumber(health)) .. ' | ' .. 'Armor: ' .. tostring(tonumber(armor)), Px, Py + 22, Px, Py, tocolor(0, 0, 0), fontSize, "default-bold")
                    dxDrawText('Health: '.. tostring(tonumber(health)) .. ' | ' .. 'Armor: ' .. tostring(tonumber(armor)), Px-1, Py + 20, Px, Py, tocolor(r, g, b), fontSize, "default-bold")
                end
                --[[ dxDrawText('Player '.. '| '.. math.floor(Pz).. 'm', Px+1, Py+2 + 5, Px, Py, tocolor(0,0,0), fontSize, font)
                dxDrawText('Player '.. '| '.. math.floor(Pz).. 'm', Px, Py + 5, Px, Py, tocolor(30,230,230), fontSize, font) ]]
            end
                
        end
    end
end

local controle
function ligar(arg1)

    if not arg1 then 
        removeEventHandler('onClientPreRender', root, wall)
        controle = false
        return
    end

    if controle == true then
        return
    end
    addEventHandler('onClientPreRender', root, wall)
    controle = true

end

function camera(value)
    if value then
        timer[source] = setTimer(function(source)
            local x, y = guiGetScreenSize()
            data[1], data[2], data[3] = getWorldFromScreenPosition(x/2, y/2, 300)
            if not isElement(source) or (source == getResourceRootElement())then
                killTimer(timer[source])
                return
            end
            triggerServerEvent('camera:cords:server', root, data, source)
        end, INTERVAL, 0, source)
    else
        if isTimer(timer[source]) then
            killTimer(timer[source])
            triggerServerEvent('camera:cords:server', root, false, source)
        end
    end
end

function staffCam(data)
    setCameraTarget(data[1], data[2], data[3])
end

addEvent('camera:setTarget', true)
addEventHandler('camera:setTarget', root, staffCam)

addEvent('camera:cords', true)
addEventHandler('camera:cords', root, camera)


addEvent('nametags:prevent', true)
addEventHandler('nametags:prevent', localPlayer, ligar)


function copiarNome(stringNome)
    setClipboard(stringNome)
    outputChatBox('Nome do jogador telado copiado para o CTRL + V', 30, 230, 30)
end

addEvent('copiar:nome', true)
addEventHandler('copiar:nome',root, copiarNome)

addEventHandler('onClientPlayerSpawn', localPlayer, function()
    removeEventHandler('onClientPreRender', root, wall)
end)