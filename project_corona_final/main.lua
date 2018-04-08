-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Your code here
display.setStatusBar(display.HiddenStatusBar)
local composer = require("composer")

local options = {
    effect = "fade",
    time = 500,

}


display.setDefault("background", 15 / 255, 15 / 255, 15 / 255)
composer.gotoScene("menu", options)