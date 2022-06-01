
-- Every UI element will be within this main ui DFrame

local MainFrame = {
    Init = function(self)
        self:SetSize(ScrW() * 0.5, ScrH() * 0.5)
        self:Center()
        self:MakePopup()
        self:SetTitle("Genetic Surf")
        self:SetDeleteOnClose(false)
        

        local slider = vgui.Create("DNumSlider", self)
        slider:SetPos(10, 10)
        slider:SetSize(self:GetWide() - 150, 50)
        slider:SetText("Bots")
        slider:SetMin(1)
        slider:SetMax(128)
        -- slider:SetD
        slider:SetValue(5)
        slider:SetDecimals(0)

        local add_bots_btn = vgui.Create("DButton", self)
        add_bots_btn:SetPos(self:GetWide() - 140, 25)
        add_bots_btn:SetSize(130, 30)
        add_bots_btn:SetText("Add Bots")
        add_bots_btn.DoClick = function()
            local num_of_bots = #filter(player.GetAll(), function(ply) return ply:IsBot() end)
            local num_of_bots_to_add = slider:GetValue() - num_of_bots
            for i=1, num_of_bots_to_add do
                RunConsoleCommand("bot")
            end
        end

    end
}

vgui.Register("MainFrame", MainFrame, "DFrame")