print("Loaded pattez_armory");
local f = CreateFrame("Frame")
f:SetScript("OnEvent", function (_, event, args)
  if event == "UPDATE_MOUSEOVER_UNIT" then
    if UnitExists("mouseover") and UnitIsPlayer("mouseover") then
    local name = UnitName("mouseover")
    local level = UnitLevel("mouseover")
    local realm = GetRealmName()
    local guildName, guildRankName, guildRankIndex = GetGuildInfo("mouseover")
      NotifyInspect("mouseover")
      local items = {}
      for i = 0, 19 do
        local id = GetInventoryItemID("mouseover", i)
        items[#items+1] = {slotId = i, itemId = id}
      end
      testaddon[#testaddon+1] = {realm = realm, name = name, guild = guildName, guildRank = guildRankName, level = level, items = items}
    end
  end
end)

f:RegisterEvent("INSPECT_READY")
f:RegisterEvent("PLAYER_TARGET_CHANGED")
f:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ADDON_LOADED");
