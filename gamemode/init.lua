AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )



hook.Add("PlayerSay", "PlayerChat", function(ply, text, team)
    if text == "!r" or text == "!restart" then
        ply:Spawn()
        ply:Respawn()
        print("Attempting to respawn")
    end
end)






print("init.lua loaded successfully")