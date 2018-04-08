-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here default_centerX = display.contentCenterX

display.setStatusBar(display.HiddenStatusBar)

local options = {
    effect = "fade",
    time = 500,
    transition=easing.inOutCirc,
}

local composer = require( "composer" )
composer.gotoScene("home",options) 