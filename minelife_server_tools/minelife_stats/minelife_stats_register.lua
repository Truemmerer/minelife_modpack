--------------------
-- Register Stats
--------------------
 
---- First Login
minelife_stats.register_stat({
	name = "firstlogin_day",
	description = function(value)
		return ""..value
	end,
})

minelife_stats.register_stat({
	name = "firstlogin_month",
	description = function(value)
		return ""..value
	end,
})

minelife_stats.register_stat({
	name = "firstlogin_year",
	description = function(value)
		return ""..value
	end,
})

minelife_stats.register_stat({
	name = "firstlogin_hour",
	description = function(value)
		return ""..value
	end,
})

minelife_stats.register_stat({
	name = "firstlogin_minute",
	description = function(value)
		return ""..value
	end,
})

minelife_stats.register_stat({
	name = "firstlogin_second",
	description = function(value)
		return ""..value
	end,
})
---- First Login End

minelife_stats.register_stat({
	name = "played_time",
	description = function(time)
		return " - Time played: "..time
	end,
})


minelife_stats.register_stat({
	name = "player_ip",
	description = function(value)
		return ""..value
	end,
})

minelife_stats.register_stat({
	name = "died",
	description = function(value)
		return " - Died: "..value
	end,
})