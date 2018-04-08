local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")

local options = {
	
	effect = "fade",
	time = 700,
	transtion = easing.inOutBounce,
}



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



local ButtonHandler = function(event)
	if event.target.id == "btnscene1" then
		composer.gotoScene("maingame", options)
	end
	if event.target.id == "btnscene2" then
		composer.gotoScene("another", options)
	end
	
	if event.target.id == "btnscene3" then
		composer.gotoScene("another_2", options)
	end
	
	if event.target.id == "btnscene4" then
	composer.gotoScene("another_3", options)
end 
end


local btnscene1 = widget.newButton
{
	id = "btnscene1",
	defaultFile = "btn_play.png",
	overFile = "btn_play.png",
	label = "scene1",
	emboss = true,
	fontSize = 60,
	font = "Impact",
	labelColor = {default = {255 / 255, 202 / 255, 173 / 255},},
	onEvent = ButtonHandler,
}


local btnscene2 = widget.newButton
{
	id = "btnscene2",
	defaultFile = "btn_play.png",
	overFile = "btn_play.png",
	label = "scene2",
	emboss = true,
	fontSize = 60,
	font = "Impact",
	labelColor = {default = {255 / 255, 202 / 255, 173 / 255},},
	onEvent = ButtonHandler,
}




local btnscene3 = widget.newButton
{
	id = "btnscene3",
	defaultFile = "btn_play.png",
	overFile = "btn_play.png",
	label = "scene3",
	emboss = true,
	fontSize = 60,
	font = "Impact",
	labelColor = {default = {255 / 255, 202 / 255, 173 / 255},},
	onEvent = ButtonHandler,
}


local btnscene4 = widget.newButton
{
	id = "btnscene4",
	defaultFile = "btn_play.png",
	overFile = "btn_play.png",
	label = "scene4",
	emboss = true,
	fontSize = 60,
	font = "Impact",
	labelColor = {default = {255 / 255, 202 / 255, 173 / 255},},
	onEvent = ButtonHandler,
}



btnscene1.x = default_centerX -200
btnscene1.y = default_centerY - 150

btnscene2.x = default_centerX + 200 
btnscene2.y = default_centerY - 150 

btnscene3.x = default_centerX -200
btnscene3.y = default_centerY +150

btnscene4.x = default_centerX+ 200 
btnscene4.y = default_centerY + 150



function scene:create(event)
	local sceneGroup = self.view
	sceneGroup:insert(btnscene1)	
	sceneGroup:insert(btnscene2)	
	sceneGroup:insert(btnscene3)
	sceneGroup:insert(btnscene4) 
	-- sceneGroup :insert(t)	
end

function scene:show(event)
	local phase = event.phase
	if phase == "did" then
		-- prevTime = system.getTimer()
		-- Runtime:addEventListener("enterFrame", onEnterFrame)
	end
end

function scene:hide(event)
	local phase = event.phase
	if phase == "will" then
		-- Runtime:removeEventListener("enterFrame", onEnterFrame)
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
