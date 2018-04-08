-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

print("hello , world!")



function greetings(name)
    print("Hello, good afternoon "..name)
end

for i = 1, 10 , 1 do
   -- print("The Value is "..i)
    greetings("Ivyrose " ..i)
end

local arr = {1,2,3,4,5}

for i=0 , table.getn(arr), 1 do
    if i ~= 0 then
        print(arr[i])
    end
end

local physics = require("physics")
physics.start();


local bg = display.newImage("bg.png" ,display.contenCenterX ,display.contenCenterY)
bg.width =320
bg.height = 480
-- physics.addBody(bg , {density = 3.0 , friction = 0.5 , bounce= 0.6})

local box = display.newImage("box.png" , 180 , 70)
box.rotation = 5
box.height = 80
box.width = 80
physics.addBody(box , {density = 3.0 , friction = 0.5 , bounce= 10.6})


local block = display.newImage("block.png" , 180 , 300)
block.height = 80
block.width = 150
 physics.addBody(block, {density = 3.0 , friction = 0.5 , bounce= 0.5})

local pad = display.newImage("pad.png" , 180 , 380)
physics.addBody(pad , "static" , {friction = 0.5 , bounce = 0.3})

-- local box2 = display.newImage("box.png" , 210 , 120)
-- physics.addBody(box2, {density = 5.0 , friction = 0.5 , bounce = 0.3})

 
    if box.y >= 90 then
    box.height = 200
    box.width = 200
     print(box.y)
     physics.addBody(box , {density = 1.0 , friction = 1.5 , bounce= 0.3})
    end
  