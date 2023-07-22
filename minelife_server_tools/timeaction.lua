backup_message = function()

    local stunde  = tonumber( os.date( "%H"));
    local minute  = tonumber( os.date( "%M"));
   
 
    if stunde == 3 and minute == 30 then
        minetest.chat_send_all(colorize("#1 !!! Server Backup in 20 Minutes !!!"))
    elseif stunde == 3 and minute == 50 then
        minetest.chat_send_all(colorize("#1 !!! Server Backup: The server is about to be shut down. After the backup it is back again. This can take up to 1 Hour. !!!")) 
    elseif
        stunde == nil or minute == nil then
        minetest.log("timeaction: minute or hour is a nil value")
        else
        -- minetest.chat_send_all(colorize("#0 timeaction it is not the time. Stunde: "..stunde.." Minute: " ..minute..""))
    end

    minetest.after( 30, backup_message);

end


-- first call (after the server has been started)
 minetest.after(5, backup_message);
