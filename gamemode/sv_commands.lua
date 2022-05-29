-- File for chat commands / console commands

hook.Add("PlayerSay", "PlayerChat", function(ply, text, team)
    if text == "!r" or text == "!restart" then
        ply:Spawn()
        return false -- Stops the chat message from being sent to the chatbox
    end
end)

concommand.Add("kick_all", function()
    for k, v in pairs(player.GetAll()) do
        if v:IsBot() then
            v:Kick()
        end
    end
end)

concommand.Add("kill_all", function()
    for k, v in pairs(player.GetAll()) do
        if v:IsBot() then
            v:Kill()
        end
    end
end)


concommand.Add("noclip", function(ply)
    if ply:GetMoveType() == MOVETYPE_NOCLIP then
        ply:SetMoveType(MOVETYPE_WALK)
    else
        ply:SetMoveType(MOVETYPE_NOCLIP)
    end
end)

