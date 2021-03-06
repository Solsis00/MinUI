--
-- RogueComboBar Module by Grantus
--
-- Registers for Rogue Combo Point Updates
--

local RogueComboBar = {}
RogueComboBar.__index = RogueComboBar

--
-- RogueComboBar:new()
--
-- @params
--		unit string: player, player.target, etc
--
function RogueComboBar.new( unit )
	local cBar = {}             		-- our new object
	setmetatable(cBar, RogueComboBar)    	-- make RogueComboBar handle lookup
	
	-- the modules unit
	cBar.unit = unit -- Charge bar unit doesnt matter as it will always check "player"
	-- the modules enabled status
	cBar.enabled = true
	
	--
	-- Every module must have a settings table, such that it can be configured by AddOns
	--
	cBar.settings = {
		["width"] = 0,
		["height"] = 0,
		["texturePath"] = 0,
		["padding"] = 0,
		["anchor"] = 0,
		["anchorUnit"] = 0,
		["anchorPointThis"] = 0,
		["anchorPointParent"] = 0,
		["anchorXOffset"] = 0,
		["anchorYOffset"] = 0
	}

	--
	-- main items of the bar
	--
	cBar.panel = nil
	cBar.comboPointsBars = {}
	
	cBar.simulating = false
	
	--
	-- Note: nothing is actually created here, that occurs in the Initialise function, which
	-- should be called after the settings above have been filled out by an AddOn
	--

	return cBar
end



--
-- Required Widget Functions: Modules are themselves "widgets" only they also register themselves for event callbacks
--

--
-- SetPoint
--
-- @params
--		anchorSelf string: the point on the Box that shall anchor to the anchorItem expects rift style TOPCENTER, LEFT, etc
--		newParent table: frame this Box anchors on, expects a rift frame
--		anchorParent string: the point on the anchor shall the Box anchor on
--		xOffset number: the x offset
--		yOffset number: the y offset
--
function RogueComboBar:SetPoint( anchorSelf, newParent, anchorParent, xOffset, yOffset )
	self.panel:SetPoint( anchorSelf, newParent, anchorParent, xOffset, yOffset ) 
end

--
-- SetVisibility
--
function RogueComboBar:SetVisible ( toggle )
	self.panel:SetVisible( toggle )
end

--
-- GetFrame
--
function RogueComboBar:GetFrame()
	return self.panel:GetFrame()
end

--
-- GetHeight 
--
function RogueComboBar:GetHeight()
	return self.settings.height
end

--
-- Get Width
--
function RogueComboBar:GetWidth()
	return self.settings.width
end

--
-- RogueComboBar Functions
--

--
-- Update Charge
--
function RogueComboBar:Update( details  )
	if ( details ) then
		if ( details.calling or self.simulating ) then -- guard against this sometime being nil
			if ( details.calling == "rogue" or self.simulating ) then
				if ( details.comboUnit or self.simulating ) then
					local unit = Inspect.Unit.Lookup(details.comboUnit)
					print ( "unit -> ", unit )			
					if ( unit == "player.target" or self.simulating ) then
						local points = details.combo
						
						-- set bars invisible
						self:HideBars()
						-- for 1->currentPoints make bars visible
						self:ShowBars(points)
						
						--self:SetVisible(true)
					else
						self:SetVisible(false)
					end
				else
					-- no combo unit
					self:SetVisible(false)
				end
			else
				-- not a rogue
				self:SetVisible(false) 
			end
		-- no calling
		else
			self:SetVisible(false) 
		end
	-- no details
	else
		self:SetVisible(false)
	end
end


function RogueComboBar:HideBars()
	for i=1,5 do
		self.comboPointsBars[i]:SetVisible(false)
	end
end
function RogueComboBar:ShowBars(points)
	for i=1,points do
		self.comboPointsBars[i]:SetVisible(true)
	end
end



--
-- Required Functions for a Module
--

--
-- Get the Empty Settings Table for this Module
--
function RogueComboBar:GetSettingsTable()
	return self.settings
end

--
-- Initialise the Module
--
function RogueComboBar:Initialise( )
	self.panel = Panel.new( self.settings["width"], self.settings["height"], {r=0,g=0,b=0,a=0}, gUF.context, 1 )
	
	for i=1,5 do
		local comboPointBar = Bar.new( ((self.settings["width"]-self.settings["padding"])/5), self.settings["height"], "horizontal", "right", gUF_Colors["rogueCombo_background"], gUF_Colors["rogueCombo_foreground"], self.settings["texturePath"], gUF.context, (self.panel:GetLayer()+1)  )
		self.comboPointsBars[i] = comboPointBar
		self.panel:AddItem( self.comboPointsBars[i], "TOPLEFT", "TOPLEFT", ((i-1)*(self.settings["width"]/5)), 0 )
	end

	self.panel:SetVisible( false )
end

--
-- Charge is only given to player, so we don't need to check self.unit
--
function RogueComboBar:Refresh()
	local details = Inspect.Unit.Detail("player")
	if(details)then
		self:Update( details )
	else
		self:SetVisible(false)
	end
	
end

--
-- Simualte a Charge Update
--
function RogueComboBar:Simulate()
	self.simulating = true
	self:Update( gUF_Utils:GenerateSimulatedUnit() )
end


--
-- For simplicity's sake a module must have a method called "CallBack" which can take a number of arguments
--
function RogueComboBar:CallBack( eventType, value ) -- not using value for now ...
	if ( self.enabled ) then
		if ( eventType == COMBO_UPDATE ) then
			if not self.simulating then
				self:Refresh()			
			end
		elseif ( eventType == COMBO_UNIT_UPDATE ) then
			if not self.simulating then
				self:Refresh()			
			end
		elseif ( eventType == UNIT_AVAILABLE ) then
			if not self.simulating then
				self:Refresh()			
			end 
		elseif ( eventType == UNIT_CHANGED ) then
			if not self.simulating then
				self:Refresh()			
			end				
		elseif ( eventType == SIMULATE_UPDATE ) then
			self:Simulate()
		end
	end
end

--
-- Required Function for a Module
--
-- Register Callbacks with gUF
--
function RogueComboBar:RegisterCallbacks()
	table.insert(gUF_EventHooks, { COMBO_UPDATE, self.unit, self })
	table.insert(gUF_EventHooks, { COMBO_UNIT_UPDATE, self.unit, self })
	table.insert(gUF_EventHooks, { UNIT_AVAILABLE, self.unit, self })
	table.insert(gUF_EventHooks, { UNIT_CHANGED, self.unit, self })
	table.insert(gUF_EventHooks, { SIMULATE_UPDATE, self.unit, self })
end

--
-- Required Function for a Module
--
-- Starts/Stops this module from reacting to events
--
function RogueComboBar:SetEnabled( toggle )
	self.enabled = toggle
end

--
-- *** Register this Module with gUF ***
--
gUF_Modules["RogueComboBar"] = RogueComboBar