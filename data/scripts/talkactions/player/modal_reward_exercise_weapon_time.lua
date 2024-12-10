local config = {
    items = {
        { id = 35284 },
        { id = 35279 },
        { id = 35281 },
        { id = 35283 },
        { id = 35282 },
        { id = 35280 },
        { id = 44066 },
    },
    storage = tonumber(Storage.PlayerWeaponReward), -- Storage
    cooldown = 24 * 60 * 60, -- 24 Horas em segundos
    charges = 8000 -- Total de charges para todos os itens
}

local function sendExerciseRewardModal(player)
    local window = ModalWindow({
        title = "Exercise Reward",
        message = "Choose an item",
    })
    for _, it in pairs(config.items) do
        local iType = ItemType(it.id)
        if iType then
            window:addChoice(iType:getName(), function(player, button, choice)
                if button.name ~= "Select" then
                    return true
                end

                local inbox = player:getStoreInbox()
                local inboxItems = inbox:getItems()
                if inbox and #inboxItems < inbox:getMaxCapacity() and player:getFreeCapacity() >= iType:getWeight() then
                    local item = inbox:addItem(it.id, config.charges)
                    if item then
                        item:setActionId(IMMOVABLE_ACTION_ID)
                        item:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
                        item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, string.format("You won this exercise weapon as a reward to be a %s player. Use it in a dummy!\nHave a nice game.", configManager.getString(configKeys.SERVER_NAME)))
                    else
                        player:sendTextMessage(MESSAGE_LOOK, "You need to have capacity and empty slots to receive.")
                        return
                    end
                    player:sendTextMessage(MESSAGE_LOOK, string.format("Congratulations, you received a %s with %i charges in your store inbox.", iType:getName(), config.charges))
                    player:setStorageValue(config.storage, os.time()) -- Save current timestamp
                else
                    player:sendTextMessage(MESSAGE_LOOK, "You need to have capacity and empty slots to receive.")
                end
            end)
        end
    end
    window:addButton("Select")
    window:addButton("Close")
    window:setDefaultEnterButton(0)
    window:setDefaultEscapeButton(1)
    window:sendToPlayer(player)
end

local exerciseRewardModal = TalkAction("!reward")
function exerciseRewardModal.onSay(player, words, param)
    if not configManager.getBoolean(configKeys.TOGGLE_RECEIVE_REWARD) or player:getTown():getId() < TOWNS_LIST.AB_DENDRIEL then
        return true
    end

    local lastRewardTime = player:getStorageValue(config.storage)
    if lastRewardTime > 0 then
        local timeSinceLastReward = os.time() - lastRewardTime
        if timeSinceLastReward < config.cooldown then
            local hoursRemaining = math.ceil((config.cooldown - timeSinceLastReward) / 3600)
            player:sendTextMessage(MESSAGE_LOOK, "You need to wait another " .. hoursRemaining .. " hour(s) to use this command again.")
            return true
        end
    end

    sendExerciseRewardModal(player)
    return true
end

exerciseRewardModal:separator(" ")
exerciseRewardModal:groupType("normal")
exerciseRewardModal:register()