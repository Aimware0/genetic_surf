include("shared.lua")
include("utils.lua")
include("ui/cl_mainframe.lua")

main_frame = vgui.Create("MainFrame")

concommand.Add("open_menu", function()
    main_frame:SetVisible(true)
end)

print("cl_init loaded successfully")
