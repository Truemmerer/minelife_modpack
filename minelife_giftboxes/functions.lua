-- 1 = user_formspec
-- 2 = not_today
-- 4 = Admin Formspec


--------------------------------------------------------------------------------
-- PRIVATE FUNCTION TO CHECK THE ACCESS
--------------------------------------------------------------------------------

local function proof_access(player_name, meta)
    local day = tonumber( os.date( "%d"))
    local month = tonumber( os.date( "%m"))

    if minetest.check_player_privs(player_name, {minelife_giftboxes_admin=true}) then
        return 4
    else

        -- check day and month
        local day_and_month_check = false

        -- check if day and month
        if meta:get_int("minelife_giftboxes_use_month") == month or meta:get_int("minelife_giftboxes_use_month") == 0 then
            if meta:get_int("minelife_giftboxes_use_day") == day or meta:get_int("minelife_giftboxes_use_day") == 0 then 
                day_and_month_check = true
            end
        end

        if day_and_month_check == true then
            return 1;            
        else 
            -- day_and_month_check not true
            return 2;
        end
    end  
end

--------------------------------------------------------------------------------
-- FORMSPEC FOR ADMINS
--------------------------------------------------------------------------------

local function admin_formspec(pos, player_name)

    local listname = "nodemeta:"..pos.x..','..pos.y..','..pos.z
    local meta = minetest.get_meta(pos)

    minetest.show_formspec(player_name, "minelife_giftboxes:gift_admin", "size[11,10.5]" ..
            
    "formspec_version[4]"..
    "background[0,0;0.5,0.5;minelife_chest_background.png;true]"..

    "button[8.5,0;2,1;button_save;Save]"..
    "label[8.5,1.25;Avaible in month:]"..
    "field[8.5,2;2.5,1;month;;"..meta:get_int("minelife_giftboxes_use_month").."]" ..
    "label[8.5,2.75;Avaible on day:]"..
    "field[8.5,3.5;2.5,1;day;;"..meta:get_int("minelife_giftboxes_use_day").."]" ..
    "label[8.5,4.25;Leave both on zero\nif you want the gift\nto always be active.]"..

    -- Gift Storage
    "container[0,0.5]"..
    "label[0,0.5;Gift Storage:]" ..
    "list["..listname..";main;0,1;"..minelife_giftboxes.default_inv_bright..","..minelife_giftboxes.default_inv_high..";]" ..
    "container_end[]"..

    -- Player Inventar
    "label[0,5.5;Your inventory:]" ..
    "list[current_player;main;0,6;8,4;]"..

    -- Enable Shift Move Item
    "listring["..listname..";main]" ..
    "listring[current_player;main]"
)
    

end

--------------------------------------------------------------------------------
-- FORMSPEC FOR USERS WITH RIGHT TO OPEN THE GIFT
--------------------------------------------------------------------------------

local function user_formspec(pos, player_name)

    local listname = "nodemeta:"..pos.x..','..pos.y..','..pos.z
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    local inv_size = inv:get_size("main")

    -- Check if player already used the giftbox
    local player_table = minetest.deserialize(meta:get_string("minelife_giftboxes_used")) or {}
    local used = 0

    if player_table[player_name] then
        used = 1
    end

    if used == 0 then
        inv:set_size("main_for_"..player_name, inv_size)
        inv:set_list("main_for_"..player_name, inv:get_list("main"))
        player_table[player_name] = {}
        meta:set_string("minelife_giftboxes_used", minetest.serialize(player_table))
    end 
    
    minetest.show_formspec(player_name, "minelife_giftboxes:gift_user", "size[8.5,10.5]" ..
            
    "formspec_version[4]"..
    "background[0,0;0.5,0.5;minelife_chest_background.png;true]"..
    "button_exit[10.5,0;0.5,1;button_exit;X]"..

    -- Gift Storage
    "container[0,0.5]"..
    "label[0,0.5;Your gift:]" ..
    "list["..listname..";main_for_"..player_name..";0,1;"..minelife_giftboxes.default_inv_bright..","..minelife_giftboxes.default_inv_high..";]" ..
    "container_end[]"..

    -- Player Inventar
    "label[0,5.5;Your inventory:]" ..
    "list[current_player;main;0,6;8,4;]"

)
end


--------------------------------------------------------------------------------
-- FORMSPEC FOR USERS IF THE DAY OR MONTH IS NOT TODAY
--------------------------------------------------------------------------------

local function not_today_formspec(player_name)
    minetest.show_formspec(player_name, "minelife_giftboxes:not_today", "size[8,1.7]"..
    "label[0,0;Welcome, "..player_name..".\n This gift remains closed today.]" ..
    "button_exit[5,1;3,1;button_exit;Okey]")
end

--------------------------------------------------------------------------------
-- PUBLIC FUNCTION TO OPEN THE FORMSPEC
--------------------------------------------------------------------------------

function minelife_giftboxes.showform(pos, player)
    local player_name = player:get_player_name()
    local meta = minetest.get_meta(pos)

    local access = proof_access(player_name, meta)


    if access == 4 then
        admin_formspec(pos, player_name)
    elseif access == 1 then
        user_formspec(pos, player_name)
    elseif access == 2 then
        not_today_formspec(player_name)
    else
        minetest.chat_send_all("Error minelife giftboxes")
    end
end

--------------------------------------------------------------------------------
-- REGISTER IF PLAYER RECIVED FIELDS
--------------------------------------------------------------------------------

minetest.register_on_player_receive_fields(function(player, formname, fields)

    if formname == ("minelife_giftboxes:gift_admin") then
        if fields["button_save"] then
            local meta = minetest.get_meta(minelife_giftboxes.minelife_giftboxes_current_position[player:get_player_name()])

            local day = fields.day
            local month = fields.month

            if day == "" then
                day = 0
            end
            if month == "" then
                month = 0
            end

            meta:set_int("minelife_giftboxes_use_day", day)
            meta:set_int("minelife_giftboxes_use_month", month)
        end
    end
end)