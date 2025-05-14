
local PANEL = {}

AccessorFunc( PANEL, 's_imageurl', 'ImageURL', FORCE_STRING )
AccessorFunc( PANEL, 'b_uselocal', 'UseLocalImage', FORCE_BOOL )

function PANEL:Init()
    self.imageWidth = 0
    self.imageHeight = 0

    self:SetImageURL( '' )
    self:SetUseLocalImage( false )
    self:SetText( '' )
    
    self:SetCursor( 'hand' )
end

function PANEL:SetImageSize( w, h )
    self.imageWidth = w
    self.imageHeight = h
end

function PANEL:Paint( w, h )
    local adjustedWidth = (self.imageWidth/self.imageHeight) * h
    local offset = w*0.5 - adjustedWidth*0.5

    if self:GetUseLocalImage() or string.StartWith(self:GetImageURL(), "maps/") then
        if not self.materialCache then
            self.materialCache = Material(self:GetImageURL())
        end

        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(self.materialCache)
        surface.DrawTexturedRect(offset, 0, adjustedWidth, h)
    else
        draw.WebImage( self:GetImageURL(), offset, 0, adjustedWidth, h, Color( 255, 255, 255 ) )
    end
end

function PANEL:DoClick()
    self:GetParent():DoClick()
end

vgui.Register( 'SolidMapVoteImage', PANEL, 'DButton' )
