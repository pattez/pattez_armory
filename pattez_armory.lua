print("Loaded pattez_armory")

-- Todo
--

if pattez_armory == nil then
  pattez_armory = {}
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function (_, event, args)
  if event == "UPDATE_MOUSEOVER_UNIT" then
    local inRange = CheckInteractDistance("mouseover", 3)
    if UnitExists("mouseover") and UnitIsPlayer("mouseover") and inRange then
    local name = UnitName("mouseover")
    local level = UnitLevel("mouseover")
    local playerName = UnitName("player")
    local realm = GetRealmName()
    local guildName, guildRankName, guildRankIndex = GetGuildInfo("mouseover")
    local race = UnitRace("mouseover")
    local gender = UnitSex("mouseover")
    local date = date("%Y-%m-%d %H:%M:%S")
      NotifyInspect("mouseover")
      local itemString = ""
      for i = 1, 19 do
        local id = GetInventoryItemID("mouseover", i)
        id = tostring(id)
        itemString = itemString .. "," .. id
      end
      tinsert(pattez_armory, format('%s,%s,%s,%s,%s,%s,%s,%s,%s%s', playerName or "nil", date or "nil", realm or "nil", name or "nil", guildName or "nil", guildRankName or "nil", level or "nil", race or "nil", gender or "nil",  itemString or 'nil'))
      ClearInspectPlayer()
    end
  end
end)

f:RegisterEvent("INSPECT_READY")
f:RegisterEvent("PLAYER_TARGET_CHANGED")
f:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
f:RegisterEvent("ADDON_LOADED")
