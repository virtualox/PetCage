--[[
	PetCage (Forked from AutoCage by @Kruithne)
	Original Author: @Kruithne <kruithne@gmail.com>
	Modified and Enhanced by: VirtualOx
	
	Original Addon: https://github.com/Kruithne/AutoCage
	This version: https://github.com/virtualox//PetCage

	Licensed under GNU General Public Licence version 3.

	petcage.lua - Enhanced core engine file for the addon.
]]

local petCagedPattern = string.gsub(BATTLE_PET_NEW_PET, "%%s", ".*Hbattlepet:(%%d+).*");
local pcHasHooked = false;

L_PETCAGE_CAGED_MESSAGE = {
	["frFR"] = "Dupliquer animal de compagnie; la mise en cage pour vous!",
	["deDE"] = "Doppeltes Haustier; Sperre es in einen Käfig für dich!",
	["enUS"] = "Duplicate pet; caging it for you!",
	["itIT"] = "Metti in gabbia le tue mascotte duplicate!",
	["koKR"] = "복제 애완동물; 케이지로 넣습니다!",
	["zhCN"] = "重复宠物;把它关在笼子里！",
	["zhTW"] = "重複寵物;把它關在籠子裡！",
	["ruRU"] = "Повторяющиеся питомцы; положить их в клетку!",
	["esES"] = "Duplicar mascota; ponerla en una jaula!",
	["esMX"] = "Duplicar mascota; ponerla en una jaula!",
	["ptBR"] = "Duplicar mascote; colocando-o em uma gaiola!"
};

L_PETCAGE_LOADED = {
	["frFR"] = "Chargé!",
	["deDE"] = "Geladen!",
	["enUS"] = "Loaded!",
	["itIT"] = "Caricato!",
	["koKR"] = "로드 완료!",
	["zhCN"] = "加载完成!",
	["zhTW"] = "載入完成!",
	["ruRU"] = "Загружен!",
	["esES"] = "Cargado!",
	["esMX"] = "Cargado!",
	["ptBR"] = "Carregado!"
};

L_PETCAGE_DUPLICATE_PETS_BUTTON = {
  ["frFR"] = "Mettre les animaux en double en cage",
  ["deDE"] = "Haustiere einsperren",
  ["enUS"] = "Cage Duplicate Pets",
  ["itIT"] = "Metti in gabbia le mascotte duplicate",
  ["koKR"] = "복제된 애완동물 케이지",
  ["zhCN"] = "笼中重复宠物",
  ["zhTW"] = "笼中重复宠物",
  ["ruRU"] = "Клетка для повторяющихся питомцев",
  ["esES"] = "Enjaular mascotas duplicadas",
  ["esMX"] = "Enjaular mascotas duplicadas",
  ["ptBR"] = "Colocar mascotes duplicados na gaiola",
};

L_PETCAGE_DUPLICATE_PETS_BUTTON_TOOLTIP = {
  ["frFR"] = "Met en cage tous les animaux de compagnie en double qui ne sont ni favoris ni de niveau supérieur à un.",
  ["deDE"] = "Sperrt alle Haustiere in einen Käfig, die weder favorisiert sind, noch Level eins übersteigen.",
  ["enUS"] = "Cages all duplicate pets that are neither favourited or above level one.",
  ["itIT"] = "Mette in gabbia tutte le mascotte duplicate che non sono favorite o sopra il livello uno.",
  ["koKR"] = "즐겨찾기에 있지 않고 레벨 1 이하인 모든 중복 애완동물을 케이지에 넣습니다.",
  ["zhCN"] = "将所有非喜爱的且等级不高于一的重复宠物关入笼中。",
  ["zhTW"] = "將所有非喜愛且等級不高於一的重複寵物關入籠中。",
  ["ruRU"] = "Клетка для всех повторяющихся питомцев, которые не избранные или не выше первого уровня.",
  ["esES"] = "Enjaula a todas las mascotas duplicadas que no están marcadas como favoritas o por encima del nivel uno.",
  ["esMX"] = "Enjaula a todas las mascotas duplicadas que no están marcadas como favoritas o por encima del nivel uno.",
  ["ptBR"] = "Coloca todos os mascotes duplicados que não são favoritos ou acima do nível um na gaiola.",
};

L_PETCAGE_CHECKBOX = {
	["frFR"] = "Mettre automatiquement les doublons en cage",
	["deDE"] = "Haustiere automatisch einsperren",
	["enUS"] = "Automatically cage duplicates",
	["itIT"] = "Metti in gabbia automaticamente le mascotte duplicate",
	["koKR"] = "중복 애완동물을 자동으로 케이지",
	["zhCN"] = "自动将重复的宠物放入笼子",
	["zhTW"] = "自動將重複的寵物放入籠子",
	["ruRU"] = "Автоматически помещать дубликаты в клетку",
	["esES"] = "Enjaular automáticamente los duplicados",
	["esMX"] = "Enjaular automáticamente los duplicados",
	["ptBR"] = "Colocar duplicatas automaticamente na gaiola",
};

L_PETCAGE_CHECKBOX_TOOLTIP = {
	["frFR"] = "Si activé, les animaux de compagnie en double qui s'apprennent seront automatiquement mis en cage.",
	["deDE"] = "Wenn aktiviert, werden doppelte Haustiere automatisch in einen Käfig gesetzt, sobald sie erlernt werden.",
	["enUS"] = "If enabled, duplicate pets that get learnt will automatically be put in a cage.",
	["itIT"] = "Se abilitato, le mascotte duplicate che impari saranno automaticamente messe in gabbia.",
	["koKR"] = "활성화하면 배운 중복 애완동물이 자동으로 케이지에 들어갑니다.",
	["zhCN"] = "如果启用，学到的重复宠物将自动被放入笼子。",
	["zhTW"] = "如果啟用，學到的重複寵物將自動被放入籠子。",
	["ruRU"] = "Если включено, дубликаты питомцев, которые изучены, автоматически будут помещаться в клетку.",
	["esES"] = "Si se activa, las mascotas duplicadas que se aprendan se pondrán automáticamente en una jaula.",
	["esMX"] = "Si se activa, las mascotas duplicadas que se aprendan se pondrán automáticamente en una jaula.",
	["ptBR"] = "Se ativado, os mascotes duplicados aprendidos serão automaticamente colocados em uma gaiola.",
};

L_PETCAGE_AUTO_ENABLED = {
	["frFR"] = "Les animaux de compagnie en double seront désormais automatiquement mis en cage lorsqu'ils seront obtenus.",
	["deDE"] = "Doppelte Haustiere werden nun automatisch in einen Käfig gesetzt, wenn sie erhalten werden.",
	["enUS"] = "Duplicate pets will now be automatically caged when obtained.",
	["itIT"] = "Le mascotte duplicate saranno ora automaticamente messe in gabbia quando ottenute.",
	["koKR"] = "이제 중복 애완동물이 획득될 때 자동으로 케이지에 들어갑니다.",
	["zhCN"] = "获得重复宠物后，将自动放入笼子。",
	["zhTW"] = "獲得重複寵物後，將自動放入籠子。",
	["ruRU"] = "Повторяющиеся питомцы теперь будут автоматически помещены в клетку при получении.",
	["esES"] = "Las mascotas duplicadas ahora se pondrán automáticamente en una jaula cuando se obtengan.",
	["esMX"] = "Las mascotas duplicadas ahora se pondrán automáticamente en una jaula cuando se obtengan.",
	["ptBR"] = "Mascotes duplicados agora serão automaticamente colocados na gaiola quando obtidos.",
};

L_PETCAGE_AUTO_DISABLED = {
	["frFR"] = "Les animaux de compagnie en double ne seront plus automatiquement mis en cage lorsqu'ils seront obtenus.",
	["deDE"] = "Doppelte Haustiere werden nun nicht mehr automatisch in einen Käfig gesetzt, wenn sie erhalten werden.",
	["enUS"] = "Duplicate pets will no longer be automatically caged when obtained.",
	["itIT"] = "Le mascotte duplicate non saranno più automaticamente messe in gabbia quando ottenute.",
	["koKR"] = "이제 중복 애완동물이 획득될 때 자동으로 케이지에 들어가지 않습니다.",
	["zhCN"] = "获得重复宠物后，将不再自动放入笼子。",
	["zhTW"] = "獲得重複寵物後，將不再自動放入籠子。",
	["ruRU"] = "Повторяющиеся питомцы больше не будут автоматически помещены в клетку при получении.",
	["esES"] = "Las mascotas duplicadas ya no se pondrán automáticamente en una jaula cuando se obtengan.",
	["esMX"] = "Las mascotas duplicadas ya no se pondrán automáticamente en una jaula cuando se obtengan.",
	["ptBR"] = "Mascotes duplicados não serão mais automaticamente colocados na gaiola quando obtidos.",
};

L_PETCAGE_CAGING = {
	["frFR"] = "Mise en cage des animaux de compagnie en double...",
	["deDE"] = "Einsperren doppelter Haustiere...",
	["enUS"] = "Caging duplicate pets...",
	["itIT"] = "Messa in gabbia delle mascotte duplicate...",
	["koKR"] = "중복 애완동물 케이지...",
	["zhCN"] = "笼中重复宠物...",
	["zhTW"] = "笼中重复宠物...",
	["ruRU"] = "Помещение в клетку повторяющихся питомцев...",
	["esES"] = "Enjaulando mascotas duplicadas...",
	["esMX"] = "Enjaulando mascotas duplicadas...",
	["ptBR"] = "Colocando mascotes duplicados na gaiola...",
};

L_PETCAGE_COMMANDS_AVAILABLE = {
	["frFR"] = "Commandes disponibles:",
	["deDE"] = "Verfügbare Befehle:",
	["enUS"] = "Available Commands:",	
	["itIT"] = "Comandi disponibili:",
	["koKR"] = "사용 가능한 명령어:",
	["zhCN"] = "可用命令:",
	["zhTW"] = "可用命令:",
	["ruRU"] = "Доступные команды:",
	["esES"] = "Comandos disponibles:",
	["esMX"] = "Comandos disponibles:",
	["ptBR"] = "Comandos disponíveis:",
};

L_PETCAGE_COMMANDS_HELP = {
	["frFR"] = "Liste des commandes disponibles.",
	["deDE"] = "Liste der verfügbaren Befehle.",
	["enUS"] = "List available commands.",
	["itIT"] = "Elenca i comandi disponibili.",
	["koKR"] = "사용 가능한 명령어 목록.",
	["zhCN"] = "列出可用的命令。",
	["zhTW"] = "列出可用的命令。",
	["ruRU"] = "Список доступных команд.",
	["esES"] = "Lista de comandos disponibles.",
	["esMX"] = "Lista de comandos disponibles.",
	["ptBR"] = "Listar comandos disponíveis.",
};

L_PETCAGE_COMMANDS_CAGE = {
	["frFR"] = "Activer/désactiver la fonctionnalité de mise en cage automatique.",
	["deDE"] = "Automatische Käfigfunktion umschalten.",
	["enUS"] = "Toggle auto-caging functionality.",
	["itIT"] = "Attiva/disattiva la funzionalità di messa in gabbia automatica.",
	["koKR"] = "자동 케이지 기능 토글.",
	["zhCN"] = "切换自动笼中功能。",
	["zhTW"] = "切換自動籠中功能。",
	["ruRU"] = "Переключить функцию автоматического помещения в клетку.",
	["esES"] = "Activar/desactivar la funcionalidad de enjaulado automático.",
	["esMX"] = "Activar/desactivar la funcionalidad de enjaulado automático.",
	["ptBR"] = "Alternar a funcionalidade de gaiola automática.",
};

L_PETCAGE_COMMANDS_TOGGLE = {
	["frFR"] = "Mettre en cage tous les animaux de compagnie en double.",
	["deDE"] = "Alle doppelten Haustiere einsperren.",
	["enUS"] = "Cage all duplicate pets.",
	["itIT"] = "Metti in gabbia tutte le mascotte duplicate.",
	["koKR"] = "모든 중복 애완동물 케이지.",
	["zhCN"] = "笼中所有重复宠物。",
	["zhTW"] = "籠中所有重複寵物。",
	["ruRU"] = "Поместить в клетку всех повторяющихся питомцев.",
	["esES"] = "Enjaular todas las mascotas duplicadas.",
	["esMX"] = "Enjaular todas las mascotas duplicadas.",
	["ptBR"] = "Colocar todos os mascotes duplicados na gaiola.",
};

-- Rest of the script remains the same...

-- Function to get localized strings
function PetCage_GetLocalizedString(strings)
	return strings[GetLocale()] or strings["enUS"] or "Unknown";
end

-- Function to handle auto-caging
local petsToCage = {};
function PetCage_HandleAutoCaging(petToCageID)
	C_PetJournal.ClearSearchFilter(); -- Clear filter for full pet list.
	C_PetJournal.SetPetSortParameter(LE_SORT_BY_LEVEL); -- Sort by pet level.

	local total, owned = C_PetJournal.GetNumPets();
	local petCache = {};
	petsToCage = {};

	if petToCageID ~= nil then
		petToCageID = tonumber(petToCageID);
	end

	for index = 1, owned do -- Loop through all owned pets.
		local pGuid, pBattlePetID, _, pNickname, pLevel, pIsFav, _, pName, _, _, _, _, _, _, _, pIsTradeable = C_PetJournal.GetPetInfoByIndex(index);

		if petToCageID == nil or petToCageID == pBattlePetID then
			if petCache[pBattlePetID] then
				if pLevel == 1 and not pIsFav and pIsTradeable then
					PetCage_Message(pName .. " :: " .. PetCage_GetLocalizedString(L_PETCAGE_CAGED_MESSAGE));
					table.insert(petsToCage, pGuid);
				end
			else
				petCache[pBattlePetID] = true;
			end
		end
	end
end

-- Load function when addon is initialized
function PetCage_Load()
	if PetCageEnabled == nil then
		PetCageEnabled = true;
	end

	if PetCage_EnabledButton ~= nil then
		PetCage_EnabledButton:SetChecked(PetCageEnabled);
	end
end

-- Hook function to attach UI elements
function PetCage_JournalHook()
	if pcHasHooked or C_AddOns.IsAddOnLoaded("Rematch") then
		return;
	end

	-- Create caging button
	local cageButton = CreateFrame("Button", "PetCage_CageButton", PetJournal, "MagicButtonTemplate");
	cageButton:SetPoint("LEFT", PetJournalSummonButton, "RIGHT", 0, 0);
	cageButton:SetWidth(150);
	cageButton:SetText(PetCage_GetLocalizedString(L_PETCAGE_DUPLICATE_PETS_BUTTON));
	cageButton:SetScript("OnClick", function() PetCage_HandleAutoCaging(nil) end);
	cageButton:SetScript("OnEnter",
		function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
			GameTooltip:SetText(PetCage_GetLocalizedString(L_PETCAGE_DUPLICATE_PETS_BUTTON), 1, 1, 1);
			GameTooltip:AddLine(PetCage_GetLocalizedString(L_PETCAGE_DUPLICATE_PETS_BUTTON_TOOLTIP), nil, nil, nil, true);
			GameTooltip:Show();
		end
	);
	cageButton:SetScript("OnLeave", function() GameTooltip:Hide(); end);

	-- Set up enable/disable checkbox
	local checkButton = CreateFrame("CheckButton", "PetCage_EnabledButton", PetJournal, "ChatConfigCheckButtonTemplate");
	checkButton:SetPoint("LEFT", PetCage_CageButton, "RIGHT", 10, -2);
	checkButton:SetChecked(PetCageEnabled);
	PetCage_EnabledButtonText:SetPoint("LEFT", checkButton, "RIGHT", -1, 0);
	PetCage_EnabledButtonText:SetText(PetCage_GetLocalizedString(L_PETCAGE_CHECKBOX));
	checkButton.tooltip = PetCage_GetLocalizedString(L_PETCAGE_CHECKBOX_TOOLTIP);
	checkButton:SetScript("OnClick", function()
		PetCageEnabled = not PetCageEnabled;
	end);

	pcHasHooked = true;
end

-- Function to print messages
function PetCage_Message(msg)
	DEFAULT_CHAT_FRAME:AddMessage("\124cffc79c6ePetCage:\124r \124cff69ccf0" .. msg .. "\124r");
end

-- Event handling frame setup
local eventFrame = CreateFrame("FRAME");
eventFrame:RegisterEvent("CHAT_MSG_SYSTEM");
eventFrame:RegisterEvent("ADDON_LOADED");
eventFrame.elapsed = 0;
eventFrame.pendingUpdate = false;
eventFrame.cageTimer = 0;

eventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_SYSTEM" and PetCageEnabled then
		local msg = ...;
		local match = string.match(msg, petCagedPattern);

		if match then
			self.pendingUpdate = true;
			self.petID = match;
		end
	elseif event == "ADDON_LOADED" then
		local addon = ...;
		if addon == "Blizzard_Collections" then
			PetCage_JournalHook();
		elseif addon == "PetCage" then
			PetCage_Load();

			if C_AddOns.IsAddOnLoaded("Blizzard_Collections") then
				PetCage_JournalHook();
			end
		end
	end
end);

eventFrame:SetScript("OnUpdate", function(self, elapsed)
	if self.pendingUpdate then
		if self.elapsed >= 1 then
			PetCage_HandleAutoCaging(self.petID);

			self.elapsed = 0;
			self.pendingUpdate = false;
		else
			self.elapsed = self.elapsed + elapsed;
		end
	end

	if self.cageTimer >= 1 then
		if #petsToCage > 0 then
			for _, petID in ipairs(petsToCage) do
				C_PetJournal.CagePetByID(petID);
			end
		end
		self.cageTimer = 0;
	else
		self.cageTimer = self.cageTimer + elapsed;
	end
end);

local PetCageCommands = {};
function PetCage_CommandToggle()
	PetCageEnabled = not PetCageEnabled;
	PetCage_Message(PetCage_GetLocalizedString(PetCageEnabled and L_PETCAGE_AUTO_ENABLED or L_PETCAGE_AUTO_DISABLED));
end

function PetCage_CommandCage()
	PetCage_HandleAutoCaging(nil);
	PetCage_Message(PetCage_GetLocalizedString(L_PETCAGE_CAGING));
end

function PetCage_CommandDefault()
	PetCage_Message(PetCage_GetLocalizedString(L_PETCAGE_COMMANDS_AVAILABLE));
	local commandFormat = "   /%s - %s";

	for id, node in pairs(PetCageCommands) do
		PetCage_Message(commandFormat:format(id, node.info));
	end
end

PetCageCommands["help"] = { func = PetCage_CommandDefault, info = PetCage_GetLocalizedString(L_PETCAGE_COMMANDS_HELP) };
PetCageCommands["toggle"] = { func = PetCage_CommandToggle, info = PetCage_GetLocalizedString(L_PETCAGE_COMMANDS_TOGGLE) };
PetCageCommands["cage"] = { func = PetCage_CommandCage, info = PetCage_GetLocalizedString(L_PETCAGE_COMMANDS_CAGE) };

-- Commands registration
SLASH_PETCAGE1 = "/petcage";
SlashCmdList["PETCAGE"] = function(text)
	local command = PetCageCommands[text] or PetCageCommands["help"];
	command.func();
end;
