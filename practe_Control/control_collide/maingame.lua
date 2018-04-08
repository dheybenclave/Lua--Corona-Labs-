
local composer = require("composer")
local scene = composer.newScene()

local background1
local background2
local widget = require("widget")
local dpad = require("dpad")

local playerSprite = nil
local enemySprite = nil
local playerCollisionRect = nil
local enemyCollisionRect = nil
local movementSpeed = 0.5
local prevTime = 0


local physics = require("physics")
physics.setDrawMode("hybrid")

physics.start()
physics.setGravity(0, 460)


local background

local default_centerX = display.contentCenterX
local default_centerY = display.contentCenterY
local default_originX = display.screenOriginX
local default_originY = display.screenOriginY
local default_width = display.actualContentWidth
local default_height = display.actualContentHeight


local function getDeltaTime()
	local currentTime = system.getTimer()
	local deltaTime = currentTime - prevTime
	prevTime = currentTime
	return deltaTime
end

local ismovebal = true
local counter = 0
function movecloud(event)
	if ismovebal == true then
		background.x = background.x - 1
	end
	counter = counter + 1
	
	print(counter)
	
	if background.x <= - 815 then
		background.x =(default_width)
	end
end

function scene:create(event)
	local sceneGroup = self.view
	background = display.newRect(display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
	background.fill = {type = "image", filename = "bg.png"}
	background.fill.scaleX = display.actualContentWidth / display.actualContentWidth / 2
	
	
	background2 = display.newRect(default_centerX, default_centerY, display.actualContentWidth, display.actualContentHeight)
	background2.fill = {type = "image", filename = "bg.png"}
	background2.fill.scaleX = display.actualContentWidth / display.actualContentWidth / 2
	
	sceneGroup:insert(background)	
	sceneGroup:insert(background2)
	-- sceneGroup:insert(background2)	
	-- print(background1.x .. default_centerX .. " " .. default_centerY .. " " ..
	-- default_originX .. " " .. default_originY .. " " .. default_centerX .. " " .. default_width ..
	-- default_centerX .. " " .. default_height	)
	print(background.x .. " " .. display.contentCenterX .. " " .. display.contentCenterY .. " " .. display.actualContentWidth .. " " .. display.actualContentHeight
	.. " " .. display.contentWidth .. " " .. display.contentHeight)
	
end

function scene:show(event)
	local phase = event.phase
	if phase == "did" then
		-- prevTime = system.getTimer()
		Runtime:addEventListener("enterFrame", movecloud)
	end
end

function scene:hide(event)
	local phase = event.phase
	if phase == "will" then
		Runtime:removeEventListener("enterFrame", movecloud)
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene





-- local cloudsarr = {}
-- local randomllocation
-- local clouds
-- function generatecloud(event)
-- 	-- body
-- 	for i = 1, 10 do
-- 		cloudsarr[i] = i .. "asd"
-- 		-- print(cloudsarr[i])
-- 		cloudsarr[i]  = display.newImageRect("cloud1.png", 70, 50)
-- 	cloudsarr[i] .x = (math.random(display.contentWidth)) 
-- 	cloudsarr[i] .y = (math.random(display.contentHeight) - 20) 
-- 	cloudsarr[i] .name = "clouds" .. i
-- 	end
-- 	for i = 1, 10 do
-- 		cloudsarr[i] = require("cloud")
-- 		cloudsarr[i].x =(math.random(display.contentWidth))
-- 		cloudsarr[i].y =(math.random(display.contentHeight) - 20)
-- 		print(cloudsarr[i].y .. " " .. cloudsarr[i].x)
-- 		cloudgroup:insert(cloudsarr[i])
-- 	end
-- 	return cloudgroup
-- end
-- local counter = 1
-- function movecloud(event)
-- 	for i = 1, 10 do
-- 		cloudsarr[i].x = (cloudsarr[i].x)+1 - 1
-- 		counter = counter + 1
-- 		-- print(counter)
-- 		if(counter % 2) == 0 then
-- 			cloudsarr[i]:setSequence("even")
-- 		else
-- 			cloudsarr[i]:setSequence("odd")
-- 		end
-- 		-- print(counter)
-- 	end
-- end
