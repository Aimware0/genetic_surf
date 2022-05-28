AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )


function GM:Initialize()

end

function GM:PlayerSpawn(ply)
    ply:SetModel( "models/player/putin.mdl" )
    ply:SetCollisionGroup(10)
    ply:SetNoCollideWithTeammates(true)

end


hook.Add("PlayerSay", "PlayerChat", function(ply, text, team)
    if text == "!r" or text == "!restart" then
        ply:Spawn()
        ply:Respawn()
        print("Attempting to respawn")
    end
end)


concommand.Add("kill_add", function()
    for k, v in pairs(player.GetAll()) do
        if v:Nick() ~= "x" then
            v:Kill()
        end
    end
end)



print("init.lua loaded successfully")