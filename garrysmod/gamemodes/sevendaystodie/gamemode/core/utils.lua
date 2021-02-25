concommand.Add("pos", function(pl)
    local pos = pl:GetPos()
    local text = "" .. math.Round(pos.x, 0) .. ", " .. math.Round(pos.y,0) .. ", " .. math.Round(pos.z + 64,0) .. ""
    local textfeet = "" .. math.Round(pos.x, 0) .. ", " .. math.Round(pos.y,0) .. ", " .. math.Round(pos.z,0) .. ""

    pl:ChatPrint("Eye position: "..tostring(text))
    pl:ChatPrint("Feet position: "..tostring(textfeet).." (Clipboarded)")
    pl:SendLua([[SetClipboardText("Vector(]] .. textfeet .. [[)")]])
end )