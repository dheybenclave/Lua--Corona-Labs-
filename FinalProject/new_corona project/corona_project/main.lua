-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
-- Your code here
display.setStatusBar(display.HiddenStatusBar)
local composer = require("composer")

local params_option = {
    sounds = true,
    animation= true
}
local options = {
    effect = "fade",
    time = 500,
    params = params_option

}


display.setDefault("background", 15 / 255, 15 / 255, 15 / 255)
composer.gotoScene("splash", options)