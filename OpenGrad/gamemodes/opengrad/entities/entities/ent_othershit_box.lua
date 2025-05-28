AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Бокс"
ENT.Author = "0oa"
ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	--util.AddNetworkString("Box")
	function ENT:Initialize()
		self:SetModel("models/Items/ammocrate_ar2.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
	end

	function ENT:Use(activator, caller)
		--[[net.Start("Box")
		net.WriteEntity(activator)
		net.Broadcast()]]
		activator:ChatPrint("Sharik tupoy hurrep")
		activator:EmitSound("hg_homicide/sfx/hmcd_fart.ogg")
	end
else
	--[[local openVgui = function(ent)
        local panel = vgui.Create("DFrame")
        panel:SetSize(300,400)
        panel:Center()
        panel:SetTitle("Бокс")
    end

    net.Receive("Box",function()
        openVgui(net.ReadEntity())
    end)]]
end