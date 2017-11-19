
if GetLocale() ~= "deDE" then return end
local _, tbl = ...
local L = tbl.L

L.addon_desc1 = "ErrorMonster ist ein Begleiter, der Fehler, System- und Informationsmeldungen aus dem UI-Fehler-Fenster drosselt und zu vielen anderen Ausgabenmöglichkeiten, einschließlich anderen Addons, weiterleitet."
L.addon_desc2 = "Um einzustellen, wohin ErrorMonster die Ausgaben umleiten soll, erweitere den Pfadbaum an der Seite und gehe zum Bereich Ausgabe."
L.addon_desc3 = "Unterhalb kannst du umschalten, welche Art von Meldungen abgefangen werden sollen. Standardmäßig handhabt ErrorMonster nur tatsächliche Fehler (die roten)."
L.output = "Ausgabe"
L.error = "Fehler"
L.error_desc = "Fehlermeldungen"
L.information = "Informationen"
L.information_desc = "Informationsmeldungen"
L.system = "System"
L.system_desc = "Systemmeldungen"
L.combat = "Alle Meldungen während des Kampfes verstecken."
L.combat_desc = "Blendet alle abgefangenen Meldungen aus, während du dich im Kampf befindest."
