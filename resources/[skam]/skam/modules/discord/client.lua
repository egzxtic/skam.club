local discordData = {
    app = '1365522455447208096',
    img = 'skam',
    playerCount = 0
}

Citizen.CreateThread(function()
	while true do
		SetDiscordAppId(discordData.app)
        SetRichPresence(string.format('%s, %s GRACZY', GetPlayerName(PlayerId()), discordData.playerCount))
        SetDiscordRichPresenceAsset(discordData.img)
        SetDiscordRichPresenceAssetText(string.format('ID: %s', GetPlayerServerId(PlayerId())))
        SetDiscordRichPresenceAssetSmall('skamclub')
        SetDiscordRichPresenceAssetSmallText('skam.club')
        SetDiscordRichPresenceAction(0, 'DISCORD', 'https://dc.skam.club')
        SetDiscordRichPresenceAction(1, 'ZAGRAJ', 'fivem://connect/skam.club')
		Citizen.Wait(60000)
	end
end)