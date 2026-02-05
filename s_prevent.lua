function getPlayerFromPartialName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end

addEventHandler('onResourceStart', getResourceRootElement(getThisResource()), function()
    local lista = getElementsByType('player')
        for i,j in ipairs(lista) do 
            local conta = getAccountName(getPlayerAccount(j))
            if isObjectInACLGroup ("user."..conta, aclGetGroup ("Admin")) or isObjectInACLGroup ("user."..conta, aclGetGroup ("Console")) then        
                outputChatBox('Utilize os comandos:', j, 230,30,30, true)
                outputChatBox('Script desenvolvido por #29e014Rougue#8075', j, 230,30,30, true)
                outputChatBox('--------------------------------------------', j, 230,30,30)
                        
                outputChatBox('/wall --> Comando usado para ligar o wall hack', j, 230,230,230)
                outputChatBox('/spec [jogador]--> para telar outro jogar e ainda funcionar o wallhack, se telar usando o spec do painel não funciona!!', j, 230,230,230)
                outputChatBox('/spec --> para sair do spec', j, 230,230,230)
                outputChatBox('/name --> Copia o nick do jogador no ctrl + v se o nick do cara for muito complicado ', j, 230,230,230)
                outputChatBox('/spechelp --> Mostra esses comandos ', j, 230,230,230)
                outputChatBox('--------------------------------------------\n', j, 230,30,30)
            end
        end
end)

addEventHandler('onPlayerQuit', root, function() -- prevent eventual memory leak
    for i, j in pairs(control) do
        for a, b in pairs(j) do
            if a == source then
                control[i][a] = nil
            end
        end
    end
end)

local control = {
    wall = {},
    spec = {}
}

local function AtivaWall(Player, comando)
    if not client then
        client = Player
    end
    local conta = getAccountName(getPlayerAccount(client))
    if isObjectInACLGroup ("user."..conta, aclGetGroup ("Admin"))  then
        if not control.wall[client] then
            control.wall[client] = true
            triggerClientEvent(client, 'nametags:prevent', client, true)
            local jogadores = getElementsByType('Player')
            outputServerLog(getPlayerName(client).. ' ativou o wall')
        else
            control.wall[client] = nil
            local jogadores = getElementsByType('Player')
            outputServerLog(getPlayerName(client) .. ' desativou o wall')
            triggerClientEvent(client, 'nametags:prevent', client, false)
            return
        end
    end
end

addEvent('nametags:prevent:server', true)
addEventHandler('nametags:prevent:server', root, AtivaWall)

addCommandHandler('wall', AtivaWall, false, false)

function spec (staff, comando, player)
    local conta = getAccountName(getPlayerAccount(staff))
    if isObjectInACLGroup ("user."..conta, aclGetGroup ("Admin")) or isObjectInACLGroup ("user."..conta, aclGetGroup ("Console")) then
        if player == nil then
            if isElementFrozen(staff) then
                setElementFrozen(staff, false)
                if isPedInVehicle(staff) then
                    local vehicle = getPedOccupiedVehicle(staff)
                    setElementFrozen(vehicle, false)
                end -- caso o player que o staff estiver telando de disconnect
            end
            if (getCameraTarget(staff) == staff) then
                outputChatBox('Você não está telando ninguém', staff, 230, 30, 30)
                return
            end
            local spectado = getCameraTarget(staff)
            triggerClientEvent(spectado, 'camera:cords', staff, false)
            control.spec[staff] = nil
            setElementAlpha(staff, 255)
            setCameraTarget(staff, staff)
            setElementFrozen(staff, false)
            if isPedInVehicle(staff) then
                local vehicle = getPedOccupiedVehicle(staff)
                setElementFrozen(vehicle, false)
            end
            return
        else
            spectado = getPlayerFromPartialName(player)
            if getCameraTarget(staff) == spectado then 
                return
            else
                if spectado == staff then
                    outputChatBox('você não pode telar você mesmo', staff)
                    return
                end
                triggerClientEvent(getCameraTarget(staff), 'camera:cords', staff, false)
            end
        end 
        if not isElement(spectado) then
            outputChatBox('Digite o nick parcial de um jogador ou /spec para parar de telar', staff, 230, 30, 30)
            return
        end
        if isPedInVehicle(staff) then
            local vehicle = getPedOccupiedVehicle(staff)
            setElementFrozen(vehicle, true)
        end
        setElementFrozen(staff, true)
        setCameraTarget(staff, spectado)
        triggerClientEvent(spectado, 'camera:cords', staff, true)
        control.spec[staff] = true
        setElementAlpha(staff, 0)
        outputChatBox('Digite /spec para parar de telar jogador: '.. getPlayerName(spectado), staff, 30, 230, 30)
    end
end

local function staffCam(data, staff)
    if not isElement(staff) then
        return
    end
    local conta = getAccountName(getPlayerAccount(staff))
    if data and isElement(staff) and (isObjectInACLGroup ("user."..conta, aclGetGroup ("Admin")) or isObjectInACLGroup ("user."..conta, aclGetGroup ("Console")) ) then
        triggerClientEvent(staff, 'camera:setTarget', resourceRoot, data)
    end
    if not isObjectInACLGroup ("user."..conta, aclGetGroup ("Admin")) or not isObjectInACLGroup ("user."..conta, aclGetGroup ("Console")) then
        banPlayer(staff, true, false, true, 'Server', 'Banido por tentar burlar o sistema de espectate.', 0)
    end
end

addEvent('camera:cords:server', true)
addEventHandler('camera:cords:server', root, staffCam)

addCommandHandler('spec', spec, false, false)

addCommandHandler('name', function(staff)
    local conta = getAccountName(getPlayerAccount(staff))
    if isObjectInACLGroup ("user."..conta, aclGetGroup ("Admin")) or isObjectInACLGroup ("user."..conta, aclGetGroup ("Console")) then    
        if (getCameraTarget(staff) == staff) or getPedOccupiedVehicle(staff) == getCameraTarget(staff) then
            outputChatBox('Você não está telando ninguem', staff, 230, 30, 30)
            return 
        end
        triggerClientEvent(staff, 'copiar:nome', staff, getPlayerName(getCameraTarget(staff)))
    end
end, false, false)

addCommandHandler('spechelp', function(j)
    local conta = getAccountName(getPlayerAccount(j))
    if isObjectInACLGroup ("user."..conta, aclGetGroup ("Admin")) or isObjectInACLGroup ("user."..conta, aclGetGroup ("Console")) then
        outputChatBox('Utilize os comandos: \n', j, 230,30,30, true)
                outputChatBox('--------------------------------------------', j, 230,30,30)
                        
                outputChatBox('/wall --> Comando usado para ligar o wall hack', j, 230,230,230)
                outputChatBox('/wall 0 --> Comando para desligar o wallhack', j, 230,230,230)
                outputChatBox('/spec [jogador]--> para telar outro jogar e ainda funcionar o wallhack, se telar usando o spec do painel não funciona!!', j, 230,230,230)
                outputChatBox('/spec --> para sair do spec', j, 230,230,230)
                outputChatBox('/name --> Copia o nick do jogador no ctrl + v se o nick do cara for muito complicado ', j, 230,230,230)
                outputChatBox('--------------------------------------------\n', j, 230,30,30)

    end
end)