local composer = require("composer")
local scene = composer.newScene()



display.setDefault("background", 24 / 255, 24 / 255, 25 / 255)


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

local particle_sprite_sheeet = nil

local function spriteListenerparticle(event)
	
	local this_sprite = event.target
	if event.phase == "ended" then
		this_sprite .isVisible = false
		this_sprite:removeSelf()
    	this_sprite  = nil
		
	end
end


local function onBackgroundTouch(event)
	if event.phase == "ended" then
		local option = {
			name = "particle_greenBurst",
			start = 1,
            count = 11,
            time = 1000,
			loopCount = 1
		}
		
		local particle_sprite = display.newSprite(particle_sprite_sheeet, option)
		particle_sprite.x = event.x
		particle_sprite.y = event.y
		particle_sprite.xScale = 2
		particle_sprite.yScale = 2
		particle_sprite:addEventListener("sprite", spriteListenerparticle)
		particle_sprite:play()
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
	
	local coin_sprite = graphics.newImageSheet("spinning_coin.png", {width = 64, height = 64, numFrames = 64})
	local cs = display.newSprite(coin_sprite, {start = 1, count = 64, time = 1000})
	cs.x = 500
	cs.y = 480
	cs.xScale = 2.5
    cs.yScale = 2.5
    cs:play()
	
	particle_sprite_sheeet = graphics.newImageSheet("green_burst.png", {width = 100, height = 100, numFrames = 11})
	
	sceneGroup:insert(background)
	sceneGroup:insert(cs)
	
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
