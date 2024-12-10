local setTierLegs = TalkAction("/settierlegs")

function setTierLegs.onSay(player, words)
    -- Obtener el ítem del slot de piernas
    local item = player:getSlotItem(CONST_SLOT_LEGS)
    if not item then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You do not have an item equipped in the legs slot.")
        return false
    end
	
	if not item:getTier() then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This item does not support tiers.")
        return false
    end

    local currentTier = item:getTier()
    local newTier = currentTier + 1
    item:setTier(newTier)

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The item's tier has been increased to " .. newTier .. ".")
    return true
end

local setTierWeapon = TalkAction("/settierhands")

function setTierWeapon.onSay(player, words)
    local item = player:getSlotItem(CONST_SLOT_RIGHT) or player:getSlotItem(CONST_SLOT_LEFT)
    if not item then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are not holding any weapon or shield in your hand slots.")
        return false
    end

    if not item:getTier() then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This item does not support tiers.")
        return false
    end

    local currentTier = item:getTier()
    local newTier = currentTier + 1
    item:setTier(newTier)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Item tier increased to " .. newTier .. ".")
    return true
end

setTierWeapon:separator(" ")
setTierWeapon:groupType("god")
setTierWeapon:register()
setTierLegs:separator(" ")
setTierLegs:groupType("god")
setTierLegs:register()