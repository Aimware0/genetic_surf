GM.Name = "Genetic Surf"
GM.Author = "Riddle"
GM.Email = "N/A"
GM.Website = "N/A"
GM.Description = "A surf gamemode for the genetic/evolutionary algoritm."

DeriveGamemode("base")

local airaccelerate_difficulties = {
	Hard = 100,
	['Semi hard'] = 150,
	Medium = 200,
	Easy = 400,
	Fun = 800,
	['Extra easy'] = 1000
}

function GM:Initialize()
	-- set sv_accelerate 10.
	RunConsoleCommand("sv_accelerate", "10")
	RunConsoleCommand("sv_airaccelerate", airaccelerate_difficulties["Extra easy"])
end

print("shared.lua loaded successfully")
