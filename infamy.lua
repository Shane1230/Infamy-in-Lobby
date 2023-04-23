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