
if GetLocale() ~= "frFR" then return end
local _, tbl = ...
local L = tbl.L

L.addon_desc1 = "ErrorMonster est votre compagnon qui étouffe et redirige les erreurs, les messages système et les messages d'informations venant de l'UI et pleins d'autres sources, ce qui inclue aussi les autres addons"
L.addon_desc2 = "Pour configurer où ErrorMonster doit rediriger les messages,veuillez étendre l'onglet dans les coins et aller dans la section de Sortie"
L.addon_desc3 = "Vous pouvez ci-dessous choisir quel genre de messages vous voulez intercepter. Par défaut,ErrorMonster s'occupera seulement des erreurs actuel(les rouges)"
L.output = "Sortie"
L.error = "Erreur"
L.error_desc = "Messages d'erreur"
L.information = "Information"
L.information_desc = "Messages d'information"
L.system = "Système"
L.system_desc = "Messages Système"
L.combat = "Cache tous les messages en combat"
L.combat_desc = "Cache tous les messages interceptés quand vous êtes en combat"
