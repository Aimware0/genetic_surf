include("shared.lua")
include("utils.lua")
include("ui/cl_mainframe.lua")

main_frame = vgui.Create("MainFrame")

concommand.Add("open_menu", function()
    main_frame:SetVisible(true)
end)

print("cl_init loaded successfully")


hook.Add("HUDPaint", "draw_target_text", function()
    -- local target = Vector(-2.672320, 1076.718994, 10084.031250)
    local pos = target:ToScreen()
    -- draw.SimpleText("Target", "DermaLarge", pos.x, pos.y, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    -- Draw a circlular target.
    surface.SetDrawColor(255, 0, 0, 255)
    surface.DrawCircle(pos.x, pos.y, 10)
    -- White dot inside target
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawCircle(pos.x, pos.y, 5)

    -- Put names above the heads of the agents
    for k, v in pairs(player.GetAll()) do
        if v:IsBot() then
            local pos = v:GetPos():ToScreen()
            draw.SimpleText(v:Nick(), "DermaLarge", pos.x, pos.y, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end)