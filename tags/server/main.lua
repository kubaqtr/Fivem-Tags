ESX = nil
AdminPlayers = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('tag', function(source,args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()
    if group ~= 'user' then
        if AdminPlayers[source] == nil then
            AdminPlayers[source] = {source = source, group = group}

            TriggerClientEvent('chat:addMessage',source, { args = { 'Tag', ' Právě jste si zapl tag' }, color = { 255, 50, 50 } })
        else
            AdminPlayers[source] = nil
            TriggerClientEvent('chat:addMessage',source, { args = { 'Tag', ' Právě jste si vypnul tag' }, color = { 255, 50, 50 } })
        end
        TriggerClientEvent('relisoft_tag:set_admins',-1, AdminPlayers)
    else
        TriggerClientEvent('chat:addMessage', source, { args = { 'Tag', ' K tomuto nemáte oprávnění' }, color = { 255, 50, 50 } })
    end
end)

ESX.RegisterServerCallback('relisoft_tag:getAdminsPlayers',function(source,cb)
    cb(AdminPlayers)
end)

AddEventHandler('esx:playerDropped', function(source)
    if AdminPlayers[source] ~= nil then
        AdminPlayers[source] = nil
    end
    TriggerClientEvent('relisoft_tag:set_admins',-1,AdminPlayers)
end)