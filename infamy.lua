if RequiredScript == "lib/managers/menu/playerinventorygui" then
-- activate infamy menu
	local orig_create_box = PlayerInventoryGui.create_box
	function PlayerInventoryGui:create_box(params)
		if params.name:match("infamy") then
			params.alpha = 1
			params.clbks = {
				down = false,
				up = false,
				right = false,
				left = callback(self, self, "open_infamy_menu")
			}
		end

		return orig_create_box(self, params)
	end

-- remove warring desc
	local orig_PlayerInventoryGui = PlayerInventoryGui._update_info_infamy
	function PlayerInventoryGui:_update_info_infamy(name)
		orig_PlayerInventoryGui(self, name)
		local rank = managers.infamy:points()
		local text_string = managers.localization:to_upper_text("menu_infamy_rank", {
			rank = tostring(managers.experience:current_rank())
		}) .. "\n"

		text_string = text_string .. "\n" .. managers.localization:to_upper_text("menu_infamy_total_xp", {
			xpboost = string.format("%0.1f", (managers.player:get_infamy_exp_multiplier() - 1) * 100)
		}) .. "\n\n" .. managers.localization:text("menu_infamy_help")

		self:set_info_text(text_string)
	end

elseif RequiredScript == "lib/managers/menumanager" then
-- sync infamy level
		local function sync_lobby_info()
		if managers.network and managers.network:session() then
			local level = managers.experience:current_level()
			local rank = managers.experience:current_rank()
			managers.network:session():send_to_peers_loaded("lobby_info", level, rank)
		end
	end

	Hooks:PostHook(MenuCallbackHandler, "_increase_infamous", "infamy_in_lobby_increase_infamous", sync_lobby_info)
	Hooks:PostHook(MenuCallbackHandler, "_increase_infamous_with_prestige", "infamy_in_lobby_increase_infamous_with_prestige", sync_lobby_info)
end