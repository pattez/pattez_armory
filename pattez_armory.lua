print("[pattez_armory] loaded")
local scanned = 0

if pattez_armory == nil then
  pattez_armory = {}
end

local lastGUID = false

local f = CreateFrame("Frame")
f:SetScript("OnEvent", function (self, event, ...)
	  self[event](self, ...)
end)

local inspectTarget
local tryAgain = true

MyAddOn = LibStub("AceAddon-3.0"):NewAddon("MyAddOn", "AceTimer-3.0")

local function postHook(typeID, index)
  lastGUID = UnitGUID(typeID)
end

hooksecurefunc("NotifyInspect", postHook);


function MyAddOn:TimerFeedback()
  if tryAgain then
    inspectTarget = true
    NotifyInspect("target")
    MyAddOn:ScheduleTimer("TimerFeedback", 1)
  end
end

function f:INSPECT_READY(guid)
  if lastGUID == guid and inspectTarget then -- If this is the unit we requested information for,
    inspectTarget = false
    local name = UnitName("target")
    local level = UnitLevel("target")
    local playerName = UnitName("player")
    local localizedClass, englishClass, classIndex = UnitClass("target")
    local realm = GetRealmName()
    local guildName, guildRankName, guildRankIndex = GetGuildInfo("target")
    local race, raceFile, raceIndex = UnitRace("target")
    local gender = UnitSex("target")
    local date = date("%Y-%m-%d %H:%M:%S")
    local itemString = ""
    local enchantString = ""
    local enchantSlots = {1, 3, 5, 7, 8, 9, 10, 15, 16, 17, 18}
      for i = 1, 19 do
        local id = GetInventoryItemID("target", i)

        for j = 1, #enchantSlots do
          if i == enchantSlots[j] then
            local itemLink = GetInventoryItemLink("target", i)
            local itemLinkString = tostring(itemLink)
            local _, itemId, enchantId = strsplit(":", itemLinkString)
            if enchantId == "" or enchantId == nil then
              enchantString = enchantString .. "," .. "nil"
            else
              enchantString = enchantString .. "," .. enchantId
            end
          end
        end
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
      local formatted = format('%s,%s,%s,%s,%s,%s,%s,%s,%s,%s%s%s', playerName or "nil", date or "nil", realm or "nil", name or "nil", guildName or "nil", guildRankName or "nil", level or "nil", classIndex or 'nil', raceIndex or "nil", gender or "nil",  itemString or 'nil', enchantString or 'nil')
    if #pattez_armory >= 500 then
      if scanned == 50 then
        print("[pattez_armory] has scanned too many players. Close all WoW clients and upload.")
        scanned = 0
      end
    elseif index > 0 and playerIndex == 0 then
      print("[pattez_armory]:", "Sucessfully updated: " .. name)
      pattez_armory[index] = formatted
    elseif playerIndex > 0 then
      print("[pattez_armory]:", "Sucessfully updated: " .. name)
        pattez_armory[playerIndex] = formatted
    else
        print("[pattez_armory]:", "Sucessfully inspected: " .. name)
        tinsert(pattez_armory, formatted)
      end
    tryAgain = false
	end
end

function f:PLAYER_TARGET_CHANGED(guid)
  inspectTarget = true
  tryAgain = true
  NotifyInspect("target")
  MyAddOn:ScheduleTimer("TimerFeedback", 0.5)
end

f:RegisterEvent("INSPECT_READY")
f:RegisterEvent("PLAYER_TARGET_CHANGED")

