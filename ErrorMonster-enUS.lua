local L = AceLibrary("AceLocale-2.2"):new("ErrorMonster")

L:RegisterTranslations("enUS", function() return {
	["Shows the current filters and their ID."] = true,
	["Adds the given filter to the ignore list."] = true,
	["<filter>"] = true,
	["Removes the given filter or ID from the filter list."] = true,
	["Adding filter: "] = true,
	["Removing filter: "] = true,
	["Filter not found: "] = true,
	["Active filters:"] = true,
	["Where to flush the messages matched by the filters."] = true,
	["Monster"] = true,
	["Throttle errors at the given rate in seconds."] = true,
	["Go berserk and eat all the errors."] = true,
} end)

