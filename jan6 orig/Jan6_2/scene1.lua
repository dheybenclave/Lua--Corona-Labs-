local composer = require("composer")
local scene = composer.newScene()
local physics = require("physics")
physics.setDrawMode("normal")
--[[normal,debug,hybrid]]--
physics.start()
physics.setGravity( 0, 30 )
display.setDefault( "background", 0.2,0.5,1.0 )
local mario = nil
local block = nil
local helpText = nil
local screenW = display.contentWidth
local screenH = display.contentHeight
local halfW = display.contentWidth * 0.5
local halfH = display.contentHeight * 0.5

local function removeHelpText (event)
  if helpText ~= nil then
    helpText:removeSelf()
  end
end

timer.performWithDelay( 3000, removeHelpText  )
function scene:create (event)
  local sceneGroup = self.view
  local options = {
    text = "Use left or right to move and space to jump",
    x = 500,
    y = 150,
    width = 800,
    font = native.systemFont,
    fontSize = 55,
    align ="center"
  }
  helpText = display.newText(options)
  helpText:setFillColor(1.0,0.0,0.0)
  local ground = display.newImageRect( "ground.png" , 960,64)
  ground.x = halfW
  ground.y = screenH - 32
  ground.name = "ground"
  physics.addBody( ground, "static" ,{friction=0.3} )

  local platform = display.newImageRect("platform.png", 256 , 64 )
  platform.x = 500
  platform.y = 500
  platform.name = "platform"
  physics.addBody( platform, "static" ,{friction=0.3} )

  block = display.newImageRect("block.png",90,86)
  block.x = 500
  block.y = -150
  block.name = "block"
  physics.addBody( block, "dynamic" ,{density=5.0,friction=0.5,bounce=0.5} )

  mario = display.newImageRect("mario.png", 95,125)
  mario.x = 500
  mario.y = 100
  mario.name = "mario"
  physics.addBody( mario, "dynamic", {density=5.0,friction=0.5,bounce=0.0} )

  mario.isFixedRotation = true
  sceneGroup:insert(helpText)
  sceneGroup:insert(ground)
  sceneGroup:insert(platform)
  sceneGroup:insert(mario)
end

local function onEnterFrame()
  if mario == nil then
    return
  end
  if mario.isMovingLeft then
    mario.xScale = -1
    mario:applyForce(-2500,0,mario.x,mario.y)
  end
  if mario.isMovingRight then
    mario.xScale = 1
    mario:applyForce(2500,0,mario.x,mario.y)
  end
  if mario.isJumping == true then
    mario:applyLinearImpulse(0,-1600,mario.x,mario.y)
    mario.isJumping = false
  end

  local offScreenLeftRight = 200
  local offScreenTop = 100

  if mario.x > screenW + offScreenLeftRight then
    mario.x = -(offScreenLeftRight)
  elseif mario.x < -(offScreenLeftRight) then
    mario.x = screenW + offScreenLeftRight
  end

  if mario.y > screenH + offScreenTop then
    mario:setLinearVelocity(0.0,0.0)
    mario.x = 500
    mario.y = 0
  end

  if block.x > screenW + offScreenLeftRight then
    block.x = -offScreenLeftRight
  elseif block.x < -offScreenLeftRight then
    block.x = screenW + offScreenLeftRight
  end
  if block.y > screenH + offScreenTop then
    block:setLinearVelocity(0.0,0.0)
    block.angularVelocity = 0.0
    block.rotation = 0.0
    block.x = 500
    block.y = 0
  end
end

local function onKey (event)
  if event.keyName == "left" then
    if event.phase == "down" then
      mario.isMovingLeft = true
    else
      mario.isMovingLeft = false
    end
    return true
  elseif event.keyName == "right" then
    if event.phase == "down" then
      mario.isMovingRight = true
    else
      mario.isMovingRight = false
    end
    return true
  elseif event.keyName == "space" then
    if event.phase == "down" then
      mario.isJumping = true
    else
      mario.isJumping = false
    end
    return true
  end
  return false
end

function scene:show (event)
  local phase = event.phase
  if phase == "did" then
    Runtime:addEventListener("enterFrame",onEnterFrame)
    Runtime:addEventListener("key",onKey)
  end
end

function scene:hide (event)
  local phase = event.phase
  if phase == "will" then
    Runtime:removeEventListener("enterFrame",onEnterFrame)
    Runtime:removeEventListener("key",onKey)
  end
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
return scene
