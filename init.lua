player_hud = {}
player_hud.timed_msg = {}

minetest.register_chatcommand("tmsg", {
	params = "<name> <msg>",
	description = "Display a timed message to a player",
	privs = {server = true},

	func = function(name, params)
		local plName, message = params:match("(%S+)%s+(.+)")
		-- player online
		if plName ~= "" and minetest.get_player_by_name(plName) then
			name = plName
		-- player not online
		else
			return false, "Player " .. plName .. " is not online!"
		end
		-- check and remove prev player hud message
		removehud(minetest.get_player_by_name(plName))
		-- generate message on players hud
		generatehud(minetest.get_player_by_name(plName), message)
		minetest.after(60, removehud, minetest.get_player_by_name(plName))
	end
})
generatehud = function(player, msg)
            local name = player:get_player_name()
            player_hud.timed_msg[name] = player:hud_add({
                    hud_elem_type = "text",
                    name = "player_hud:birthday",
                    position = {x=0.5, y=0.5},
		    offset = {x=-100, y = 20},
                    text = msg.." "..name.."!",
                    scale = {x=100,y=100},
                    alignment = {x=0,y=0},
                    number = 0xFF0000,
})
end
removehud = function(player)
	    local name = player:get_player_name()
            if player_hud.timed_msg[name] then
                    player:hud_remove(player_hud.timed_msg[name])
            end
end


minetest.register_on_leaveplayer(function(player)
            minetest.after(1,removehud,player)
end)
