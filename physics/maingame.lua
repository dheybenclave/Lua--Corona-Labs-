

local composer = require("composer")
local scene = composer.newScene()
local physics = require("physics")
physics.setDrawMode("normal")

-- debug and hybrid and normal
physics.start()
physics.setGravity(0, 460)
display.setDefault("background", 0.2, 0.5, 1)

local mario = nil
local block = nil
local helpText = nil
local screenW = display.contentWidth
local screenY = display.contentHeight
local halfW = display.contentWidth * 0.5
local screenH = display.contentHeight * 0.5
local function removeHelpText(event)
	-- body
	if helpText ~= nil then
		helpText:removeSelf()
	end
end

timer.performWithDelay(3000, removeHelpText)

function scene:create(event)
	-- body
	local sceneGroup = self.view
	local options = {
		text = "Use Left, Right to move , Space to Jump",
		x = 500,
		y = 150,
		width = 500,
		font = "Consolas",
		fontSize = 55,
		align = "Center"
	}
	
	helpText = display.newText(options)
	helpText:setFillColor(1, 0, 0)
	
	
	local ground = display.newImageRect("ground.png", display.contentWidth, 200)
	ground.x = display.contentCenterX
	ground.y = display.contentWidth -(ground.height / 2)
	ground.name = "ground"
	physics.addBody(ground, "static", {friction = 0.3})
	
	local platform = display.newImageRect("platform.png", 256, 64)
	platform.x = display.contentCenterX
	platform.y = display.contentCenterY
	platform.name = "platform"
	physics.addBody(platform, "static", {friction = 0.3})
	
	block = display.newImageRect("block.png", 90, 86)
	block.x = display.contentCenterX
	block.y = display.contentCenterY
	block.name = "block"
	physics.addBody(block, "dynamic", {density = 5, friction = 0.5, bounce = 0.2})
	
	mario = display.newImageRect("mario.png", 65, 105)
	mario.x = display.contentCenterX
	mario.y = display.contentCenterY
	mario.name = "mario"
	physics.addBody(mario, "dynamic", {density = 5, friction = 0.5, bounce = 0.1})
	
	mario.isFixedPosition = true
	sceneGroup:insert(helpText)
	sceneGroup:insert(ground)
	sceneGroup:insert(platform)
	sceneGroup:insert(mario)
	
	
end

local function onEnterFrame(event)
	
	if mario == nil then
		
		-- body
		return false
	end
	if mario.isMovingLeft then
		-- body
		mario.xScale = - 1
		mario.x = mario.x-1
		-- mario:applyForce(-500, 0, mario.x, mario.y)
    end
    
    if mario.isMovingLeft == false then
      
mario:setLinearVelocity(0, 0, mario.x, mario.y) 
    end
	if mario.isMovingRight then
		-- body
            mario.x = mario.x+1
		-- mario:setLinearVelocity(200, 0, mario.x, mario.y)
		
		-- mario:applyForce(500, 0, mario.x, mario.y)
		mario.xScale = 1
	end
	if mario.isJump == true then
		-- body
		-- mario:applyForce(0,-500)
		mario.isJumping = false
	end
	
	local offScreentLeftRight = 200
	local offScreentTop = 100
	
	if mario.x > screenW + offScreentLeftRight then
		-- body
		mario.x = - offScreentLeftRight
	elseif mario.x < - offScreentLeftRight then
		mario.x = screenW + offScreentLeftRight
	end
	
	
	if mario.y > screenH + offScreentTop then
		-- body
		mario:setLinearVelocity(0, 0)
		
		mario.x = - mario.width + 200
		mario.y = 0
	end
	
	if block.x > screenW + offScreentLeftRight then
		-- body
		block.x = - offScreentLeftRight
	elseif block.x < - offScreentLeftRight then
		block.x = screenW + offScreentLeftRight
	end
	
	if block.y > screenH + offScreentTop then
		-- body
		block:setLinearVelocity(0, 0)
		block.rotation = 0
		block.angularVelocity = 0
		block.x = display.contentCenterX
		block.y = 0
	end
end

local function onKeyName(event)
    getkey = nil
	if event.keyName == "left" then
		if event.phase == "down" then
            mario.isMovingLeft = true
            getkey = event.keyName
		else
			mario.isMovingRight = false
		end
		return true

	   elseif event.keyName == "right" then
		if event.phase == "down" then
			mario.isMovingRight = true
            getkey = event.keyName
		else
			mario.isMovingLeft = false
	
		end
		return true
		
	   elseif event.keyName == "space" then
		if event.phase == "down" then
			mario.isJump = true
            getkey = event.keyName
		else
			mario.isJump = false
		end
		return true
	end
	 if event.keyName == getkey then
	   if event.phase == "up" then
		mario:setLinearVelocity(0, -20, mario.x, mario.y)
    end
	end

	return false
end 
function scene:show(event)
	-- body
	local phase = event.phase
	if phase == "did" then
		Runtime:addEventListener("enterFrame", onEnterFrame)
		Runtime:addEventListener("key", onKeyName)
	end
end

function scene:hide(event)
	-- body
	local phase = event.phase
	if phase == "will" then
		Runtime:addEventListener("enterFrame", onEnterFrame)
		Runtime:addEventListener("key", onKeyName)
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene 