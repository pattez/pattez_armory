PATTEZ_ARMORY_VERSION = GetAddOnMetadata("pattez_armory", "Version");

target = nil
inspectStage = 0

lastTarget = nil
inspectTime = nil
inspecting = nil
inspectAgain = nil
scanned = 0

if pattez_armory == nil then
  pattez_armory = {}
end


function export (editBox)
  if #pattez_armory and #pattez_armory >= 1 then
    DEFAULT_CHAT_FRAME:AddMessage("pattez_armory: Exporting...")
    local export_string = ""
    export_string = table.concat(pattez_armory, "z27e8")
    export_string = "version" .. PATTEZ_ARMORY_VERSION .. "," .. export_string
    editBox:SetText(export_string)
    editBox:Show()
    editBox:HighlightText()
  else
    DEFAULT_CHAT_FRAME:AddMessage("pattez_armory: No data to export")
  end

end


function PATTEZ_ARMORY_EDITBOX_ONLOAD (editBox)
  DEFAULT_CHAT_FRAME:AddMessage("Loaded", editBox)
  SLASH_PATTEZARMORY1 = "/pa";
  SLASH_PATTEZARMORY2 = "/paexport";
  SlashCmdList["PATTEZARMORY"] = function(msg)
    export(editBox)
  end

  editBox:SetScript("OnEnterPressed", function(this)
    this:Hide()
    pattez_armory = {}
    DEFAULT_CHAT_FRAME:AddMessage("pattez_armory: Succesfully exported...")
  end)
end

function PATTEZ_ARMORY_ONLOAD ()
  DEFAULT_CHAT_FRAME:AddMessage("(https://classicarmory.org) pattez_armory version " .. PATTEZ_ARMORY_VERSION .." loaded.")
end

local function postHook(typeID, index)
  inspectDone()
  local time = GetTime()
  inspectTime = math.floor(time)
  inspectAgain = true
end

hooksecurefunc("InspectUnit", postHook)


function PATTEZ_ARMORY_ONUPDATE ()
  local time = GetTime()
  local time_S = math.floor(time)
  local diff = 0
  if inspectTime then
    diff = time_S - inspectTime
  end

  if inspectAgain and diff > 0.5 then
    if CheckInteractDistance("target", 1) then
      if CanInspect("target") then
        inspectTime = nil
        inspectAgain = nil
        diff = 0
        InspectUnit("target")
        return
      end
    else
      ClearInspectPlayer()
    end
  end

  if target ~= nil then
    if target ~= UnitName("target") then
      inspectDone()
      return
    end
    if inspectStage == 0 and target ~= lastTarget then
      if CheckInteractDistance("target", 1) then
        if CanInspect("target") then
          NotifyInspect("target")
          inspectStage = 1
        end
      end
    end

    if inspectStage == 1 then
      if (not HasInspectHonorData()) then
        RequestInspectHonorData()
      else
        inspectStage = 2
      end
    end

    if inspectStage < 1 then
      inspectDone()
      return
    end

    if inspectStage == 2 then
      local name, server = UnitName("target")
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
      local honorProgress = GetInspectPVPRankProgress()

      local todayHK, todayDK, yesterdayHK, yesterdayHonor, thisweekHK, thisweekHonor, lastweekHK, lastweekHonor, lastweekStanding, lifetimeHK, lifetimeDK, lifetimeHighestRank = GetInspectHonorData()
      local rankNumber = UnitPVPRank("target")

      local enchantSlots = {1, 3, 5, 7, 8, 9, 10, 15, 16, 17, 18}
        for i = 1, 19 do
          local id = GetInventoryItemID("target", i)

          for j = 1, #enchantSlots do
            if i == enchantSlots[j] then
              local itemLink = GetInventoryItemLink("target", i)
              local itemLinkString = tostring(itemrLink)
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
        local index = 0
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
        local formatted = format('%s,%s,%s,%s,%s,%s,%s,%s,%s,%s%s%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s', playerName or "nil", date or "nil", server or realm, name or "nil", guildName or "nil",
         guildRankName or "nil", level or "nil", classIndex or "nil", raceIndex or "nil", gender or "nil",  itemString or "nil", enchantString or "nil", todayHK or "nil",
          yesterdayHK or "nil", yesterdayHonor or "nil", lifetimeHK or "nil", honorProgress or "nil", rankNumber or "nil", thisweekHK or "nil", thisweekHonor or "nil", lastweekHK or "nil",
          lastweekHonor or "nil", lastweekStanding or "nil", lifetimeDK or "nil", lifetimeHighestRank or "nil")
      if #pattez_armory >= 500 then
        if scanned == 50 then
          DEFAULT_CHAT_FRAME:AddMessage("pattez_armory: Scanned to many players. Export by typing /pa and then press ctrl + c followed by enter")
          scanned = 0
        end
      elseif index > 0 and playerIndex == 0 then
        DEFAULT_CHAT_FRAME:AddMessage("pattez_armory: " .. "Successfully updated: " .. name)
        pattez_armory[index] = formatted
      elseif playerIndex > 0 then
        DEFAULT_CHAT_FRAME:AddMessage("pattez_armory: " .. "Successfully updated: " .. name)
          pattez_armory[playerIndex] = formatted
      else
          DEFAULT_CHAT_FRAME:AddMessage("pattez_armory: " .. "Successfully inspected: " .. name)
          tinsert(pattez_armory, formatted)
        end
      inspectDone()
    end
  else
    inspectDone()
  end
end


function PATTEZ_ARMORY_ONEVENT (event)
  if event == "PLAYER_TARGET_CHANGED" then
    inspecting = true
    inspectTarget()
  end
  if event == "INSPECT_READY" then
    if inspecting == nil then
      inspectAgain = false
    end
  end
end

function inspectDone()
  lastTarget = target
  target = nil
  inspectStage = 0
  inspecting = nil
end

function inspectTarget()
    if UnitIsPlayer("target") and UnitIsFriend("player", "target") then
      target = UnitName("target")
      inspectStage = 0
    end
end
