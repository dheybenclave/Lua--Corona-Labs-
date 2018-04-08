
local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")


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

local options = {
        
        effect = "zoomInOutFade",
        time = 100,
}
local sceneGroup
function scene:create(event)
    
    sceneGroup = self.view
    local splash = display.newImageRect("resources/images/splash.PNG", default_width_a, default_height_a)
    splash.x = default_centerX
    splash.y = default_centerY
    audio.setVolume(1, {channel = 0})
    local backgroundMusic_splash = audio.loadStream("resources/sound/dhey_splash_m.mp3")
    local option = {
        channel = 0,
        fadeIn = 5000
    }
    local backgroundMusicChannel = audio.play(backgroundMusic_splash, option)
    sceneGroup:insert(splash)

end


local t = {}
function t:timer(event)
    composer.gotoScene("menu", options)
    local count = event.count
    if count >= 1 then
        timer.cancel(event.source)
    end
end


function scene:show(event)
    local phase = event.phase
    if phase == "did" then
        
        timer.performWithDelay(6000, t, 0)
    end
end

function scene:hide(event)
    local phase = event.phase
    if phase == "will" then
        display.remove(sceneGroup)
    end
end

function scene:destroy(event)
    local phase = event.phase
    if phase == "will" then
        end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
return scene
