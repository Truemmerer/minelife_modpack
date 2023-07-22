-- Author Truemmerer, lobnews
-- First Create: 24.08.2020
-- Version: see README.md

licenses_add("language-en")
licenses_add("language-de")

local form_prefix = "beginner_guide:"

local function get_formspec(form)
	if form == "guide" then
		return "size[8.5,9]\n"..
			   "label[3.20,0.95;Choose your language]"..
			   "label[3.25,1.35;Wähle deine Sprache]"..
			   "image[2.75,0;3.5,1;MineLifeLogoBanner.png]"..
			   "image_button[2.75,2.5;3,2;english_flag.png;english;English]"..
			   "label[1.5,4.75;Please note: This only affects the MineLife Specific Mods]"..
			   "image_button[2.75,5.5;3,2;deutsch_flagge.png;deutsch;Deutsch]"..
			   "label[1.15,7.75;Bitte beachte: Dies beeinflusst lediglich die MineLife Spezifischen Mods"
	elseif form == "welcome" then
		return "size[8.5,9]\n"..
				"image[2.75,0;3.5,1;MineLifeLogoBanner.png]".. 
				"image[0.15,1;10,8;willkommens_screen_text.png]"..
				"button[3.25,8;2,0.5;next;Next]"
	elseif form == "welcome-de" then
		return "size[8.5,9]\n"..
				"image[2.75,0;3.5,1;MineLifeLogoBanner.png]".. 
				"image[0.15,1;10,8;willkommens_screen_text-de.png]"..
				"button[3.25,8;2,0.5;next-de;Weiter]"
	elseif form == "citybuild-freebuild" then
		return 	"size[8.5,9]\n"..
				"image[0,0;10,9;willkommens_screen_citybuild_freebuild.png]".. 
				"button[3.25,8;2,0.5;next;Next]"
	elseif form == "citybuild-freebuild-de" then
		return 	"size[8.5,9]\n"..
				"image[0,0;10,9;willkommens_screen_citybuild_freebuild_de.png]".. 
				"button[3.25,8;2,0.5;next-de;Weiter]"
	elseif form == "transportsystem" then
		return  "size[8.5,9]\n"..
		"image[0,0;10,9;transportsystem.png]".. 
		"button[3.25,8;2,0.5;next;Next]"		
	elseif form == "transportsystem-de" then
		return  "size[8.5,9]\n"..
		"image[0,0;10,9;transportsystem-de.png]".. 
		"button[3.25,8;2,0.5;next;Next]"	
	elseif form == "berufe" then
		return  "size[8.5,9]\n"..
		"image[0,0;10,9;berufe.png]".. 
		"button[3.25,8;2,0.5;next;Next]"		
	elseif form == "berufe-de" then
		return  "size[8.5,9]\n"..
		"image[0,0;10,9;berufe-de.png]".. 
		"button[3.25,8;2,0.5;next;Next]"		
	elseif form == "admin-usershop" then
		return  "size[8.5,9]\n"..
		"image[0,0;10,9;admin_usershop.png]".. 
		"button[3.25,8;2,0.5;next;Next]"				
	elseif form == "admin-usershop-de" then
		return  "size[8.5,9]\n"..
				"image[0,0;10,9;admin_usershop_de.png]".. 
				"button[3.25,8;2,0.5;next;Next]"		
	elseif form == "rules" then
		return "size[8.5,9]\n"..
                "image[0,0;10,9;rules.png]"..
                "button[2.75,8;2,0.5;accept;Accept]"..
                "button[4.75,8;2,0.5;decline;Decline]"
	elseif form == "rules-de" then
		return "size[8.5,9]\n"..
                "image[0,0;10,9;rules-de.png]"..
                "button[2.75,8;2,0.5;accept-de;Akzeptieren]"..
                "button[4.75,8;2,0.5;decline-de;Ablehnen]"		
	elseif form == "last" then
		return "size[8.5,9]\n".. 
               "image[0,0;10,7;end.png]"..
               "button_exit[2.15,8;2.5,0.5;letsgo;Let's go]"..
               "button[4.5,8;2.5,0.5;wiki;Open Wiki]"
	elseif form == "last-de" then
		return "size[8.5,9]\n".. 
			   "image[0,0;10,7;end-de.png]"..
			   "button_exit[2.15,8;2.5,0.5;letsgo-de;Ins Spiel]"..
			   "button[4.5,8;2.5,0.5;wiki-de;Öffne Wiki]"
	end
    
end

local function showForm(playername, form) 
	minetest.after(0.1, minetest.show_formspec, playername, form_prefix..form, get_formspec(form))
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    local playername = player:get_player_name()
   -- minetest.chat_send_player(playername, "Player submitted fields "..dump(fields))    -- DEBUG COMMAND
	if formname == (form_prefix .. "guide") then
		
		--	
		-- Sprachauswahl
		--

	if fields["english"] then
	   		licenses_unassign(playername, "language-de")
			licenses_assign(playername, "language-en")			
			showForm(playername, "welcome")
		elseif fields["deutsch"] then
			licenses_unassign(playername, "language-en")
			licenses_assign(playername, "language-de")
			showForm(playername, "welcome-de")
		else 
			showForm(playername, "guide")
		end
		return true
	
	--
	-- Welcome
	--

	elseif formname == (form_prefix .. "welcome") then
		if fields["next"] then
			showForm(playername, "citybuild-freebuild")
		else
			showForm(playername, "guide")
		end
		return true
	elseif formname == (form_prefix .. "welcome-de") then
		if fields["next-de"] then
			showForm(playername, "citybuild-freebuild-de")
		else
			showForm(playername, "guide")
		end
		return true	
	
	--
	-- Citybuild & Freebuild
	--

	elseif formname == (form_prefix .. "citybuild-freebuild") then
		if fields["next"] then
			showForm(playername, "transportsystem")
		else
			showForm(playername, "citybuild-freebuild")
		end
		return true
	elseif formname == (form_prefix .. "citybuild-freebuild-de") then
		if fields["next-de"] then
			showForm(playername, "transportsystem-de")
		else
			showForm(playername, "citybuild-freebuild-de")
		end
		return true	
	
	--	
	-- Transportsystem
	--

	elseif formname == (form_prefix .. "transportsystem") then
		if fields["next"] then
			showForm(playername, "berufe")	
		else
			showForm(playername, "transportsystem")
		end
		return true	
	elseif formname == (form_prefix .. "transportsystem-de") then
		if fields["next"] then
			showForm(playername, "berufe-de")	
		else
			showForm(playername, "transportsystem-de")
		end
		return true	
	
	--	
	-- ADMIN & USERSHOP
	--

	elseif formname == (form_prefix .. "berufe") then
		if fields["next"] then
			showForm(playername, "admin-usershop")	
		else
			showForm(playername, "berufe")
		end
		return true	
	elseif formname == (form_prefix .. "berufe-de") then
		if fields["next"] then
			showForm(playername, "admin-usershop-de")	
		else
			showForm(playername, "berufe-de")
		end
		return true	

	--	
	-- ADMIN & USERSHOP
	--

	elseif formname == (form_prefix .. "admin-usershop") then
		if fields["next"] then
			showForm(playername, "rules")	
		else
			showForm(playername, "admin-usershop-de")
		end
		return true	
	elseif formname == (form_prefix .. "admin-usershop-de") then
		if fields["next"] then
			showForm(playername, "rules-de")	
		else
			showForm(playername, "admin-usershop-de")
		end
		return true	

	--	
	-- Regeln
	--

	elseif formname == (form_prefix .. "rules") then
		if fields["quit"] then
			showForm(playername, "rules")
		elseif fields["accept"] then
			showForm(playername, "last")
            licenses.revoke(playername, "news")
            licenses.revoke(playername, "beginnerguide")
        elseif fields["decline"] then
            minetest.kick_player(playername, "To play you have to accept the rules.")
		end
		return true
	elseif formname == (form_prefix .. "rules-de") then
		if fields["quit"] then
			showForm(playername, "rules-de")
		elseif fields["accept-de"] then
			showForm(playername, "last-de")
            licenses.revoke(playername, "news")
            licenses.revoke(playername, "beginnerguide")
        elseif fields["decline-de"] then
            minetest.kick_player(playername, "Akzeptiere die Regeln um zu spielen!.")
		end
		return true

	--	
	-- Letzter Screen
	--

	elseif formname == (form_prefix .. "last") then
		if fields["wiki"] then
            doc.show_doc(playername)
        end
		return true
	elseif formname == (form_prefix .. "last-de") then
		if fields["wiki-de"] then
            doc.show_doc(playername)
        end
		return true	
	end
	return false
end)

minetest.register_chatcommand("welcome_screen", {
    privs = {
    },
    func = function(name, param)
		showForm(name, "guide")
    end
})

minetest.register_on_joinplayer(function(player)
     local playername = player:get_player_name()
        if licenses_check_player_by_licese(playername, "beginnerguide") then  
			showForm(playername, "guide")
        end        
end)

-- minetest.register_on_newplayer(function(player)
--    local playername = player:get_player_name()
--    minetest.show_formspec(playername,"beginner_guide:guide", get_formspec()) 
--end)


