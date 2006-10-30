 --
-- ErrorMonster
-- by Rabbit
-- originally RogueSpam by Allara
--

ErrorMonster = AceLibrary("AceAddon-2.0"):new("AceHook-2.1", "AceConsole-2.0", "AceDB-2.0", "AceEvent-2.0")

local L = AceLibrary("AceLocale-2.2"):new("ErrorMonster")
local throttle = nil

function ErrorMonster:OnInitialize()
	ErrorMonster:RegisterDB("ErrorMonsterDB", "ErrorMonsterDBChar")
	ErrorMonster:RegisterDefaults("profile", {
		sink = L["Monster"],
		throttle = 0,
	})
	ErrorMonster:RegisterDefaults("char", {
		errorList = {
			SPELL_FAILED_NO_COMBO_POINTS,   -- That ability requires combo points
			SPELL_FAILED_TARGETS_DEAD,      -- Your target is dead
			SPELL_FAILED_SPELL_IN_PROGRESS, -- Another action is in progress
			SPELL_FAILED_TARGET_AURASTATE,  -- You can't do that yet. (TargetAura)
			SPELL_FAILED_CASTER_AURASTATE,  -- You can't do that yet. (CasterAura)
			SPELL_FAILED_NO_ENDURANCE,      -- Not enough endurance
			SPELL_FAILED_BAD_TARGETS,       -- Invalid target
			SPELL_FAILED_NOT_MOUNTED,       -- You are mounted
			SPELL_FAILED_NOT_ON_TAXI,       -- You are in flight
			SPELL_FAILED_NOT_INFRONT,       -- You must be in front of your target
			SPELL_FAILED_NOT_IN_CONTROL,    -- You are not in control of your actions
			SPELL_FAILED_MOVING,            -- Can't do that while moving
			ERR_GENERIC_NO_TARGET,          -- You have no target.
			ERR_ABILITY_COOLDOWN,           -- Ability is not ready yet.
			ERR_OUT_OF_ENERGY,              -- Not enough energy
			ERR_NO_ATTACK_TARGET,           -- There is nothing to attack.
			ERR_SPELL_COOLDOWN,             -- Spell is not ready yet. (Spell)
			ERR_OUT_OF_RAGE,                -- Not enough rage.
			ERR_INVALID_ATTACK_TARGET,      -- You cannot attack that target.
			ERR_OUT_OF_MANA,                -- Not enough mana
			ERR_NOEMOTEWHILERUNNING,        -- You can't do that while moving!
			OUT_OF_ENERGY,                  -- Not enough energy.
		},
	})

	local args = {
		type = "group",
		args = {
			list = {
				name = "list", type = "execute",
				desc = L["Shows the current filters and their ID."],
				func = function() self:ListFilters() end,
			},
			add = {
				name  = "add", type = "text",
				desc  = L["Adds the given filter to the ignore list."],
				usage = L["<filter>"],
				set   = function(text) self:AddFilter(text) end,
				get   = false,
			},
			remove = {
				name  = "remove", type = "text",
				desc  = L["Removes the given filter or ID from the filter list."],
				usage = L["<filter>"],
				set   = function(text) self:RemoveFilter(text) end,
				get   = false,
			},
			sink = {
				name  = "sink", type = "text",
				desc  = L["Where to flush the messages matched by the filters."],
				get = function() return ErrorMonster.db.profile.sink end,
				set = function(v) ErrorMonster.db.profile.sink = v end,
				usage = "<"..L["Monster"]..", BigWigs, Scrolling Combat Text, Scrolling Combat Text Message, MSBT, Blizzard FCT or ChatFrame1-10>",
				validate = function(input)
					local _,_,x = string.find(input, "ChatFrame(%d+)")
					if x ~= nil and tonumber(x) ~= nil then
						return tonumber(x) > 0 and tonumber(x) < 11
					end
					return	input == L["Monster"] or
							input == "BigWigs" or
							input == "Scrolling Combat Text" or
							input == "Scrolling Combat Text Message" or
							input == "MSBT" or
							input == "Blizzard FCT"
					end
			},
			throttle = {
				name = "throttle", type = "range",
				desc = L["Throttle errors at the given rate in seconds."],
				min = 0, max = 10,
				get = function() return ErrorMonster.db.profile.throttle end,
				set = function(v) ErrorMonster.db.profile.throttle = v end,
			},
		},
	}

	self:RegisterChatCommand({"/errormonster", "/errm"}, args)
end

function ErrorMonster:OnEnable()
	self:Hook(UIErrorsFrame, "AddMessage", true)
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	--  CHAT_MSG_SPELL_FAILED_LOCALPLAYER
end

function ErrorMonster:PLAYER_ENTERING_WORLD()
	if throttle ~= nil then
		for i in pairs(throttle) do
			throttle[i] = nil
		end
		throttle = nil
	end
end

function ErrorMonster:Flush(message)
	local sink = self.db.profile.sink
	if sink == L["Monster"] then return end -- Default, eat it!

	if self.db.profile.throttle > 0 then
		if throttle == nil then throttle = {} end
		if throttle[message] and (throttle[message] + self.db.profile.throttle > GetTime()) then return end
		throttle[message] = GetTime()
	end

	if sink == "BigWigs" and BigWigs then
		self:TriggerEvent("BigWigs_Message", message, "Red", false, nil)
	elseif sink == "Scrolling Combat Text" and SCT and type(SCT.DisplayText) == "function" then
		SCT:DisplayText(message, { r = 1.0, g = 0.0, b = 0.0 }, nil, "event", 1)
	elseif sink == "Scrolling Combat Text Message" and SCT and type(SCT.DisplayMessage) == "function" then
		SCT:DisplayMessage(message, { r = 1.0, g = 0.0, b = 0.0 })
	elseif sink == "MSBT" and MikSBT then
		MikSBT.DisplayMessage(message, MikSBT.DISPLAYTYPE_NOTIFICATION, false, 255, 0, 0)
	elseif sink == "Blizzard FCT" and CombatText_AddMessage then
		CombatText_AddMessage(message, COMBAT_TEXT_SCROLL_FUNCTION, 1.0, 0.0, 0.0, "sticky", nil)
	elseif string.find(sink, "ChatFrame") then
		local f = getglobal(sink)
		if f ~= nil and type(f.GetObjectType) == "function" and f:GetObjectType() == "ScrollingMessageFrame" and type(f.AddMessage) == "function" then
			f:AddMessage(message, 1, 0, 0)
		end
	end
end

function ErrorMonster:AddMessage(frame, message, r, g, b, a)
	for key, text in pairs(self.db.char.errorList) do
		if text and message and message == text then
			self:Flush(message)
			return
		end
	end
	self.hooks[UIErrorsFrame].AddMessage(frame, message, r, g, b, a)
end

function ErrorMonster:AddFilter(filter)
	self:Print(L["Adding filter: "]..filter)
	table.insert(self.db.char.errorList, filter)
end

function ErrorMonster:RemoveFilter(filter)
	local numCompare = nil
	if tonumber(filter) then numCompare = true end
	for key, text in pairs(self.db.char.errorList) do
		if text == filter or (numCompare and tonumber(filter) == tonumber(key)) then
			self:Print(L["Removing filter: "]..text)
			table.remove(self.db.char.errorList, key)
			return
		end
	end
	self:Print(L["Filter not found: "]..filter)
end

function ErrorMonster:ListFilters()
	self:Print(L["Active filters:"])
	for key, text in pairs(self.db.char.errorList) do
		self:Print(" "..key..". "..text)
	end
end

