-----------------------------------------------------------------------------------------------------------------------------
--
-- CastBar Class
--
----------------------------------------------------------------------------------------------------------------------------- 
UnitCastBar = {}
UnitCastBar.__index = UnitCastBar

--
-- Create a New UnitFrame
--
function UnitCastBar.new( unitName, width, height, thisAnchor, parentAnchor, parentItem, xOffset, yOffset )
	local uCastBar = {}             			-- our new object
	setmetatable(uCastBar, UnitCastBar)      	-- make UnitFrame handle lookup
	
	uCastBar.width = width
	uCastBar.height = height
	uCastBar.unitName = unitName
	uCastBar.itemOffset = MinUIConfig.frames[uCastBar.unitName].itemOffset
	uCastBar.casting = false
	uCastBar.visible = false
	uCastBar.iconSize = height
	uCastBar.channeled = false
	uCastBar.maxLength = 25 -- truncate after 20 characters?
	
	--
	-- CAST BAR STUFFS
	--
	-- TODO: config location and size and text values etc
	uCastBar.castbar = {}
	uCastBar.castbar.bar = UI.CreateFrame("Frame", uCastBar.unitName.."_castBar", parentItem )
	uCastBar.castbar.bar:SetPoint(thisAnchor, parentItem , parentAnchor, xOffset , yOffset ) -- ofset for icon
	uCastBar.castbar.bar:SetWidth(uCastBar.width) 
	uCastBar.castbar.bar:SetHeight(uCastBar.height) 
	uCastBar.castbar.bar:SetLayer(1)
	uCastBar.castbar.bar:SetVisible(uCastBar.visible)
	uCastBar.castbar.bar:SetBackgroundColor(0,0,0,0.3)

	
	uCastBar.castbar.solid = UI.CreateFrame("Frame", uCastBar.unitName.."_castBar", uCastBar.castbar.bar )
	uCastBar.castbar.solid:SetPoint("CENTERLEFT", uCastBar.castbar.bar, "CENTERLEFT", uCastBar.iconSize, 0 )
	uCastBar.castbar.solid:SetHeight(uCastBar.height) 
	uCastBar.castbar.solid:SetLayer(2)
	uCastBar.castbar.solid:SetWidth(uCastBar.width - uCastBar.iconSize)
	uCastBar.castbar.solid:SetVisible(true)

	
	-- Create textured component that resizes
	uCastBar.castbar.texture = UI.CreateFrame("Texture", uCastBar.unitName.."_texture", uCastBar.castbar.bar)
	if ( MinUIConfig.barTexture ) then
		----debugPrint( MinUIConfig.barTexture )
		uCastBar.castbar.texture:SetTexture("MinUI", "Media/"..MinUIConfig.barTexture..".tga")
	else
		uCastBar.castbar.texture:SetTexture("MinUI", "Media/aluminium.tga")
	end
	uCastBar.castbar.texture:SetPoint("CENTERLEFT", uCastBar.castbar.bar, "CENTERLEFT", uCastBar.iconSize, 0 )
	uCastBar.castbar.texture:SetWidth(uCastBar.width - uCastBar.iconSize)
	uCastBar.castbar.texture:SetLayer(1)
	uCastBar.castbar.texture:SetVisible(true)
	uCastBar.castbar.texture:SetBackgroundColor(0.0, 0.0, 0.0, 0.0)
	uCastBar.castbar.texture:SetHeight(uCastBar.height)
	
	uCastBar.castbar.leftText = UI.CreateFrame("Text", uCastBar.unitName.."_castBar",	uCastBar.castbar.bar  )
	uCastBar.castbar.leftTextShadow = UI.CreateFrame("Text", uCastBar.unitName.."_castBar",	uCastBar.castbar.bar  )
	uCastBar.castbar.leftTextShadow:SetFontColor(0,0,0,1)
	
	uCastBar.castbar.leftText:SetVisible(true)
	uCastBar.castbar.leftText:SetLayer(4)
	uCastBar.castbar.leftText:SetPoint("CENTERLEFT", uCastBar.castbar.bar, "CENTERLEFT", uCastBar.iconSize, 0 ) 
	uCastBar.castbar.leftTextShadow:SetVisible(true)
	uCastBar.castbar.leftTextShadow:SetLayer(3)
	uCastBar.castbar.leftTextShadow:SetPoint("CENTERLEFT", uCastBar.castbar.bar, "CENTERLEFT", uCastBar.iconSize+1,2 ) 
	
	--TODO Config
	uCastBar.castbar.leftText:SetFontSize(12)
	uCastBar.castbar.leftTextShadow:SetFontSize(12)

	-- Set Fonts
	if not (MinUIConfig.globalTextFont == "default") then
		uCastBar.castbar.leftText:SetFont("MinUI", MinUIConfig.globalTextFont..".ttf")
		uCastBar.castbar.leftTextShadow:SetFont("MinUI", MinUIConfig.globalTextFont..".ttf")
	end
	
	uCastBar.castbar.leftText:SetText("???")
	uCastBar.castbar.leftText:SetHeight(uCastBar.castbar.leftText:GetFullHeight())
	uCastBar.castbar.leftTextShadow:SetText("???")
	uCastBar.castbar.leftTextShadow:SetHeight(uCastBar.castbar.leftText:GetFullHeight())
	
	
	uCastBar.castbar.rightText = UI.CreateFrame("Text", uCastBar.unitName.."_castBar",	uCastBar.castbar.bar  )
	uCastBar.castbar.rightTextShadow = UI.CreateFrame("Text", uCastBar.unitName.."_castBar",	uCastBar.castbar.bar  )
	uCastBar.castbar.rightTextShadow:SetFontColor(0,0,0,1)
	
	uCastBar.castbar.rightText:SetVisible(true)
	uCastBar.castbar.rightText:SetLayer(4)
	uCastBar.castbar.rightText:SetPoint("CENTERRIGHT", uCastBar.castbar.bar, "CENTERRIGHT" )
	uCastBar.castbar.rightTextShadow:SetVisible(true)
	uCastBar.castbar.rightTextShadow:SetLayer(3)
	uCastBar.castbar.rightTextShadow:SetPoint("CENTERRIGHT", uCastBar.castbar.bar, "CENTERRIGHT", 1,2 )
	
	--TODO Config
	uCastBar.castbar.rightText:SetFontSize(12)
	uCastBar.castbar.rightTextShadow:SetFontSize(12)

	-- Set Fonts
	if not (MinUIConfig.globalTextFont == "default") then
		uCastBar.castbar.rightText:SetFont("MinUI", MinUIConfig.globalTextFont..".ttf")
		uCastBar.castbar.rightTextShadow:SetFont("MinUI", MinUIConfig.globalTextFont..".ttf")
	end
	
	uCastBar.castbar.rightText:SetText("???")
	uCastBar.castbar.rightText:SetHeight(uCastBar.castbar.rightText:GetFullHeight())
	uCastBar.castbar.rightTextShadow:SetText("???")
	uCastBar.castbar.rightTextShadow:SetHeight(uCastBar.castbar.rightText:GetFullHeight())
	
	-- icon
	uCastBar.castbar.icon = UI.CreateFrame("Texture", uCastBar.unitName.."_icon", uCastBar.castbar.bar)
	uCastBar.castbar.icon:SetLayer(5)
	uCastBar.castbar.icon:SetPoint("CENTERLEFT", uCastBar.castbar.bar, "CENTERLEFT" )
	uCastBar.castbar.icon:SetHeight(uCastBar.height)
	uCastBar.castbar.icon:SetWidth(uCastBar.height)
	
	-- return the new "object"
	return uCastBar
end


--
-- Return a handle to the main frame of this unit
--
function UnitCastBar:getFrame()
	return self.castbar.bar
end

--
-- Animate the Cast Bar
--
function UnitCastBar:animate( )
	if ( self.visible ) then
		if ( self.casting ) then
			local unitCastBar = Inspect.Unit.Castbar( self.unitName )
			if (unitCastBar) then
				local remaining = unitCastBar.remaining
				local duration = unitCastBar.duration
				if(remaining and duration)then
					local rightText = string.format("[%.2f/%.2f]", remaining, duration)
				
					self.castbar.rightText:SetText(rightText)
					self.castbar.rightText:SetWidth(self.castbar.rightText:GetFullWidth())
					self.castbar.rightTextShadow:SetText(rightText)
					self.castbar.rightTextShadow:SetWidth(self.castbar.rightText:GetFullWidth())
					
					--debugPrint ( rightText )
				
					-- FILL 
					if not self.channeled then
						local widthMultiplier = (1 - (remaining / duration))
						self.castbar.solid:SetWidth((self.width - self.iconSize) * widthMultiplier)
						self.castbar.texture:SetWidth((self.width - self.iconSize) * widthMultiplier)
					else -- UNFILL :P
						local widthMultiplier = ((remaining / duration))
						self.castbar.solid:SetWidth((self.width - self.iconSize) * widthMultiplier)
						self.castbar.texture:SetWidth((self.width - self.iconSize) * widthMultiplier)
					end
				end
			else
				self.castbar.bar:SetVisible(false)
				self.visible = false
				self.castbar.leftText:SetText("")
				self.castbar.rightText:SetText("")
				self.castbar.leftTextShadow:SetText("")
				self.castbar.rightTextShadow:SetText("")
			end
		end
	end
end

--
-- Unit Castbar Status Changed
--
function UnitCastBar:syncCastbar( casting )
	-- store casting value for animation updats
	self.casting = casting
	
	-- if we have begun casting then update the cast bar with the values
	if(self.casting)then
		local unitCastBar = Inspect.Unit.Castbar( self.unitName )
		local abilityName = unitCastBar.abilityName
		local uninterruptible = unitCastBar.uninterruptible
		
		debugPrint(self.unitName, " is casting ", abilityName )
		
		self.castbar.bar:SetVisible(true)
		self.visible = true

		
		if(string.len(abilityName) >= self.maxLength)then
			abilityName = string.sub(abilityName, 1, self.maxLength-3)
			abilityName = abilityName .. "..."
		end
		
		self.castbar.leftText:SetText(abilityName)
		self.castbar.leftText:SetWidth(self.castbar.leftText:GetFullWidth())
		self.castbar.leftTextShadow:SetText(abilityName)
		self.castbar.leftTextShadow:SetWidth(self.castbar.leftText:GetFullWidth())
		
		if(unitCastBar.ability)then
			local abilityDetails = Inspect.Ability.Detail(unitCastBar.ability)
			if(abilityDetails)then
				self.channeled = abilityDetails.channeled
				if(abilityDetails.icon)then
					self.castbar.icon:SetTexture("Rift", abilityDetails.icon)
				else
					self.castbar.icon:SetTexture("Rift", "apple.dds")
				end
			else
				self.castbar.icon:SetTexture("Rift", "apple.dds") -- use a placeholder 
			end
		else
			self.castbar.icon:SetTexture("Rift", "apple.dds") -- use a placeholder 
		end
		
		if ( uninterruptible ) then
			self.castbar.bar:SetBackgroundColor(0.2,0.2,0.2,0.3)
			self.castbar.solid:SetBackgroundColor(0.2,0.2,0.2,0.6)
		else
			self.castbar.bar:SetBackgroundColor(0.2,0.4,1.0,0.3)
			self.castbar.solid:SetBackgroundColor(0.2,0.4,1.0,0.6)
		end
	else
		self.castbar.bar:SetVisible(false)
		self.visible = false
		self.castbar.leftText:SetText("")
		self.castbar.rightText:SetText("")
		self.castbar.leftTextShadow:SetText("")
		self.castbar.rightTextShadow:SetText("")
	end
end