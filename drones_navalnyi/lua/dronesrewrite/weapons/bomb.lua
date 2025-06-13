DRONES_REWRITE.Weapons["Bomb"] = {
	Initialize = function(self)
		self:AddHook("DroneDestroyed", "bomb_destr", function()
			ParticleEffect("splode_big_main", self:GetPos(), Angle(0, 0, 0))

			util.BlastDamage(self, IsValid(self:GetDriver()) and self:GetDriver() or self, self:GetPos(), 300, 200 * .1)
			self:Remove()
		end)

		return DRONES_REWRITE.Weapons["Template"].InitializeNoDraw(self)
	end,

	Think = function(self, gun)
		DRONES_REWRITE.Weapons["Template"].Think(self, gun)
	end,
	
	Attack = function(self, gun)
		self:Destroy()
	end
}