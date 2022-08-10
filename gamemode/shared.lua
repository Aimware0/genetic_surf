-- include("utils.lua")

GM.Name = "Genetic Surf"
GM.Author = "Riddle"
GM.Email = "N/A"
GM.Website = "N/A"
GM.Description = "A surf gamemode for the genetic/evolutionary algoritm."

DeriveGamemode("base")
-- target = Vector(-139.213165 ,-863.968750 ,10208.031250)
-- 5.058260 206.548828 10159.875000


target_pos = string.Split("-1007.968750 -1903.968750 -79.968750", " ")
spawn_pos = string.Split("-1347.771851 -954.932068 -79.968750", " ")



spawn_pos = Vector(tonumber(spawn_pos[1]), tonumber(spawn_pos[2]), tonumber(spawn_pos[3]))
target_pos = Vector(tonumber(target_pos[1]), tonumber(target_pos[2]), tonumber(target_pos[3]))



if SERVER then
	-- Sends the files below to the client
	AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "cl_init.lua" )
	AddCSLuaFile( "ui/cl_mainframe.lua" )
	AddCSLuaFile( "utils.lua" )
end



print("shared.lua loaded successfully")
