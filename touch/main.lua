-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Your code here
local function tapListener(event)
    
    if (event.numTaps == 2) then
        print("Object double-tapped: " .. tostring(event.target) .. event.x .. event.y)
    elseif (event.numTaps == 3) then
        print("Object triple-tapped: " .. tostring(event.target))
    else
        return true
    end
end

local physics = require("physics")
physics.start();


local image = display.newImageRect("bg.jpg", display.contentWidth, display.contentHeight)
image.x = display.contentCenterX
image.y = display.contentCenterY




local myButton = display.newRect(display.contentCenterX, display.contentCenterY, 200, 50)
transition.moveTo(myButton, {display.contentHWidth, y = display.contentHeight - (myButton.height / 2), time = 2000})

myButton:addEventListener("tap", tapListener)

local paint = {
    type = "image",
    filename = "box.png"
}

local circlepad = display.newRect(display.contentCenterX, display.contentCenterY, 50,50)
circlepad.stroke = paint
circlepad.strokeWidth = 4


-- local circlepad = display.newImage("box.png", 70, 70)
-- circlepad.x = display.contentCenterX
-- circlepad.y = display.contentCenterY
-- circlepad.setStrokeColor = paint
-- circlepad.strokeWidth = 4


-- circlepad.stroke = paint

-- circlepad.strokeWidth = 4

local function defaultsize(obj)
    transition.scaleTo(circlepad, {xScale = 1, yScale = 1, time = 100})
end
local function myTouchListener(event)
    
    if (event.phase == "began") then
        -- Code executed when the button is touched
        print("object touched = " .. tostring(event.target))-- "event.target" is the touched object
        transition.to(circlepad, {time = 1000, alpha = 0.3, transition = easing.inOutCubic})
        transition.scaleTo(circlepad, {xScale = 1.2, yScale = 1.2, time = 100, onComplete = defaultsize})
    --    transition.to( circlepad, { time=200, alpha=1 } )
    elseif (event.phase == "moved") then
        -- Code executed when the touch is moved over the object
        print("touch location in content coordinates = " .. event.x .. "," .. event.y)
        circlepad.x = event.x
        circlepad.y = event.y
        transition.to(circlepad, {time = 200, alpha = 1, transition = easing.outInElastic, })
    elseif (event.phase == "ended") then
        -- Code executed when the touch lifts off the object
        print("touch ended on object " .. tostring(event.target))
        transition.to(circlepad, {time = 1000, alpha = 0.3, transition = easing.inOutCubic})
        transition.moveTo(circlepad, {display.contentHWidth, y = display.contentHeight - (circlepad.height / 2), time = 500})
    end
    return true -- Prevents tap/touch propagation to underlying objects
end

local function onTouch( event )

	local obj = event.target
	local phase = event.phase

	if ( "began" == phase ) then

        obj:toFront()
        
		if ( isMultitouchEnabled == true ) then
			display.currentStage:setFocus( obj, event.id )
		else
			display.currentStage:setFocus( obj )
		end

		obj.isFocus = true
  print("touch ended on object " .. tostring(event.id))
		-- Store initial position
		obj.x0 = event.x - obj.x
        obj.y0 = event.y - obj.y
        
          obj.strokeWidth = 6
            transition.to(circlepad, {time = 1000, alpha = 0.3, transition = easing.inOutCubic})
        transition.scaleTo(circlepad, {xScale = 1.2, yScale = 1.2, time = 100, onComplete = defaultsize})
--   transition.to(circlepad, {obj.x,  y = obj.y-(display.contentHeight/5), time = 100})

	elseif obj.isFocus then

		if ( "moved" == phase ) then
			obj.x = event.x - obj.x0
			obj.y = event.y - obj.y0

	
			if ( event.pressure ) then
				obj:setStrokeColor( 1, 1, 1, event.pressure )
            end
            
               transition.to(circlepad, {time = 200, alpha = 1, transition = easing.outInElastic, })

		elseif ( "ended" == phase or "cancelled" == phase ) then
        transition.to(circlepad, {time = 1000, alpha = 0.3, transition = easing.inOutCubic})
        transition.to(circlepad, {display.contentHWidth, y = display.contentHeight - (circlepad.height / 2), time = 500})

			-- Release focus on the object
			if ( isMultitouchEnabled == true ) then
				display.currentStage:setFocus( obj, nil )
			else
				display.currentStage:setFocus( nil )
			end
			obj.isFocus = false

			obj:setStrokeColor( 1, 1, 1, 0 )
		end
	end
	return true
end


-- image:addEventListener("touch", myTouchListener)
circlepad:addEventListener("touch", onTouch)-- Add a "touch" listener to the object
