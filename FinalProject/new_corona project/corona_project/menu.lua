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


local customfont = native.newFont("resources/fonts/BRLNSDB_0.TTF", 16)


local bg_sounds = nil
local group_front = display.newGroup()
local group_back = display.newGroup()

local isplaying = false


local obstacle_random = 0
local countercollide = 0
local background1, background2, background3

local isdead = false
local taptostart = false


local doe_img
local doe_outline
local doe

local timer_spawn
local getcurr = {}

local default_speed = 6
local ifdone = false

local getsounds_onoff
local getanimation_onoff

local modal_about, modal_settings, btn_close_about, btn_close_settings, btn_on_sounds, btn_off_sounds, btn_on_animation, btn_off_animation
local group_about = display.newGroup()
local group_settings = display.newGroup()

local sqlite3 = require("sqlite3")
local score = 0

local path = system.pathForFile("mydb.db", system.DocumentsDirectory)
local path_option = system.pathForFile("mydb.db", system.DocumentsDirectory)

local db = sqlite3.open(path)
local db_option = sqlite3.open(path_option)
local function onSystemEvent(event)
    if (event.type == "applicationExit") then
        db:close()
    end
end


local createTable = [[CREATE TABLE IF NOT EXISTS tblScore(UserID INTEGER PRIMARY KEY AUTOINCREMENT, Score INTEGER);]]

db:exec(createTable)



local txt_score
local options = {
    text = "",
    emboss = true,
    fontSize = 150,
    font = customfont,
    height = 0
}
txt_score = display.newText(options)
txt_score:setFillColor(255 / 255, 255 / 255, 255 / 255)
txt_score.x = default_centerX
txt_score.y = 160

local sub_text
local options = {
    text = "BEST TIME ",
    emboss = true,
    fontSize = 90,
    font = customfont,
    align = "middle",
    height = 0
}
sub_text = display.newText(options)
sub_text:setFillColor(255 / 255, 255 / 255, 255 / 255)
sub_text.x = default_centerX
sub_text.y = 50
--
local userID = "0"
local hasScore = false

local userID = "0"
local hasScore = false

local function GetScore()
    
    for row in db:nrows("SELECT UserID FROM tblScore") do
        userID = row.UserID
    end
    
    for row in db:nrows("SELECT Score FROM tblScore WHERE UserID =" .. userID .. ";") do
        if row.Score == nil then
            getscore = 0
            return getscore
        else
            getscore = row.Score
            return getscore
        end
    end
end



local ButtonHandler = function(event)
        
        -- if (playing ==  false) then
        if ((event.target.id == "btn_play") and not (modal_settings.y == default_centerY) and not (modal_about.y == default_centerY)) then
            
            print(getanimation_onoff)
            audio.setVolume(0, {channel = 1})
            print(getsounds_onoff)
            local params_option = {
                sounds = getsounds_onoff,
                animation = getanimation_onoff
            }
            
            isplaying = true
            composer.gotoScene("maingame", {effect = "zoomInOutFade", time = 400, params = params_option})
            
        end
        if ((event.target.id == "btn_about") and (modal_settings.y <= default_centerY)) then
            btn_close_about.isVisible = true
            modal_about.isVisible = true
            transition.to(modal_about, {y = default_centerY, time = 1240, transition = easing.inOutCubic})
            transition.to(btn_close_about, {y = 50, time = 1140, transition = easing.inOutCubic})
        end
        
        if ((event.target.id == "btn_settings") and (modal_about.y <= default_centerY)) then
            
            btn_close_settings.isVisible = true
            modal_settings.isVisible = true
            btn_on_sounds.isVisible = true
            btn_off_sounds.isVisible = true
            btn_on_animation.isVisible = true
            btn_off_animation.isVisible = true
            
            transition.to(modal_settings, {y = default_centerY, time = 1240, transition = easing.inOutCubic})
            transition.to(btn_close_settings, {y = 50, time = 1140, transition = easing.inOutCubic})
            
            transition.to(btn_on_sounds, {y = default_centerY - 100, time = 1240, transition = easing.inOutCubic})
            transition.to(btn_off_sounds, {y = default_centerY - 100, time = 1240, transition = easing.inOutCubic})
            transition.to(btn_on_animation, {y = default_centerY + 200, time = 1240, transition = easing.inOutCubic})
            transition.to(btn_off_animation, {y = default_centerY + 200, time = 1240, transition = easing.inOutCubic})
        end
        
        if event.target.id == "btn_on_sounds" then
            getsounds_onoff = true
            btn_on_sounds.alpha = 0.5
            btn_off_sounds.alpha = 1
            audio.setVolume(1, {channel = 1})
        --  getanimation_onoff = event.params.onoff_animation
        end
        
        if event.target.id == "btn_off_sounds" then
            getsounds_onoff = false
            btn_on_sounds.alpha = 1
            btn_off_sounds.alpha = 0.5
            audio.setVolume(0, {channel = 1})
        --  getanimation_onoff = event.params.onoff_animation
        end
        
        
        if event.target.id == "btn_on_animation" then
            getanimation_onoff = true
            btn_on_animation.alpha = 0.5
            btn_off_animation.alpha = 1
        end
        
        if event.target.id == "btn_off_animation" then
            getanimation_onoff = false
            btn_on_animation.alpha = 1
            btn_off_animation.alpha = 0.5
        end
        
        
        
        
        if event.target.id == "btn_close_about" then
            transition.to(modal_about, {y = -default_centerY * 1.5, time = 1240, transition = easing.inOutCubic})
            transition.to(btn_close_about, {y = -default_height * 3, time = 1140, transition = easing.inOutCubic})
        end
        
        if event.target.id == "btn_close_settings" then
            transition.to(modal_settings, {y = -default_centerY * 1.5, time = 1240, transition = easing.inOutCubic})
            transition.to(btn_close_settings, {y = -default_height * 3, time = 1140, transition = easing.inOutCubic})
            
            transition.to(btn_on_sounds, {y = -default_centerY * 1.5, time = 1240, transition = easing.inOutCubic})
            transition.to(btn_off_sounds, {y = -default_centerY * 1.5, time = 1240, transition = easing.inOutCubic})
            
            transition.to(btn_on_animation, {y = -default_centerY * 1.5, time = 1340, transition = easing.inOutCubic})
            transition.to(btn_off_animation, {y = -default_centerY * 1.5, time = 1340, transition = easing.inOutCubic})
        end
-- end
end

local btn_play = widget.newButton
    {
        id = "btn_play",
        defaultFile = "resources/images/play.png",
        -- overFile = "resources/b2.png",
        -- label = "PLAY",
        emboss = true,
        fontSize = 100,
        width = 150,
        height = 150,
        font = customfont,
        labelColor = {default = {255 / 255, 202 / 255, 173 / 255}, },
        onEvent = ButtonHandler,
}
btn_play.x = default_centerX
btn_play.y = default_centerY + 300


local btn_settings = widget.newButton
    {
        id = "btn_settings",
        defaultFile = "resources/images/settings.png",
        emboss = true,
        fontSize = 100,
        width = 120,
        height = 120,
        emboss = true,
        fontSize = 40,
        font = customfont,
        labelColor = {default = {255 / 255, 202 / 255, 173 / 255}, },
        onEvent = ButtonHandler,
}

btn_settings.x = default_centerX - 100
btn_settings.y = default_centerY + 430


local btn_about = widget.newButton
    {
        id = "btn_about",
        defaultFile = "resources/images/about.png",
        width = 120,
        height = 120,
        fontSize = 40,
        font = customfont,
        labelColor = {default = {255 / 255, 202 / 255, 173 / 255}, },
        onEvent = ButtonHandler,
}


btn_about.x = default_centerX + 100
btn_about.y = default_centerY + 430

btn_close_about = widget.newButton
    {
        id = "btn_close_about",
        defaultFile = "resources/images/close.png",
        width = 100,
        height = 100,
        onEvent = ButtonHandler,
}


btn_close_settings = widget.newButton
    {
        id = "btn_close_settings",
        defaultFile = "resources/images/close.png",
        width = 100,
        height = 100,
        onEvent = ButtonHandler,
}


btn_on_sounds = widget.newButton
    {
        id = "btn_on_sounds",
        defaultFile = "resources/images/on.png",
        width = 100,
        height = 60,
        onEvent = ButtonHandler,
}



btn_off_sounds = widget.newButton
    {
        id = "btn_off_sounds",
        defaultFile = "resources/images/off.png",
        width = 100,
        height = 60,
        onEvent = ButtonHandler,
}

btn_on_animation = widget.newButton
    {
        id = "btn_on_animation",
        defaultFile = "resources/images/on.png",
        width = 100,
        height = 60,
        onEvent = ButtonHandler,
}


btn_off_animation = widget.newButton
    {
        id = "btn_off_animation",
        defaultFile = "resources/images/off.png",
        width = 100,
        height = 60,
        onEvent = ButtonHandler,
}






local tPrevious = system.getTimer()
local function getDeltaTime()
    local currentTime = system.getTimer()
    local deltaTime = currentTime - prevTime
    prevTime = currentTime
    return deltaTime
end

display.setDefault("background", 175 / 255, 2 / 255, 51 / 255)


local function formodals(event)
    
    group_about.x = default_centerX
    group_about.y = default_centerY
    
    modal_about = display.newImageRect("resources/images/modal_about.png", default_width, default_height)
    modal_about.x = group_about.x
    modal_about.y = group_about.y
    modal_about.isVisible = false
    
    btn_close_about.x = modal_about.width - 90
    btn_close_about.y = 50
    btn_close_about.isVisible = false
    
    transition.to(modal_about, {y = -default_centerY * 1.5, time = 100, transition = easing.inOutCubic})
    transition.to(btn_close_about, {y = -default_height * 3, time = 100, transition = easing.inOutCubic})
    
    modal_settings = display.newImageRect("resources/images/modal_settings.png", default_width, default_height)
    modal_settings.x = group_about.x
    modal_settings.y = group_about.y
    -- modal_settings.isVisible = false
    btn_close_settings.x = modal_about.width - 90
    -- btn_close_settings.y = 50
    -- -- btn_close_settings.isVisible = false
    btn_on_sounds.x = default_centerX - 100
    btn_on_sounds.y = default_centerY - 100
    btn_off_sounds.x = default_centerX + 100
    btn_off_sounds.y = default_centerY - 100
    btn_on_sounds.isVisible = false
    btn_off_sounds.isVisible = false
    
    btn_on_animation.x = default_centerX - 100
    btn_on_animation.y = default_centerY + 200
    btn_off_animation.x = default_centerX + 100
    btn_off_animation.y = default_centerY + 200
    btn_on_animation.isVisible = false
    btn_off_animation.isVisible = false
    
    
    transition.to(modal_settings, {y = -default_centerY * 1.5, time = 100, transition = easing.inOutCubic})
    transition.to(btn_close_settings, {y = -default_height * 3, time = 100, transition = easing.inOutCubic})
    transition.to(btn_on_sounds, {y = -default_height * 3, time = 100, transition = easing.inOutCubic})
    transition.to(btn_off_sounds, {y = -default_height * 3, time = 100, transition = easing.inOutCubic})
    transition.to(btn_on_animation, {y = -default_height * 3, time = 100, transition = easing.inOutCubic})
    transition.to(btn_off_animation, {y = -default_height * 3, time = 100, transition = easing.inOutCubic})
end


local background1, background2, background3, background4, background5, background6


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
    
    
    background5 = display.newImageRect("resources/images/bg_menu_1_1.png", default_width_a, default_height_a)
    background5.x = default_centerX
    background5.y = default_height / 2
    
    background6 = display.newImageRect("resources/images/bg_menu_1_2.png", default_width_a, default_height_a)
    background6.x = default_centerX
    background6.y = -((default_height_a / 2) + 120)

end

local counter = 0
local function move_inhale_exhale(event)
    
    if (counter == 0) then
        counter = 1
        transition.to(group_front, {y = group_front.y + 23, time = 1700, transition = easing.inOutCubic})
        transition.to(background1, {y = background1.y - 23, time = 1700, transition = easing.inOutCubic})
        transition.to(background2, {y = background2.y - 23, time = 1700, transition = easing.inOutCubic})
    else
        counter = 0
        transition.to(group_front, {y = group_front.y - 23, time = 1700, transition = easing.inOutCubic})
        transition.to(background1, {y = background1.y + 23, time = 1700, transition = easing.inOutCubic})
        transition.to(background2, {y = background2.y + 23, time = 1700, transition = easing.inOutCubic})
    end

end

timer.performWithDelay(1400, move_inhale_exhale, 0)



local subcosubcount = 0
local bakgroundsub = false
local parallax = 1;

local function move_background(event)
    
    if (isplaying == false) then
        if (getanimation_onoff) then
            background1.x = background1.x + .5
            background2.x = background2.x + .5
            background5.y = background5.y + 1
            background6.y = background6.y + 1
            if background1.x == default_width * 1.5 then
                background1.x = default_width * -.5
            end
            if background2.x == default_width * 1.5 then
                background2.x = default_width * -.5
            end
            
            if background5.y >= default_height * 2 then
                background5.y = -((default_height_a / 2) + 120)
            end
            
            if background6.y >= (default_height) * 2 then
                background6.y = -((default_height_a / 2) + 120)
            end
        end
    end

end





local doe_img, doe_outline, doe

doe_img = "resources/images/player.PNG"
doe_outline = graphics.newOutline(2, doe_img)
doe = display.newImageRect(doe_img, 150, 130)

doe.x = default_centerX + 5
doe.y = default_centerY + 110
doe.alpha = 1
doe.name = "doe"

local function staydoe(event)
    if (isplaying == false) then
        doe.rotation = doe.rotation + .05
        
        if (doe.y > (default_centerY + 70)) then
            transition.to(doe, {x = default_centerX + 80, y = default_centerY + 70, time = 100, transition = easing.inOutCubic})
        end
    end
end



local bubble_img = "resources/images/bubble.png"
local bubble_outline = graphics.newOutline(2, bubble_img)
local bodies_bubble = {}


local function spawn_bubble(event)
    if (isplaying == false) then
        for a = 1, 10, 1 do
            bodies_bubble[a] = display.newImageRect(bubble_img, 100, 100)
            bodies_bubble[a].name = "red_circle"
            bodies_bubble[a].alpha = 0.7
            bodies_bubble[a].x = math.random(0, default_width)
            bodies_bubble[a].y = math.random(0, default_height / 2)
            bodies_bubble[a].y = bodies_bubble[a].y - ((a * 500) + default_height)
        end
    end
end
local sizerand
local function move_bubble(event)
    if (isplaying == false) then
        for a = 1, #bodies_bubble, 1 do
            if (getanimation_onoff) then
                bodies_bubble[a].isVisible = true
                bodies_bubble[a].rotation = bodies_bubble[a].rotation + .5
                bodies_bubble[a].y = bodies_bubble[a].y + 2.4
                
                if bodies_bubble[a].y >= (default_height * 2) then
                    bodies_bubble[a].x = math.random(0, default_width * 1.5)
                    bodies_bubble[a].y = (default_height * -.5) - math.random(100, default_height)
                    bodies_bubble[a].x = math.random(0, default_width)
                    sizerand = math.random(-2, 2)
                    bodies_bubble[a].xScale = sizerand
                    bodies_bubble[a].yScale = sizerand
                end
            else
                bodies_bubble[a].isVisible = false
            end
        end
    else
        
        end

end

local sceneGroup




function scene:create(event)
    
    isplaying = false
    sceneGroup = self.view
    forbackground()
    formodals()
    group_back:insert(background5)
    group_back:insert(background1)
    group_back:insert(background2)
    group_back:insert(background6)
    group_back:toBack()
    
    group_front:insert(background3)
    
    group_front:insert(btn_play)
    group_front:insert(btn_settings)
    group_front:insert(btn_about)
    group_front:insert(txt_score)
    group_front:insert(sub_text)
    group_front:insert(doe)
    
    group_front:insert(modal_about)
    group_front:insert(btn_close_about)
    
    
    group_front:insert(modal_settings)
    group_front:insert(btn_close_settings)
    group_front:insert(btn_on_sounds)
    group_front:insert(btn_off_sounds)
    group_front:insert(btn_on_animation)
    group_front:insert(btn_off_animation)
    
    group_front:toFront()
    
    sceneGroup:insert(group_back)
    sceneGroup:insert(group_front)
    sceneGroup:insert(background4)
    
    
    txt_score.text = GetScore()

end

function scene:show(event)
    local phase = event.phase
    if phase == "did" then
        isplaying = false
        txt_score.text = GetScore()
        group_back:insert(background5)
        group_back:insert(background6)
        group_back:insert(background1)
        group_back:insert(background2)
        group_back:toBack()
        
        group_front:insert(background3)
        group_front:insert(btn_play)
        group_front:insert(btn_settings)
        group_front:insert(btn_about)
        group_front:insert(txt_score)
        group_front:insert(sub_text)
        group_front:insert(doe)
        
        
        group_front:insert(modal_about)
        group_front:insert(btn_close_about)
        
        
        group_front:insert(modal_settings)
        group_front:insert(btn_close_settings)
        group_front:insert(btn_on_sounds)
        group_front:insert(btn_off_sounds)
        group_front:insert(btn_on_animation)
        group_front:insert(btn_off_animation)
        
        group_front:toFront()
        
        sceneGroup:insert(group_back)
        sceneGroup:insert(group_front)
        sceneGroup:insert(background4)
        
        
        Runtime:addEventListener("enterFrame", move_background)
        Runtime:addEventListener("enterFrame", staydoe)
        
        getsounds_onoff = event.params.sounds
        getanimation_onoff = event.params.animation
        print(getsounds_onoff)
        print("getsounds_onoff")
        print(getanimation_onoff)
        
        local backgroundMusic = audio.loadStream("resources/sound/dhey_menu.mp3")
        local option = {
            channel = 1,
            loops = 50,
            fadeIn = 3000
        }
        local backgroundMusicChannel = audio.play(backgroundMusic, option)
        if (getsounds_onoff) then
            btn_on_sounds.alpha = 0.5
            btn_off_sounds.alpha = 1
            audio.setVolume(1, {channel = 1})
        end
        
        if (getanimation_onoff) then
            btn_on_animation.alpha = 0.5
            btn_off_animation.alpha = 1
            spawn_bubble()
            for a = 1, #bodies_bubble, 1 do
                bodies_bubble[a].alpha = 0.7
                sceneGroup:insert(bodies_bubble[a])
            end
            Runtime:addEventListener("enterFrame", move_bubble)
        end
    end
end

function scene:hide(event)
    local phase = event.phase
    if phase == "will" then
        isplaying = true
        audio.setVolume(1, {channel = 1})
        for a = 1, #bodies_bubble, 1 do
            display.remove(bodies_bubble[a])
        end
    end
end

function scene:destroy(event)
    local phase = event.phase
    if phase == "will" then
        isplaying = true
        for a = 1, #bodies_bubble, 1 do
            display.remove(bodies_bubble[a])
        end
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
return scene
