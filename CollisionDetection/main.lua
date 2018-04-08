-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Your code here

display.setStatusBar(display.HiddenStatusBar)

local composer = require("composer")

composer.gotoScene("scene1" , {effect = "fade", time = 800} )