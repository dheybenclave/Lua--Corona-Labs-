

local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")

local options = {

	effect= "fade",
    time = 100,
  	transtion = easing.inOutBounce,
}

local widget = require("widget") 

 local default_centerX = display.contentCenterX
 local default_centerY = display.contentCenterY
 local default_originX = display.screenOriginX
 local default_originY = display.screenOriginY
 local default_width = display.actualContentWidth
 local default_height = display.actualContentHeight

-- local t = display.newText("Waiting for button event...", 0, 0, native.systemFont, 18)
-- t.x, t.y = display.contentCenterX, 70

local ButtonHandler = function(event)
		if event.target.id == "btnplay" then
		composer.gotoScene("maingame",options)
	end
	-- t.text = "Button 1 pressed" 
end


local btnplay = widget.newButton
{
	id = "btnplay",
	defaultFile = "btn_play.png",
	overFile = "btn_play.png",
	label = "Play",
	emboss = true,
	fontSize = 60,
	font = "Impact",
	labelColor = { default={255/255,202/255,173/255} ,},
	onEvent = ButtonHandler,
}
btnplay.x = default_centerX
btnplay.y = default_centerY





function scene:create(event)
	local sceneGroup = self.view
	sceneGroup :insert(btnplay)	
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
