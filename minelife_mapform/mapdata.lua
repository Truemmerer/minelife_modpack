mapform_data = {
    ["entries"] = {
        {
            ["name"] = "Vallee",
            ["buttons"] = {
                {
                    ["name"] = "Region Vallee",
                    ["picture"] = "region_vallee.png"
                },{
                    ["name"] = "Vallee City",
                    ["picture"] = "city_vallee.png"
                },{
                    ["name"] = "Vallee Train Map",
                    ["picture"] = "trains_vallee.png"
                },{
                    ["name"] = "Vallee Subway",
                    ["picture"] = "sub_vallee.png"
                }
            }
        --[[
        },{
            ["name"] = "Freebuild Area",
            ["buttons"] = {
                {
                    ["name"] = "Freebuild Area",
                    ["picture"] = "freebuild_area.png"
                },{
                    ["name"] = "Freebuild Area Train Map",
                    ["picture"] = "trains_freebuild_area.png"
                }
            }
        --]]           
        },{
            ["name"] = "Oxania (Beginner Region)",
            ["buttons"] = {
                {
                    ["name"] = "Region Oxania",
                    ["picture"] = "region_oxania.png"
                },{
                    ["name"] = "Oxania Train Map",
                    ["picture"] = nil
                }
            }     
        },{
            ["name"] = "Freebuild (Asmania)",
            ["buttons"] = {
                {
                    ["name"] = "Freebuild (Asmania)",
                    ["picture"] = "region_asmania.png"
                },{
                    ["name"] = "Freebuild Train Map",
                    ["picture"] = "trains_asmania.png"
                }
            }
        },{
            ["name"] = "Baca",
            ["buttons"] = {
                {
                    ["name"] = "Region Baca",
                    ["picture"] = "region_baca.png"
                },{
                    ["name"] = "Testtropolis City",
                    ["picture"] = "city_testtropolis.png"
                },{
                    ["name"] = "Baca Train Map",
                    ["picture"] = "trains_baca.png"
                },{
                    ["name"] = "Baca Subway",
                    ["picture"] = "sub_baca.png"
                }
            }
        },{
            ["name"] = "Jovis",
            ["buttons"] = {
                {
                    ["name"] = "Region Jovis",
                    ["picture"] = "region_jovis.png"
                },{
                    ["name"] = "Jovis Train Map",
                    ["picture"] = "trains_jovis.png"
                }
            }
       },{
            ["name"] = "Manistare",
            ["buttons"] = {
                {
                    ["name"] = "Region Manistare",
                    ["picture"] = "region_manistare.png"
                },{
                    ["name"] = "Manistare Train Map",
                    ["picture"] = nil
                }
            }
        },{
            ["name"] = "Zephyrus",
            ["buttons"] = {
                {
                    ["name"] = "Region Zephyrus",
                    ["picture"] = "region_zephyrus.png"
                },{
                    ["name"] = "Zephyrus Train Map",
                    ["picture"] = nil
                }
            }
        }
    },
    ["buttons"] = {}
}

local name = ""

for i = 1, #mapform_data.entries, 1 do
	name = mapform_data["entries"][i]["name"]
	for j = 1, #mapform_data["entries"][i]["buttons"], 1 do
		mapform_data["buttons"][i.."_"..j] = mapform_data["entries"][i]["buttons"][j]
	end

end
