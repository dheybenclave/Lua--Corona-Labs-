local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")

local physics = require("physics")
physics.setDrawMode("normal")
physics.start()
physics.setGravity(0, 70)
display.setDefault("background", 25 / 255, 25 / 255, 25 / 255)

local widget = require("widget")
local dpad = require("dpad")
local gamePad = dpad.newDPad(450, "pad.png", 0.5)


local mario = nil
local block = nil
local platformbox = nil
local helpText = nil
local screenW = display.contentWidth
local screenH = display.contentHeight
local act_screenWidth = display.actualContentWidth
local act_screenHeight = display.actualContentHeight
local halfW = display.contentWidth * 0.5
local halfH = display.contentHeight * 0.5

local mario = nil
local block = nil
local playerCollisionRect = nil
local enemyCollisionRect = nil
local movementSpeed = 0.3
local prevTime = 0
local messageText = nil
local delta
local collided = false
local selfcol, othercol
local score = 0
local btnjump  = nil
local function getDeltaTime()
	local currentTime = system.getTimer()
	local deltaTime = currentTime - prevTime
	prevTime = currentTime
	return deltaTime
end

local function defaultsize(obj)
	transition.scaleTo(btnjump, {xScale = 0.3, yScale = 0.3, time = 100})
end

local ButtonHandler = function(event)
	if event.target.id == "btnjump" then
		mario:setLinearVelocity(0, -800, mario.x, mario.y)
		-- mario.isJumping = true
		transition.scaleTo(btnjump, {xScale = 0.4, yScale = 0.4, time = 200, onComplete = defaultsize})
	end

end


btnjump = widget.newButton
{
	id = "btnjump",
	defaultFile = "jump.png",
	overFile = "jump.png",
	label = "",
	emboss = true,
	fontSize = 60,
	font = "Impact",
	labelColor = {default = {255 / 255, 202 / 255, 173 / 255},},
	onEvent = ButtonHandler,
	
}
btnjump.alpha = 0.7
btnjump.width = 180
btnjump.height = 180
btnjump.x =(display.actualContentWidth * 0.5) + 400
btnjump.y = display.actualContentHeight - 120


local counter = false

local function hasCollided(obj1, obj2)
	if obj1 == nil then
		return false
	end
	if obj2 == nil then
		return false
	end
	local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
	local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
	local top = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
	local bottom = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
	
	
	if obj1.contentBounds.xMin >= obj2.contentBounds.xMin and
	obj1.contentBounds.xMax <= obj2.contentBounds.xMax and
	obj1.contentBounds.yMin >= obj2.contentBounds.yMin and
	obj1.contentBounds.yMax <= obj2.contentBounds.yMax then
		counter = true		
	end
	
	if counter == true then
	counter = false
	score = score + 1000
	end
	counter = false
	return(left or right) and(top or bottom)
	
	
end


local function onLocalCollision(self, event)
	selfcol = self.name
	othercol = event.other.name
	
	if(event.phase == "began") then
		
		if othercol == "block" and selfcol == "platformbox" then
			print(self.name .. ": collision began with " .. event.other.name)
			score = score + 1000
			print(score)	
		end
		collided = true
	elseif(event.phase == "ended") then
		-- print(self.name .. ": collision ended with " .. event.other.name)
		collided = false
	end
	
end




function onEnterFrame(event)
	delta = getDeltaTime()
	
	-- block.x = block.x-1
	if mario == nil then
		return
	end
	if mario.isMovingLeft then
		mario.xScale = - 1
		mario:applyForce(- 1500, 0, mario.x, mario.y)
	end
	if mario.isMovingRight then
		mario.xScale = 1
		mario:applyForce(1500, 0, mario.x, mario.y)
	end
	if mario.isJumping == true then
		mario:applyLinearImpulse(0, - 1500, mario.x, mario.y)
		mario.isJumping = false
	end
	
	
	if gamePad.isMoving then
		
		if gamePad.isMovingUp then
			--  mario.y = mario.y -(movementSpeed * delta)
			-- mario:applyLinearImpulse(0, - 220, mario.x, mario.y)
		end
		if gamePad.isMovingDown then
			-- mario.y = mario.y +(movementSpeed * delta)
		end
		if gamePad.isMovingRight == true then
			-- mario.x = mario.x + (movementSpeed * delta)
			mario:applyForce(1500, 0, mario.x, mario.y)
			block:applyForce(1500, 0, mario.x, mario.y)
			mario.xScale = 1
		end
		if gamePad.isMovingLeft == true then
			-- mario.x = mario.x - (movementSpeed * delta)
			mario:applyForce(- 1500, 0, mario.x, mario.y)
			mario.xScale = - 1
		end
	end
	
	local offScreenLeftRight = 200
	local offScreenTop = 100
	
	if mario.x > screenW + offScreenLeftRight then
		mario.x = -(offScreenLeftRight)
	elseif mario.x < -(offScreenLeftRight) then
		mario.x = screenW + offScreenLeftRight
	end
	
	if mario.y > screenH + offScreenTop then
		mario:setLinearVelocity(0, 0)
		mario.x = 500
		mario.y = 0
	end
	
	if block.x > screenW + offScreenLeftRight then
		block.x = - offScreenLeftRight
	elseif block.x < - offScreenLeftRight then
		block.x = screenW + offScreenLeftRight
	end
	if block.y > screenH + offScreenTop then
		block:setLinearVelocity(0, 0)
		block.angularVelocity = 0
		block.rotation = 0
		block.x = 500
		block.y = 0
	end
	
	enemyCollisionRect.x = block.x
	enemyCollisionRect.y = block.y
	playerCollisionRect.x = mario.x
	playerCollisionRect.y = mario.y
	
	if collided then
		if othercol == "block" and selfcol == "mario" then
			block.x = mario.x
			block.y = mario.y - mario.height + 20
		else
		end
		
	else
		
	end
	
	
	
	if hasCollided(block, platformbox) then
		messageText.text = "Score : " .. score
		-- 
-- playerCollisionRect.isVisible = true
-- enemyCollisionRect.isVisible = true
	else
		messageText.text = "Score : " .. score
		-- playerCollisionRect.isVisible = false
		-- enemyCollisionRect.isVisible = false
	end
	
	
end

function onKey(event)
	
	if event.keyName == "left" then
		if event.phase == "down" then
			gamePad.isMovingLeft = true
			mario.isMovingLeft = true
			print('left')
		else
			mario.isMovingLeft = false
		end
		
	elseif event.keyName == "right" then
		if event.phase == "down" then
			gamePad.isMovingRight = true
			mario.isMovingRight = true
			print('right')
		else
			mario.isMovingRight = false
		end
		
	elseif event.keyName == "space" then
		if event.phase == "down" then
			mario.isJumping = true
		else
			mario.isJumping = false
		end
		
	end
	return false
end


function scene:create(event)
	local sceneGroup = self.view
	
	local options = {
		frames = require("uma").frames,
	}
	
	
	local top = display.newImageRect("ground.png", act_screenWidth, 64)
	top.x = halfW
	top.y = - 200
	top.name = "ground"
	top.yScale = - 1
	physics.addBody(top, "static", {friction = 0.4})
	
	local ground = display.newImageRect("ground.png", act_screenWidth, 64)
	ground.x = halfW
	ground.y = screenH - 32
	ground.name = "ground"
	physics.addBody(ground, "static", {friction = 0.4})
	
	
	local platform = display.newImageRect("platform.png", act_screenWidth / 3, 64)
	platform.x =(act_screenWidth / 3) - 200
	platform.y = 430
	platform.name = "platform"
	physics.addBody(platform, "static", {friction = 0.4})
	
	local platform1 = display.newImageRect("platform.png", 84, 64)
	platform1.x =(act_screenWidth / 2) -160 
	platform1.y = 430
	platform1.name = "platform1"
	physics.addBody(platform1, "static", {density = 1, friction = 0.4, bounce = 0.5} ) 
	
	platformbox = display.newRect(act_screenWidth - 500, 200, 100, 100)
	platformbox:setFillColor(0)
	platformbox.strokeWidth = 3
	platformbox:setStrokeColor(1, 0, 0)
	
	
	mario = display.newImageRect("mario.png", 75, 105)
	mario.x = 500
	mario.y = 100
	mario.name = "mario"
	physics.addBody(mario, "dynamic", {density = 5, friction = 0.2, bounce = 0})
	mario.isFixedRotation = true
	
	block = display.newImageRect("block.png", 70, 66)
	block.x = 500
	block.y = 9
	block.name = "block"
	physics.addBody(block, "dynamic", {density = 2, friction = 0.4, bounce = 0.5})
	block.isFixedRotation = true
	
	
	
	
	messageText = display.newText("", 0, 0, native.systemFontBold, 35)
	messageText:setFillColor(1, 1, 1)
	messageText.x = 250
	messageText.y = 80
	playerCollisionRect = display.newRect(mario.x, mario.y, mario.width, mario.height)
	playerCollisionRect:setFillColor(0)
	playerCollisionRect.strokeWidth = 3
	playerCollisionRect:setStrokeColor(1, 0, 0)
	playerCollisionRect.isVisible = false
	enemyCollisionRect = display.newRect(block.x, block.y, block.width, block.height)
	enemyCollisionRect:setFillColor(0)
	enemyCollisionRect.strokeWidth = 3
	enemyCollisionRect:setStrokeColor(1, 0, 0)
	enemyCollisionRect.isVisible = false
	
	
	
	
	mario.collision = onLocalCollision
	mario:addEventListener("collision")
	platformbox.collision = onLocalCollision
	platformbox:addEventListener("collision")
	-- block.collision = onLocalCollision
	-- block:addEventListener( "collision" )
	sceneGroup:insert(ground)
	sceneGroup:insert(platform)
	sceneGroup:insert(platform1) 
	sceneGroup:insert(platformbox)
	sceneGroup:insert(enemyCollisionRect)
	sceneGroup:insert(playerCollisionRect)
	sceneGroup:insert(block)
	sceneGroup:insert(mario)
	sceneGroup:insert(messageText)
	sceneGroup:insert(btnjump)
end

function scene:show(event)
	local phase = event.phase
	if phase == "did" then
		prevTime = system.getTimer()
		
		Runtime:addEventListener("enterFrame", onEnterFrame)
		Runtime:addEventListener("key", onKey)
	end
end

function scene:hide(event)
	local phase = event.phase
	if phase == "will" then
		Runtime:removeEventListener("enterFrame", onEnterFrame)
		Runtime:removeEventListener("key", onKey)
	end
end



scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
