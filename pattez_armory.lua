print("Loaded pattez_armory");

-- Todo
--

if pattez_armory == nil then
  pattez_armory = {}
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function (_, event, args)
  if event == "UPDATE_MOUSEOVER_UNIT" then
    if UnitExists("mouseover") and UnitIsPlayer("mouseover") then
    local name = UnitName("mouseover")
    local level = UnitLevel("mouseover")
    local realm = GetRealmName()
    local guildName, guildRankName, guildRankIndex = GetGuildInfo("mouseover")
    local race = UnitRace("mouseover")
    local gender = UnitSex("mouseover")
      NotifyInspect("mouseover")
      local items = {}
      for i = 0, 19 do
        local id = GetInventoryItemID("mouseover", i)
        items[#items+1] = {slotId = i, itemId = id}
      end
      pattez_armory[#pattez_armory+1] = {realm = realm, name = name, guild = guildName, race = race, gender = gender, guildRank = guildRankName, level = level, items = items}
    end
  end
end)

f:RegisterEvent("INSPECT_READY")
f:RegisterEvent("PLAYER_TARGET_CHANGED")
f:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("ADDON_LOADED");
