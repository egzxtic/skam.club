const { Client, GatewayIntentBits } = require('discord.js')
const client = new Client({
    intents: [
        GatewayIntentBits.Guilds,
        GatewayIntentBits.GuildMembers,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.MessageContent
    ]
})
const { guilds } = client;

exports("getPremiumRanks", async (discordid) => {
    try {
        const guild = guilds.cache.get(a_queue.serverID);
        let member = await guild.members.fetch(discordid)
        if (member) {
            let ranks = []
            for (let index = 0; index < member._roles.length; index++) {
                const role = member._roles[index];
                if (a_queue.ranks[role]) {
                    ranks.push(role);
                }
            }
            if (ranks.length == 0) {
                ranks = null
            }
            return ranks
        } else {
            return null
        }
    } catch (error) {
        return false
    }

});

client.on('ready', () => {
    console.log(`Logged in as ${client.user.tag}!`);
});

client.on("error", error => {
    console.log("skam-queue JS ERROR: ",error)
})

client.on('shardError', error => {
	console.error('JS A websocket connection encountered an error:', error);
});

client.login(a_queue.botToken);