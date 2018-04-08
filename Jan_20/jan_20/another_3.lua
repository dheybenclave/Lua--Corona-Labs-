
local composer = require("composer")
local scene = composer.newScene()
local dpad = require("dpad")
local gamePad = dpad.newDPad(450, "pad.png", 0.8, false)


display.setDefault("background", 25 / 255, 12 / 255, 25 / 255)
local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = display.contentWidth * 0.5
local halfH = display.contentHeight * 0.5

local linkSprite = nil
local movementSpeed = 0.3
local prevTime = 0

local function getDeltaTime()
	local currTime = system.getTimer()
	local dTime = currTime - prevTime
	prevTime = currTime
	return dTime
end



local function Sequence()
	
	local linkSpriteSheet = graphics.newImageSheet("asd.png ", {width = 192 , height = 192 , numFrames = 12})
	local linkAnimationSequenes = {
		{
			name = "idle_down", sheet = linkSpriteSheet,
			start = 1, count = 6, time = 500,
			loopDirection = "forward"
		},
		{
			name = "idle_left", sheet = linkSpriteSheet,
			start = 7, count = 6, time = 800,
			loopCount = 1, loopDirection = "bounce"
		},
		{
			name = "idle_up", sheet = linkSpriteSheet,
			start = 13, count = 6, time = 800,
			loopCount = 1, loopDirection = "bounce"
		},
		{
			name = "idle_right", sheet = linkSpriteSheet,
			start = 31, count = 3, time = 800,
			loopCount = 1, loopDirection = "bounce"
		},
		{
			name = "walk_down", sheet = linkSpriteSheet,
			start = 41, count = 10, time = 800,
			loopCount = 0, loopDirection = "bounce"
		},
		{
			name = "walk_left", sheet = linkSpriteSheet,
			start = 51, count = 10, time = 800,
			loopCount = 0, loopDirection = "bounce"
		},
		{
			name = "walk_up", sheet = linkSpriteSheet,
			start = 61, count = 10, time = 800,
			loopCount = 0, loopDirection = "bounce"
		},
		{
			name = "walk_right", sheet = linkSpriteSheet,
			start = 71, count = 10, time = 800,
			loopCount = 0, loopDirection = "bounce"
		}
	}
	
	linkSprite = display.newSprite(linkSpriteSheet, linkAnimationSequenes)
	linkSprite.x = halfW
	linkSprite.y = halfH
	linkSprite:setSequence("idle_down")
	linkSprite:play()
	
	linkSprite.isMovingUp = false
	linkSprite.isMovingDown = false
	linkSprite.isMovingLeft = false
	linkSprite.isMovingRight = false
	linkSprite.walkingDirection = nil
end



function scene:create(event)
	local sceneGroup = self.view
	
	
	Sequence()
	
	
	
	
	sceneGroup:insert(linkSprite)
end

function onEnterFrame(event)
	local dTime = getDeltaTime()
	if gamePad.isMoving then
		if gamePad.isMovingUp then
			linkSprite.y = linkSprite.y -(movementSpeed * dTime)
			if linkSprite.walkingDirection ~= "up" then
				linkSprite.walkingDirection = "up"
				linkSprite:setSequence("walk_up")
				linkSprite:play()
			end
		end
		if gamePad.isMovingDown then
			linkSprite.y = linkSprite.y +(movementSpeed * dTime)
			if linkSprite.walkingDirection ~= "down" then
				linkSprite.walkingDirection = "down"
				linkSprite:setSequence("walk_down")
				linkSprite:play()
			end
		end
		if gamePad.isMovingLeft then
			linkSprite.x = linkSprite.x -(movementSpeed * dTime)
			if linkSprite.walkingDirection ~= "left" then
				linkSprite.walkingDirection = "left"
				linkSprite:setSequence("walk_left")
				linkSprite:play()
			end
		end
		if gamePad.isMovingRight then
			linkSprite.x = linkSprite.x +(movementSpeed * dTime)
			if linkSprite.walkingDirection ~= "right" then
				linkSprite.walkingDirection = "right"
				linkSprite:setSequence("walk_right")
				linkSprite:play()
			end
		end
	else
		if linkSprite.walkingDirection ~= nil then
			if linkSprite.walkingDirection == "up" then
				linkSprite:setSequence("idle_up")
				linkSprite:play()
			elseif linkSprite.walkingDirection == "down" then
				linkSprite:setSequence("idle_down")
				linkSprite:play()
			elseif linkSprite.walkingDirection == "left" then
				linkSprite:setSequence("idle_left")
				linkSprite:play()
			elseif linkSprite.walkingDirection == "right" then
				linkSprite:setSequence("idle_right")
				linkSprite:play()
			end
			linkSprite.walkingDirection = nil
		end
	end
end
function scene:show(event)
	local phase = event.phase
	if phase == "did" then
		prevTime = system.getTimer()
		Runtime:addEventListener("enterFrame", onEnterFrame)
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
return scene 