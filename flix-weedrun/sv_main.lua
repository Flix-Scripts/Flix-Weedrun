function sendDiscordWebhook(message)
    local discordWebhookUrl = ""

    local data = {
        content = message
    }

    PerformHttpRequest(discordWebhookUrl, function(err, text, headers)
    end, 'POST', json.encode(data), { ['Content-Type'] = 'application/json' })
end

lib.callback.register('weedrun:reward', function(source)
    local itemAmount = math.random(Config.Cannabis['mincannabis'], Config.Cannabis['maxcannabis'])
    local moneyAmount = math.random(Config.Cannabis['minprice'], Config.Cannabis['maxprice'])
    exports.ox_inventory:RemoveItem(source, 'cannabis', itemAmount)
    exports.ox_inventory:AddItem(source, 'money', moneyAmount)

    local playerName = GetPlayerName(source)
    local dateAndTime = os.date("%d.%m.%Y at: %H:%M")
    local discordMessage = string.format(Config.Language['logs'], playerName, itemAmount, moneyAmount, dateAndTime)
    sendDiscordWebhook(discordMessage)
end)
