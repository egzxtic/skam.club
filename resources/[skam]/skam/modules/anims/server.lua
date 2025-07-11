RegisterNetEvent('skam-anims:syncAccepted', function(requester, id)
    local accepted = source
    
    TriggerClientEvent('skam-anims:playSynced', accepted, requester, id, 'Accepter')
    TriggerClientEvent('skam-anims:playSynced', requester, accepted, id, 'Requester')
end)

RegisterNetEvent('skam-anims:requestSynced', function(target, id)
    local requester = source

	TriggerClientEvent('skam:showNotification', requester, 'Wysłano propozycję animacji do '..target, 'success')
	TriggerClientEvent('skam-anims:syncRequest', target, requester, id)
end)

RegisterNetEvent('skam-anims:cancelSync', function(requester)
	TriggerClientEvent('skam:showNotification', requester, 'Osoba odrzuciła propozycję wspólnej animacji', 'info')
end)

RegisterNetEvent('skam-anims:requestSyncedCarry', function(target, carryType)
    TriggerClientEvent('skam-anims:requestClientSyncedCarry', target, source, carryType)
end)

RegisterNetEvent('skam-anims:answerSyncedCarry', function(sender, carryType)
    TriggerClientEvent('skam-anims:playSyncedCarry', sender, source, carryType, 'sender')
    TriggerClientEvent('skam-anims:playSyncedCarry', source, sender, carryType)
end)

RegisterNetEvent('skam-anims:cancelSyncedCarry', function(target)
    TriggerClientEvent('skam-anims:cancelClientSyncedCarry', target)
end)