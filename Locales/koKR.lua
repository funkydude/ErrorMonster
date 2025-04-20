
if GetLocale() ~= "koKR" then return end
local _, tbl = ...
local L = tbl.L

L.addon_desc1 = "ErrorMonster는 UI 오류 프레임의 오류, 시스템 메시지 및 정보 메시지를 다른 애드온을 포함한 여러 출력으로 제한하고 리디렉션하는 도구입니다."
L.addon_desc2 = "ErrorMonster가 메시지를 리디렉션할 위치를 구성하려면 측면 트리를 확장하고 출력 섹션으로 이동하세요."
L.addon_desc3 = "아래에서 차단할 메시지 종류를 설정할 수 있습니다. 기본적으로 ErrorMonster는 실제 오류(빨간색 오류)만 처리합니다."
L.output = "출력"
L.error = "오류"
L.error_desc = "오류 메시지."
L.information = "정보"
L.information_desc = "정보 메시지."
L.system = "시스템"
L.system_desc = "시스템 메시지."
L.combat = "전투 중 모든 메시지 숨기기"
L.combat_desc = "전투 중 가로챈 모든 메시지를 숨깁니다."
