
local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")
local dpad = require("dpad")
local gamePad = dpad.newDPad(260, "pad.png", 0.5)

local playerSprite = nil
local enemySprite = nil
local playerCollisionRect = nil
local enemyCollisionRect = nil
local movementSpeed = 0.1
local prevTime = 0



local function getDeltaTime()
	local currentTime = system.getTimer()
	local deltaTime = currentTime - prevTime
	prevTime = currentTime
	return deltaTime
end

local function hasCollided(obj1, obj2)
	if obj1 == nil then
		return false
	end
	if obj2 == nil then
		return false
	end
	
	local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin
	and obj1.contentBounds.xMax >= obj2.contentBounds.xMax
	local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin
	and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
	local top = obj1.contentBounds.yMin <= obj2.contentBounds.yMin
	and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
	local bottom = obj1.contentBounds.yMin >= obj2.contentBounds.yMin
	and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
	
	return(left or right) and(top or bottom)
end

function onEnterFrame(event)
	local delta = getDeltaTime()
	
	if gamePad.isMoving then
		if gamePad.isMovingUp then
			playerSprite.y = playerSprite.y -(movementSpeed * delta)
			playerSprite.yScale = 1 
		end
		if gamePad.isMovingDown then
			playerSprite.y = playerSprite.y +(movementSpeed * delta)
			playerSprite.yScale = -1 
		end
		if gamePad.isMovingRight then
			playerSprite.x = playerSprite.x +(movementSpeed * delta)
			playerSprite.xScale = 1
		end
		if gamePad.isMovingLeft then
			playerSprite.x = playerSprite.x -(movementSpeed * delta)
			playerSprite.xScale = -1
		end
	end
	
	playerCollisionRect.x = playerSprite.x
	playerCollisionRect.y = playerSprite.y
	
	if hasCollided(playerSprite, enemySprite) then
		messageText.text = "Collided"
		playerCollisionRect.isVisible = true
		enemyCollisionRect.isVisible = true
	else
		messageText.text = "No Collision"
		playerCollisionRect.isVisible = false
		enemyCollisionRect.isVisible = false
	end
end

function scene:create(event)
	local sceneGroup = self.view
	playerSprite = display.newImageRect("fighter.png", 138, 36)
	playerSprite.x = 310
	playerSprite.y = 400
	enemySprite = display.newImageRect("enemy.png", 100, 100)
	enemySprite.x = display.contentCenterX
	enemySprite.y = display.contentCenterY
	
	messageText = display.newText("", 0, 0, native.systemFontBold, 45)
	messageText:setFillColor(1, 1, 1)
	messageText.x = 250
	messageText.y = 80
	
	playerCollisionRect = display.newRect(playerSprite.x, playerSprite.y, playerSprite.width, playerSprite.height)
	playerCollisionRect:setFillColor(0)
	playerCollisionRect.strokeWidth = 3
	playerCollisionRect:setStrokeColor(1, 0, 0)
	playerCollisionRect.isVisible = false
	
	enemyCollisionRect = display.newRect(enemySprite.x, enemySprite.y, enemySprite.width, enemySprite.height)
	enemyCollisionRect:setFillColor(0)
	enemyCollisionRect.strokeWidth = 3
	enemyCollisionRect:setStrokeColor(1, 0, 0)
	enemyCollisionRect.isVisible = false
	
	sceneGroup:insert(enemyCollisionRect)
	sceneGroup:insert(enemySprite)
	sceneGroup:insert(playerCollisionRect)
	sceneGroup:insert(playerSprite)
	sceneGroup:insert(messageText)
	
end

function scene:show(event)
	local phase = event.phase
	if phase == "did" then
		prevTime = system.getTimer()
		Runtime:addEventListener("enterFrame", onEnterFrame)
	end
end

function scene:hide(event)
	local phase = event.phase
	if phase == "will" then
		Runtime:removeEventListener("enterFrame", onEnterFrame)
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
