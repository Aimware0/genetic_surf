-- include("utils.lua")

GM.Name = "Genetic Surf"
GM.Author = "Riddle"
GM.Email = "N/A"
GM.Website = "N/A"
GM.Description = "A surf gamemode for the genetic/evolutionary algoritm."

DeriveGamemode("base")
-- target = Vector(-139.213165 ,-863.968750 ,10208.031250)
-- 5.058260 206.548828 10159.875000
target = Vector(-6939.958496 ,-3064.713135 ,-3519.968750)
spawn_pos = Vector(-12410.656250 ,-3384.428223 ,-895.245117)


if SERVER then
	-- Sends the files below to the client
	AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "cl_init.lua" )
	AddCSLuaFile( "ui/cl_mainframe.lua" )
	AddCSLuaFile( "utils.lua" )
end



print("shared.lua loaded successfully")
