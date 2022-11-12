ESX = nil
local currentAdminPlayers = {}
local owned = false
local ownedGroup

local draw = false
local visiblePlayers = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('relisoft_tag:owned')
AddEventHandler('relisoft_tag:owned',function(own,group)
    owned = own
    if own then
        ownedGroup = group
        --TriggerEvent('chat:addMessage', { args = { 'Server » ', 'Právě jste si zapnul tag' }, color = { 255, 50, 50 } })
		exports['mythic_notify']:DoHudText('success', 'Právě jsi si zapnul tag!')
    else
       -- TriggerEvent('chat:addMessage', { args = { 'Server » ', 'Váš tag je vypnutý' }, color = { 255, 50, 50 } })
		exports['mythic_notify']:DoHudText('error', 'Váš tag je vypnutý!')
    end
end)

RegisterNetEvent('relisoft_tag:set_admins')
AddEventHandler('relisoft_tag:set_admins',function (admins)
    currentAdminPlayers = admins
    for id,admin in pairs(currentAdminPlayers) do
        if admins[id] == nil then
            currentAdminPlayers[id] = nil
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded',function()
    ESX.TriggerServerCallback('relisoft_tag:getAdminsPlayers',function(admins)
        currentAdminPlayers = admins
    end)
end)

local function RGBRainbow( frequency )
	local result = {}
	local curtime = GetGameTimer() / 1000

	result.r = math.floor( math.sin( curtime * frequency + 0 ) * 127 + 128 )
	result.g = math.floor( math.sin( curtime * frequency + 2 ) * 127 + 128 )
	result.b = math.floor( math.sin( curtime * frequency + 4 ) * 127 + 128 )
	
	return result
end


Citizen.CreateThread(function ()

    while true do
      --  Citizen.Wait(0)
local sleep = 500
        local currentPed = PlayerPedId()
        local currentPos = GetEntityCoords(currentPed)

        local cx,cy,cz = table.unpack(currentPos)
        cz = cz + 0.9

        if owned then
            sleep = 5
            DrawText3D(cx,cy,cz, 'ADMINISTRATOR')
        end

        for k, v in pairs(currentAdminPlayers) do
            local adminId = GetPlayerFromServerId(v.source)
            local adminPed = GetPlayerPed(adminId)
            local adminCoords = GetEntityCoords(adminPed)
            local x,y,z = table.unpack(adminCoords)
            z = z + 0.9

            if adminId ~= -1 then 
                local distance = GetDistanceBetweenCoords(vector3(cx,cy,cz), x,y,z, true)
                local label = Config.GroupLabels[v.group]
                if label then
                    sleep = 5
                    if distance < 25 then
                        DrawText3D(x, y, z, label)
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end

end)



function DrawText3D(x,y,z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local p = GetGameplayCamCoords()
	local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
	local scale = (1 / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov
    	local rainbow = RGBRainbow( 1 )
	if onScreen then
		  SetTextScale(0.35, 0.30)
		  SetTextFont(13)
		  SetTextProportional(1)
		  SetTextOutline()
         
          SetTextColour(255,255, 255, 215)
		  SetTextDropshadow(10, 100, 100, 100, 255)
		  SetTextEntry("STRING")
		  SetTextCentre(1)
		  AddTextComponentString(text)
		  DrawText(_x,_y)
		  local factor = (string.len(text)) / 230
		  DrawRect(_x,_y+0.012, 0.040+ factor, 0.030, rainbow.r, rainbow.g, rainbow.b, 150)
	  end
end

RegisterNetEvent('relisoft_players:drawText')
AddEventHandler('relisoft_players:drawText',function()
    if draw then
        draw = false
        --exports['mythic_notify']:DoHudText('error', 'ID jsou vypnutá' )
        --exports['drc_notify']:Icon("ID jsou vypnutá","top-right",2500,"red-10","white",true,"mdi-earth")


       -- TriggerEvent('chat:addMessage', { args = { 'Uživatelé', 'Vypínám sledování - nyní nebudete videt uživatelské nicky, zapněte pomocí /users' }, color = { 255, 50, 50 } })
    else
        draw = true
        --TriggerEvent('chat:addMessage', { args = { 'Uživatelé', 'Zapínám sledování - nyní budete videt uživatelské nicky, vypněte pomocí /users' }, color = { 255, 50, 50 } })
        --exports['mythic_notify']:DoHudText('success', 'ID jsou zapnutá' )
       -- exports['drc_notify']:Icon("ID jsou zapnutá","top-right",2500,"red-10","white",true,"mdi-earth")
    end
end)

function draw3DText(pos, text, options)
    options = options or { }
    local color = options.color or {r = 255, g = 255, b = 255, a = 255}
    local scaleOption = options.size or 1.8

    local camCoords      = GetGameplayCamCoords()
    local dist           = #(vector3(camCoords.x, camCoords.y, camCoords.z)-vector3(pos.x, pos.y, pos.z))
    local scale = (scaleOption / dist) * 2
    local fov   = (1 / GetGameplayCamFov()) * 100
    local scaleMultiplier = scale * fov
    SetDrawOrigin(pos.x, pos.y, pos.z, 0);
    SetTextProportional(0)
    SetTextScale(0.0 * scaleMultiplier, 0.55 * scaleMultiplier)
    SetTextColour(color.r,color.g,color.b,color.a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextFont(13)
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

local function RGBRainbow( frequency )
	local result = {}
	local curtime = GetGameTimer() / 1000

	result,color.r = math.floor( math.sin( curtime * frequency + 0 ) * 127 + 128 )
	result,color.g = math.floor( math.sin( curtime * frequency + 2 ) * 127 + 128 )
	result,color.b = math.floor( math.sin( curtime * frequency + 4 ) * 127 + 128 )
    result,color.a = math.floor( math.sin( curtime * frequency + 4 ) * 127 + 128 )
	
	return result
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.NearPlayerTime or 500)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local allPlayers = GetActivePlayers()
        for _, v in pairs(allPlayers) do
            local targetPed = GetPlayerPed(v)
            local targetCoords = GetEntityCoords(targetPed)
            if #(coords-targetCoords) < 100 then
                visiblePlayers[v] = v
            end
        end
    end
end)

