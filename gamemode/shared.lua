-- include("utils.lua")

GM.Name = "Genetic Surf"
GM.Author = "Riddle"
GM.Email = "N/A"
GM.Website = "N/A"
GM.Description = "A surf gamemode for the genetic/evolutionary algoritm."

DeriveGamemode("base")


if SERVER then
	-- Sends the files below to the client
	AddCSLuaFile( "shared.lua" )
	AddCSLuaFile( "cl_init.lua" )
	AddCSLuaFile( "ui/cl_mainframe.lua" )
	AddCSLuaFile( "utils.lua" )
end



print("shared.lua loaded successfully")
