
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "genetic_algorthim.lua" )
AddCSLuaFile("sv_commands.lua")

include( "shared.lua" )
include("genetic_algorthim.lua")
include("sv_commands.lua")


local airaccelerate_difficulties = {
	Hard = 100,
	['Semi hard'] = 150,
	Medium = 200,
	Easy = 400,
	Fun = 800,
	['Extra easy'] = 1000
}

function GM:Initialize()
	RunConsoleCommand("sv_accelerate", "10")
	RunConsoleCommand("sv_airaccelerate", airaccelerate_difficulties["Extra easy"])
    RunConsoleCommand("bot_zombie", "1")
    -- RunConsoleCommand("sv_cheats", "1")
end


function GM:PlayerSpawn(ply)
    ply:SetModel("models/player/putin.mdl")
    ply:SetCollisionGroup(10)
    ply:SetPos(spawn_pos)
    ply:SetWalkSpeed(450)
end


hook.Add( "OnTeleport", "TestTeleportHook", function()
    local activator, caller = ACTIVATOR, CALLER
    activator:SetPos(spawn_pos)
end )


local function SetupMapLua()
    -- Thanks Phoenixf129 for providing code that allows OnTeleport hook to be available
    local MapLua = ents.Create( "lua_run" )
    MapLua:SetName( "triggerhook" )
    MapLua:Spawn()

    for _, v in ipairs( ents.FindByClass( "trigger_teleport" ) ) do
        v:Fire( "AddOutput", "OnStartTouch triggerhook:RunPassedCode:hook.Run( 'OnTeleport' ):0:-1" )
    end
end

hook.Add( "InitPostEntity", "SetupMapLua", SetupMapLua )
hook.Add( "PostCleanupMap", "SetupMapLua", SetupMapLua )


print("init.lua loaded successfully")