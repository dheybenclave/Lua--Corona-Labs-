local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")

local options = {
        
        effect = "zoomInOutFade",
        time = 400,
        transition = easing.inOutBounce,
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



local def_font = "Impact"
local bg_sounds = nil
local group_front = display.newGroup()
local group_back = display.newGroup()

local isplaying = false


local ButtonHandler = function(event)
    if event.target.id == "btn_play" then
        audio.fadeOut({ channel=1, time=1000 })
        
        -- reseter.restart(event)
        -- composer.gotoScene("maingame", options)
        isplaying = true
        composer.gotoScene("maingame", options)
        isplaying = true
    end
    if event.target.id == "btn_help" then
        -- composer.gotoScene("maingame", options)
        end
    
    if event.target.id == "btn_settings" then
        -- composer.gotoScene("another_2", options)
        end

end

local btn_play = widget.newButton
    {
        id = "btn_play",
        -- defaultFile = "resources/b1.png",
        -- overFile = "resources/b2.png",
        label = "PLAY",
        emboss = true,
        fontSize = 100,
        font = "Impact",
        labelColor = {default = {255 / 255, 202 / 255, 173 / 255}, },
        onEvent = ButtonHandler,
}
btn_play.x = default_centerX
btn_play.y = default_centerY + 280

local btn_help = widget.newButton
    {
        id = "btn_help",
        -- defaultFile = "resources/b1.png",
        -- overFile = "resources/b2.png",
        label = "Settings",
        emboss = true,
        fontSize = 40,
        font = "Impact",
        labelColor = {default = {255 / 255, 202 / 255, 173 / 255}, },
        onEvent = ButtonHandler,
}

btn_help.x = default_centerX
btn_help.y = default_centerY + 380


local btn_settings = widget.newButton
    {
        id = "btn_settings",
        -- defaultFile = "resources/b1.png",
        -- overFile = "resources/b2.png",
        label = "Help",
        emboss = true,
        fontSize = 40,
        font = "Impact",
        labelColor = {default = {255 / 255, 202 / 255, 173 / 255}, },
        onEvent = ButtonHandler,
}

btn_settings.x = default_centerX
btn_settings.y = default_centerY + 450


local messageText = display.newText("0", 0, 0, native.systemFontBold, 80)
messageText:setFillColor(255 / 255, 180 / 255, 0 / 255)
messageText.x = default_centerX
messageText.y = 80


local tPrevious = system.getTimer()
local function getDeltaTime()
    local currentTime = system.getTimer()
    local deltaTime = currentTime - prevTime
    prevTime = currentTime
    return deltaTime
end

display.setDefault("background", 212 / 255, 0 / 255, 95 / 255)

local background1, background2,background3,background4


local function forbackground(event)
    
    background4 = display.newImageRect("resources/images/bg_shadow.png", default_width_a, default_height_a)
    background4.x = display.contentCenterX
    background4.y = default_height_half

    background3 = display.newImageRect("resources/images/bg_menu_front.png", default_width_a, default_height_a)
    background3.x = display.contentCenterX
    background3.y = default_height_half

    background1 = display.newImageRect("resources/images/bg_menu_1.PNG", default_width_a, default_height_a)
    background1.x = default_centerX
    background1.y = default_centerY
    

    background2 = display.newImageRect("resources/images/bg_menu_2.PNG", default_width_a, default_height_a)
    background2.x = default_centerX - default_width
    background2.y = default_centerY

end

local counter = 0
 local function inhaleexhale(event)
    
    if (counter == 0) then
        counter = 1
            transition.to(group_front, {y = group_front.y +33 , time = 1700, transition =easing.inOutCubic })
    else
        counter = 0
         transition.to(group_front, {y = group_front.y-33 , time = 1700, transition = easing.inOutCubic  })
    end
end

timer.performWithDelay(1450, inhaleexhale, 0)



local subcosubcount = 0
local bakgroundsub = false
local parallax = 1;

local function move_background(event)
  
    if(isplaying == false) then
    background1.x = background1.x + parallax
    background2.x  = background2.x + parallax
    end
    if background1.x == default_width * 1.5 then
        background1.x = default_width * -.5
    end
    if background2.x == default_width * 1.5 then
        background2.x = default_width * -.5
    end
        
end





local player_img,player_outline,player

player_img = "resources/images/player.PNG"
player_outline = graphics.newOutline(2, player_img)
player = display.newImageRect(player_img, 150, 130)

player.x = default_centerX + 80
player.y = default_centerY + 70
player.alpha = 1
player.name = "player"

local function staydoe(event)
     if(isplaying == false) then
        player.rotation = player.rotation+.5
     end
end



local sceneGroup

function scene:create(event)
         isplaying = false
        sceneGroup = self.view
        forbackground()
        group_back:insert(background1)
        group_back:insert(background2)
        group_back:toBack()

        group_front:insert(background3)
        group_front:insert(btn_play)
        group_front:insert(btn_settings)
        group_front:insert(btn_help)
        group_front:insert(messageText)
        group_front:insert(player)
        group_front:toFront()



        sceneGroup:insert(group_back)
        sceneGroup:insert(group_front)
        sceneGroup:insert(background4)
     audio.setVolume(1, {channel = 1})
    local backgroundMusic = audio.loadStream("resources/sound/dhey_menu.mp3")
    local option = {
        channel = 1,
        loops = 50,
        fadeIn = 3000
    }
    local backgroundMusicChannel = audio.play(backgroundMusic, option)
end

function scene:show(event)
    local phase = event.phase
    if phase == "did" then
        isplaying = false
         group_back:insert(background1)
        group_back:insert(background2)
        group_back:toBack()

        group_front:insert(background3)
        group_front:insert(btn_play)
        group_front:insert(btn_settings)
        group_front:insert(btn_help)
        group_front:insert(messageText)
        group_front:toFront()

          Runtime:addEventListener("enterFrame", move_background)
          Runtime:addEventListener("enterFrame", staydoe)
    end
end

function scene:hide(event)
    local phase = event.phase
    if phase == "will" then
    isplaying = true
    end
end

function scene:destroy(event)
    local phase = event.phase
    if phase == "will" then
    isplaying = true
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
return scene
