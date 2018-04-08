local composer = require("composer")
local scene = composer.newScene()


local default_centerX = display.contentCenterX
local default_centerY = display.contentCenterY
local default_originX = display.screenOriginX
local default_originY = display.screenOriginY

local default_width = display.contentWidth
local default_height = display.contentHeight
local default_width_half = display.contentWidth * 0.5
local default_height_half = display.contentHeight * 0.5


local default_width_a = display.actualContentWidth
local default_height_a = display.actualContentHeight



display.setDefault("background", 24 / 255, 24 / 255, 25 / 255)

local mario = nil

local default_centerX = display.contentCenterX
local default_centerY = display.contentCenterY
local default_originX = display.screenOriginX
local default_originY = display.screenOriginY

local default_width = display.contentWidth
local default_height = display.contentHeight
local default_width_half = display.contentWidth * 0.5
local default_height_half = display.contentHeight * 0.5


local default_width_a = display.actualContentWidth
local default_height_a = display.actualContentHeight



local function onBackgroundTouch(event)
	if event.phase == "ended" then
		transition.to(mario, {time = 500, x = event.x, y = event.y})
	end
	return true
end



function scene:create(event)
	local sceneGroup = self.view
	local background = display.newRect(0, 0, default_width_a, default_height_a)
	background.x = default_width_half
	background.y = default_height_half
	background:setFillColor(0.2, 0.5, 2)
	background:addEventListener("touch", onBackgroundTouch)
	
	mario = display.newImageRect("mario.png", 190, 250)
	mario.x = default_width_half
	mario.y = default_height_half
	
	sceneGroup:insert(background)
	sceneGroup:insert(mario)
end

function scene:show(event)
	local phase = event.phase
	if phase == "did" then
		
	end
end

function scene:hide(event)
	local phase = event.phase
	if phase == "will" then
		
	end
end


























scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
