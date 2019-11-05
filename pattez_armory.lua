print("[pattez_armory] loaded")
local scanned = 0

if pattez_armory == nil then
  pattez_armory = {}
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function (_, event, args)
  if event == "UPDATE_MOUSEOVER_UNIT" then
    local inRange = CheckInteractDistance("mouseover", 3)
    local enemy = UnitIsEnemy("mouseover", "mouseover")
    if UnitExists("mouseover") and UnitIsPlayer("mouseover") and inRange and not enemy then
    local name = UnitName("mouseover")
    local level = UnitLevel("mouseover")
    local playerName = UnitName("player")
    local localizedClass, englishClass, classIndex = UnitClass("mouseover")
    local realm = GetRealmName()
    local guildName, guildRankName, guildRankIndex = GetGuildInfo("mouseover")
    local race, raceFile, raceIndex = UnitRace("mouseover")
    local gender = UnitSex("mouseover")
    local date = date("%Y-%m-%d %H:%M:%S")
      NotifyInspect("mouseover")
      local itemString = ""
      for i = 1, 19 do
        local id = GetInventoryItemID("mouseover", i)
        id = tostring(id)
        itemString = itemString .. "," .. id
      end
      scanned = scanned + 1
      local index = 0;
      local count = 0
      local playerIndex = 0
      for i = 1, #pattez_armory do
        if pattez_armory[i] and string.find(pattez_armory[i], name) then
          local _, occurence = string.gsub(pattez_armory[i], name, "")
          index = i
            if occurence == 2 then
              count = occurence
              playerIndex = i
            end
        end
      end
      local formatted = format('%s,%s,%s,%s,%s,%s,%s,%s,%s,%s%s', playerName or "nil", date or "nil", realm or "nil", name or "nil", guildName or "nil", guildRankName or "nil", level or "nil", classIndex or 'nil', raceIndex or "nil", gender or "nil",  itemString or 'nil')

    if #pattez_armory >= 500 and scanned == 50 then
      print("[pattez_armory] has scanned too many players. Close all WoW clients and upload.")
      scanned = 0
    elseif index > 0 and playerIndex == 0 then
        pattez_armory[index] = formatted
    elseif playerIndex > 0 then
        pattez_armory[playerIndex] = formatted
    else
        tinsert(pattez_armory, formatted)
    end

      ClearInspectPlayer()
    end
  end
end)

f:RegisterEvent("INSPECT_READY")
f:RegisterEvent("PLAYER_TARGET_CHANGED")
f:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
f:RegisterEvent("ADDON_LOADED")
