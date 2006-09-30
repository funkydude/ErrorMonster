 --
-- ErrorMonster
-- by Rabbit
-- originally RogueSpam by Allara
--

ErrorMonster = AceLibrary("AceAddon-2.0"):new("AceHook-2.0", "AceConsole-2.0", "AceDB-2.0", "AceEvent-2.0")

local L = AceLibrary("AceLocale-2.0"):new("ErrorMonster")

function ErrorMonster:OnInitialize()
	ErrorMonster:RegisterDB("ErrorMonsterDB", "ErrorMonsterDBChar")
	ErrorMonster:RegisterDefaults('char', {
		errorList = {
			ERR_ABILITY_COOLDOWN,           -- Ability is not ready yet.
			ERR_OUT_OF_ENERGY,              -- Not enough energy
			ERR_NO_ATTACK_TARGET,           -- There is nothing to attack.
			SPELL_FAILED_NO_COMBO_POINTS,   -- That ability requires combo points
			SPELL_FAILED_TARGETS_DEAD,      -- Your target is dead
			SPELL_FAILED_SPELL_IN_PROGRESS, -- Another action is in progress
			ERR_SPELL_COOLDOWN,             -- Spell is not ready yet. (Spell)
			OUT_OF_ENERGY,                  -- Not enough energy.
			ERR_OUT_OF_RAGE,                -- Not enough rage.
			SPELL_FAILED_TARGET_AURASTATE,  -- You can't do that yet. (TargetAura)
			SPELL_FAILED_CASTER_AURASTATE,  -- You can't do that yet. (CasterAura)
			SPELL_FAILED_NO_ENDURANCE,      -- Not enough endurance
			ERR_INVALID_ATTACK_TARGET,      -- You cannot attack that target.
			SPELL_FAILED_BAD_TARGETS,       -- Invalid target
			SPELL_FAILED_NOT_MOUNTED,       -- You are mounted
			SPELL_FAILED_NOT_ON_TAXI,       -- You are in flight
			-- Mikma's lines start here
			ERR_OUT_OF_MANA,		-- Not enough mana
			ERR_NOEMOTEWHILERUNNING,	-- You can't do that while moving!
			SPELL_FAILED_NOT_INFRONT,	-- You must be in front of your target
			SPELL_FAILED_NOT_IN_CONTROL,	-- You are not in control of your actions
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
		},
	}

	self:RegisterChatCommand({"/errormonster", "/em"}, args)
end

function ErrorMonster:OnEnable()
	self:Hook("UIErrorsFrame_OnEvent", "ErrorFrameOnEvent")
	--  CHAT_MSG_SPELL_FAILED_LOCALPLAYER
end

function ErrorMonster:ErrorFrameOnEvent(event, message, arg1, arg2, arg3, arg4)
	for key, text in self.db.char.errorList do
		if (text and message) and (message == text) then return end
	end
	self.hooks["UIErrorsFrame_OnEvent"](event, message, arg1, arg2, arg3, arg4)
end

function ErrorMonster:AddFilter(filter)
	self:Print(L["Adding filter: "]..filter)
	table.insert(self.db.char.errorList, filter)
end

function ErrorMonster:RemoveFilter(filter)
	local numCompare = nil
	if tonumber(filter) then numCompare = true end
	for key, text in self.db.char.errorList do
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
	for key, text in self.db.char.errorList do
		self:Print(" "..key..". "..text)
	end
end

