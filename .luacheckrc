std = "lua51"
max_line_length = false
codes = true
exclude_files = {
	"**/Libs",
}
ignore = {
	"211/L", -- Missing locale entries (unused variable L)
}
globals = {
	"CreateFrame",
	"GetGameMessageInfo",
	"GetLocale",
	"GetTime",
	"InCombatLockdown",
	"LibStub",
	"PlayVocalErrorSoundID",
	"PlaySound",
	"UIErrorsFrame",
}
