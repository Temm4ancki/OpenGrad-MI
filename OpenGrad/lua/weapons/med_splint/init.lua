include("shared.lua")

local healsound1 = Sound("weapons/medical/snd_jack_bandage.ogg")
local healsound2 = Sound("weapons/medical/snd_jack_bandage.ogg")
--LeftLeg
function SWEP:Heal(ent)
	if not ent or not ent:IsPlayer() then
		if table.HasValue(LeftLeg, RightLeg, ent) then
			sound.Play(healsound1, ent:GetPos(), 75, 100, 0.5)
			return true
		else
			return
		end
	end

	if ent.LeftLeg == 0.6 then
		ent.LeftLeg = 1

		if ent.LeftLeg == 1 then
			ent:EmitSound(healsound1)
		else
			ent:EmitSound(healsound2)
		end

		return true
	end

	if ent.RightLeg == 0.6 then
		ent.RightLeg = 1

		if ent.RightLeg == 1 then
			ent:EmitSound(healsound1)
		else
			ent:EmitSound(healsound2)
		end

		return true
	end
end