if CLIENT then
    net.Receive("CameraFlashEffect", function()
        local dlight = DynamicLight(LocalPlayer():EntIndex())
        if dlight then
            dlight.pos = LocalPlayer():GetShootPos()
            dlight.r = 255
            dlight.g = 255
            dlight.b = 255
            dlight.brightness = 6
            dlight.Decay = 1000
            dlight.Size = 500
            dlight.DieTime = CurTime() + 0.1
        end

        LocalPlayer():EmitSound("ambient/energy/zap1.wav")
    end)
else
    util.AddNetworkString("CameraFlashEffect")
end
