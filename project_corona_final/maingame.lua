display.setStatusBar(display.HiddenStatusBar)

local composer = require("composer")
composer.recycleOnSceneChange = true
local scene = composer.newScene()
local widget = require("widget")
local mainenter = require("menu")


local sceneGroup

local physics = require("physics")
-- physics.setDrawMode("hybrid")
physics.start();
physics.setGravity(0, 0)

local options = {
    effect = "zoomInOutFade",
    time = 700,
    transtion = easing.inOutBounce,

}

local _W = display.contentWidth
local _H = display.contentHeight

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

display.setDefault("background", 232 / 255, 232 / 255, 232 / 255)

-- score.createdb()
-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local sqlite3 = require("sqlite3")
local score = 0
local path = system.pathForFile("mydb.db", system.DocumentsDirectory)
print(path)
local db = sqlite3.open(path)
local function onSystemEvent(event)
    if (event.type == "applicationExit") then
        db:close()
    end
end

local createTable = [[CREATE TABLE IF NOT EXISTS tblScore(UserID INTEGER PRIMARY KEY AUTOINCREMENT, Score INTEGER);]]
db:exec(createTable)

local userID = "0"
local hasScore = false

local function GetScore()
    for row in db:nrows("SELECT Score FROM tblScore WHERE UserID =" .. userID .. ";") do
        if row.Score == nil then
            return 0
        else
            return row.Score
        end
    end
    return 0
end

local function My_DBEvent(event)
    for row in db:nrows("SELECT UserID FROM tblScore") do
        if row.UserID == nil then
            hasScore = false
        else
            hasScore = true
            userID = row.UserID
        -- body
        end
    end
    
    if (hasScore) then
        print("The Score is " .. score)
        print("GetScore" .. GetScore())
        local query = [[UPDATE tblScore SET Score=]] .. score .. [[ WHERE UserID=]] .. userID
        db:exec(query)
    else
        local query = [[INSERT INTO tblScore(Score) VALUES(]] .. score .. [[);]]
        db:exec(query)
    end

end

-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
local tPrevious = system.getTimer()
local obstacle_random = 0
local countercollide = 0
local background1, background2, background3

local isdead = false
local taptostart = false


local player_img
local player_outline
local player

local timer_spawn
local getcurr = {}

local default_speed = 6
local ifdone, ifdone3 = false



local function reset(event)
    transition.to(player, {y = default_height, time = 500})
    print('collide')
    isdead = true
    taptostart = false
    audio.fadeOut({channel = 2, timer = 1000})
    composer.gotoScene("menu", options)
    My_DBEvent()

end


local function dead_sounds(event)
    
    audio.setVolume(0.12, {channel = 2})
    audio.setVolume(1, {channel = 3})
    local id_enemy = audio.loadStream("resources/sound/HICCUP.WAV")
    local option_1 = {
        channel = 3,
        loops = 1,
    }
    audio.play(id_enemy, option_1)
end

local bg_sounds = nil



local function getDeltaTime()
    local currentTime = system.getTimer()
    local deltaTime = currentTime - prevTime
    prevTime = currentTime
    return deltaTime
end


local function moveX_forward(obs)
    
    if obs.x > default_width * 1.5 then
        obs.x = default_width * -.5
    end
end
local function moveX_backward(obs)
    obs.x = obs.x - 2
    if obs.x <= -default_width * .5 then
        obs.x = default_width + (default_width * .5)
    end
end

local function forbackground(event)
    
    background3 = display.newImageRect("resources/images/bg_shadow.png", default_width_a, default_height_a)
    background3.x = default_centerX
    background3.y = default_centerY
    
    background1 = display.newImageRect("resources/images/bg_menu_1.png", default_width_a, default_height_a)
    background1.x = default_centerX
    background1.y = default_centerY
    
    background2 = display.newImageRect("resources/images/bg_menu_2.png", default_width_a, default_height_a)
    background2.x = default_centerX
    background2.y = default_centerY - (default_height)

end
local function move_background(event)
    
    if taptostart == true then
        background1.y, background2.y = background1.y + default_speed, background2.y + default_speed
        if background1.y >= (default_height) * 1.5 then
            background1.y = (default_height) * -.5
        end
        if background2.y >= (default_height) * 1.5 then
            background2.y = (default_height) * -.5
        end
    end
end



local selfcol, othercol

local redCollisionFilter = {categoryBits = 2, maskBits = 3}

local myText
local function myTextScore()
    local options = {
        text = score,
        emboss = true,
        fontSize = 100,
        font = "Impact",
        height = 0
    }
    myText = display.newText(options)
    myText:setFillColor(0, 0, 0)
    myText.x = default_centerX
    myText.y = default_centerY - 600

end

local timer_score
local function player_score(event)
    if (taptostart == true) then
        score = event.count - 1
        myText.text = score
    end
end

timer_score = timer.performWithDelay(1000, player_score, 0)
timer.resume(timer_score)

---------------------PLAYER ---------------------------------------------------------
-----------------------------------------------------
player_img = "resources/images/player.PNG"
player_outline = graphics.newOutline(2, player_img)
player = display.newImageRect(player_img, 120, 100)

player.x = default_centerX
player.y = default_centerY + (display.contentHeight * .5)
player.alpha = 1
player.name = "player"
physics.addBody(player, "dynamic", {density = 0.5, outline = player_outline, filter = redCollisionFilter, bounce = 3, friction = 3})
player.collision = function(self, event)
        
        selfcol = self.name
        othercol = event.other.name
        print(othercol .. selfcol)
        
        if (event.phase == "began") then
            -- if (othercol == "cell") then
            --     print("wow")
            --     transition.to(player, {yScale = 1, xScale = 1, time = 1000, transition = easing.inOutCubic})
            -- end
            if (othercol == "cell") then
                print("safe_obs")
                
                transition.to(player, {yScale = 1, xScale = 1, time = 1000, transition = easing.inOutCubic})
            else
                if (countercollide == 0) then
                    countercollide = 1
                    physics.pause()
                    dead_sounds()
                    reset()
                end
            end
        end
        return true
end
player:addEventListener("collision")


local function move_player(event)
    if (taptostart == true) then
        player.rotation = player.rotation + .24
        
        if (player.y >= (default_height_a)) then
            transition.to(player, {y = default_centerY + (default_height * .5), time = 200, transition = easing.inOutCubic})
        end
    
    end
end

-- - ||||||||||||||||||||||||||||||||||||||||ROCK SPAWN ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
local bodies_rock = {}
local rock
local rock_img, rock_outline

-- rock_img = "resources/images/rock.png"
-- rock_outline = graphics.newOutline(2, rock_img)
-- rock = display.newImageRect(rock_img, default_width, default_height)
local function generateRock()

end
local function move_Rock()

end
-- - ||||||||||||||||||||||||||||||||||||||||CELL LIFE ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
local bodies_cell = {}
local cell
local cell_img, cell_outline

cell_img = "resources/images/cell_life.png"
cell_outline = graphics.newOutline(2, cell_img)
cell = display.newImageRect(cell_img, 100, 100)
local function generate_cell()
    bodies_cell[#bodies_cell + 1] = cell
    physics.addBody(cell, "static", {density = 0.5, outline = cell_outline, filter = redCollisionFilter})
    cell.x = math.random(0, default_centerX)
    cell.y = math.random(0, default_height)
    cell.name = "cell"
end
local function move_cell()
    if (taptostart == true) then
        cell.rotation = cell.rotation + .35
        cell.y = cell.y + default_speed
        if cell.y >= (default_height * 2) then
            cell.y = default_height * -2
            cell.x = math.random(0, default_width)
            ifdone = true
        end
    end
end

-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
-------------------Obstacle group 1----------------------
local bodies_obs_1 = {}
local obs_1
local obs_1_img, obs_1_outline

obs_1_img = "resources/images/obstacle_h_2.PNG"
obs_1_outline = graphics.newOutline(2, obs_1_img)
obs_1 = display.newImageRect(obs_1_img, 623.26, 162.52)

local function spawn_obs_1()
    
    bodies_obs_1[#bodies_obs_1 + 1] = obs_1
    physics.addBody(obs_1, "static", {density = 0.5, outline = obs_1_outline, filter = redCollisionFilter})
    obs_1:applyForce(-1500, 0, obs_1.x, obs_1.y)
    obs_1.x = default_centerX
    obs_1.y = 0
    obs_1.name = "safe"
end
local function move_Obstacle_1()
    if (taptostart == true) then
        obs_1.rotation = obs_1.rotation + 1
        obs_1.y = obs_1.y + default_speed
        if obs_1.y >= (default_height * 2) then
            obs_1.y = default_height * -2
            obs_1.x = math.random(0, default_width)
            ifdone = true
        end
    end
end
-- |||||||||||||||||||||||||||||||||||||||| GROUP 2 OBSTACLE||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
local Obstacle_2 = display.newGroup()
local Group_2 = display.newGroup()
local obs_2_img = "resources/images/obstacle_s_1.png"
local obs_2_outline = graphics.newOutline(2, obs_2_img)
local bodies_obs_2 = {}

local function spawn_obs_2()
    for a = 1, 3, 1 do
        bodies_obs_2[a] = display.newImageRect(obs_2_img, 150, 150)
        bodies_obs_2[a].name = "red_circle"
        physics.addBody(bodies_obs_2[a], "static", {density = 0.5, outline = obs_2_outline, filter = redCollisionFilter, bounce = 3, friction = 3})
        bodies_obs_2[a].x = bodies_obs_2[a].x + (100 + math.random(0, default_width))
        bodies_obs_2[a].y = math.random(0, default_height / 2)
        bodies_obs_2[a].y = bodies_obs_2[a].y - ((a * 500) + default_height)
    end

end

local function move_Obstacle_2()
    for a = 1, 3, 1 do
        if (taptostart == true) then
            bodies_obs_2[a].rotation = bodies_obs_2[a].rotation + .5
            if ifdone then
                ifdone = false
            
            end
            bodies_obs_2[a].y = bodies_obs_2[a].y + default_speed - 2
            
            if bodies_obs_2[a].y >= (default_height * 2) then
                bodies_obs_2[a].y = default_height * -.5
                bodies_obs_2[a].x = math.random(0, default_width)
                ifdone = true
            
            end
        end
    end

end
local counter = 0
local timer_inhale_exhale
local function inhaleexhale(event)
    for a = 1, 3, 1 do
        if (counter == 0) then
            counter = 1
            transition.to(bodies_obs_2[a], {x = bodies_obs_2[a].x + 150, time = 1700, transition = easing.inOutCubic})
        else
            counter = 0
            transition.to(bodies_obs_2[a], {x = bodies_obs_2[a].x - 150, time = 1700, transition = easing.inOutCubic})
        end
    end
end
timer_inhale_exhale = timer.performWithDelay(1200, inhaleexhale, 0)


-- |||||||||||||||||||||||||||||||||||||||||||||OBSTACLE 3||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
local bodies_obs_3 = {}
local obs_3_img = "resources/images/obstacle_c_1.png"
local obs_3_outline = graphics.newOutline(2, obs_3_img)

local function spawn_obs_3()
    for a = 1, 3, 1 do
        bodies_obs_3[a] = display.newImageRect(obs_3_img, 150, 150)
        physics.addBody(bodies_obs_3[a], "static", {density = 0.5, outline = obs_3_outline})
        bodies_obs_3[a].name = "violet_circle"
        bodies_obs_3[a].x = math.random(0, default_width)
        bodies_obs_3[a].y = math.random(0, default_height / 2)
        bodies_obs_3[a].y = bodies_obs_3[a].y - ((a * 200) + default_height)
    end
end

local function move_Obstacle_3()
    for a = 1, 3, 1 do
        if (taptostart == true) then
            bodies_obs_3[a].rotation = bodies_obs_3[a].rotation + default_speed
            bodies_obs_3[a].y = bodies_obs_3[a].y + default_speed
            -- ifdone3 = false
            if bodies_obs_3[a].y >= (default_height * 2) then
                bodies_obs_3[a].y = (default_height * -.5) - math.random(0, default_height)
                bodies_obs_3[a].x = math.random(0, default_width)
                ifdone = true
                ifdone3 = true
                print(ifdone3)
            end
        end
    end
end

-- -- ///////////////////////////////////////////////////////////////////
-- -- -------------------Obstacle group 4----------------------
local bodies_obs_4 = {}
local obs_4_img = "resources/images/obstacle_h_2.png"
local obs_4_outline = graphics.newOutline(2, obs_4_img)

local function spawn_Obs_4()
    for a = 1, 3, 1 do
        bodies_obs_4[a] = display.newImageRect(obs_4_img, 500, 120)
        physics.addBody(bodies_obs_4[a], "static", {density = 0.5, outline = obs_4_outline})
        bodies_obs_4[a].x = bodies_obs_4[a].x + 170
        bodies_obs_4[a].x = a * 600
        bodies_obs_4[a].name = "Obstacle_4"
    -- bodies_obs_4[a].x = math.random(0, default_width)
    -- bodies_obs_4[a].y = math.random(0, default_height / 2)
    -- bodies_obs_4[a].y = bodies_obs_4[a].y - ((a * 200) + default_height)
    end
end

local function move_Obstacle_4()
    for a = 1, 3, 1 do
        print(taptostart)
        if (taptostart == true) then
            
            moveX_backward(bodies_obs_4[a])
            bodies_obs_4[a].rotation = bodies_obs_4[a].rotation + 1
            bodies_obs_4[a].x = bodies_obs_4[a].x + default_speed
            if bodies_obs_4[a].x <= -default_width * .5 then
                bodies_obs_4[a].x = default_width + (default_width * .5)
            end

            bodies_obs_4[a].y = bodies_obs_4[a].y + default_speed
            if bodies_obs_4[a].y >= (default_height * 2) then
                bodies_obs_4[a].y = (default_height * -.5) - math.random(0, default_height)
                bodies_obs_4[a].x = math.random(0, default_width)
                ifdone = true
            end
        
        end
    end
end


--------------------------------------------OBSTACLE 6--------------------------------------------------------------
local bodies_obs_6 = {}
local reverse_obs_4, random_obs_4
local group_6_1_img, group_6_1_outline, group_6_1
local group_6_2_img, group_6_2_outline, group_6_2
local group_6_3, group_6_4, group_6_5, group_6_6, group_6_7, group_6_8
local randObs = {}

reverse_obs_4 = 1
random_obs_4 = 1

group_6_1_img = "resources/images/obstacle_h_1_1.png"
group_6_1_outline = graphics.newOutline(2, group_6_1_img)
group_6_1 = display.newImageRect(group_6_1_img, 500, 130)

group_6_2_img = "resources/images/obstacle_h_1.png"
group_6_2_outline = graphics.newOutline(2, group_6_2_img)
group_6_2 = display.newImageRect(group_6_2_img, 500, 130)
group_6_3 = display.newImageRect(group_6_1_img, 500, 130)
group_6_4 = display.newImageRect(group_6_2_img, 500, 130)
group_6_5 = display.newImageRect(group_6_1_img, 500, 130)
group_6_6 = display.newImageRect(group_6_2_img, 500, 130)
group_6_7 = display.newImageRect(group_6_1_img, 500, 130)
group_6_8 = display.newImageRect(group_6_2_img, 500, 130)

local timer_zigzag
local function spawn_obs_6()
    
    
    group_6_1.x = 0
    group_6_1.name = "group_4_1"
    physics.addBody(group_6_1, "static", {density = 0.5, outline = group_6_1_outline})
    bodies_obs_6[#bodies_obs_6 + 1] = group_6_1
    
    group_6_2.x = default_width
    group_6_2.name = "group_4_2"
    physics.addBody(group_6_2, "static", {density = 0.5, outline = group_6_2_outline})
    bodies_obs_6[#bodies_obs_6 + 1] = group_6_2
    
    group_6_3.x = 0
    group_6_3.name = "group_4_3"
    physics.addBody(group_6_3, "static", {density = 0.5, outline = group_6_1_outline})
    bodies_obs_6[#bodies_obs_6 + 1] = group_6_3
    
    group_6_4.x = default_width
    group_6_4.name = "group_4_4"
    physics.addBody(group_6_4, "static", {density = 0.5, outline = group_6_2_outline})
    bodies_obs_6[#bodies_obs_6 + 1] = group_6_4
    
    group_6_5.x = 0
    group_6_5.name = "group_4_5"
    physics.addBody(group_6_5, "static", {density = 0.5, outline = group_6_1_outline})
    bodies_obs_6[#bodies_obs_6 + 1] = group_6_5
    
    group_6_6.x = default_width
    group_6_6.name = "group_4_6"
    physics.addBody(group_6_6, "static", {density = 0.5, outline = group_6_2_outline})
    bodies_obs_6[#bodies_obs_6 + 1] = group_6_6
    
    group_6_7.x = 0
    group_6_7.name = "group_4_7"
    physics.addBody(group_6_7, "static", {density = 0.5, outline = group_6_1_outline})
    bodies_obs_6[#bodies_obs_6 + 1] = group_6_7
    
    group_6_8.x = default_width
    group_6_8.name = "group_4_8"
    physics.addBody(group_6_8, "static", {density = 0.5, outline = group_6_2_outline})
    bodies_obs_6[#bodies_obs_6 + 1] = group_6_8
    
    group_6_1.y, group_6_2.y = -400, -400
    group_6_3.y, group_6_4.y = -600, -600
    group_6_5.y, group_6_6.y = -800, -800
    group_6_7.y, group_6_8.y = -1000, -1000
end

local function zigzag(event)
    
    if (reverse_obs_4 == 0) then
        reverse_obs_4 = 1
        if random_obs_4 == 1 then
            transition.to(group_6_1, {x = (group_6_1.width * .5), time = 1200, transition = easing.inOutCubic})
            transition.to(group_6_2, {x = default_width + (group_6_2.width * .5), time = 1200, transition = easing.inOutCubic})
            transition.to(group_6_3, {x = (group_6_3.width * .5), time = 1000, transition = easing.inOutCubic})
            transition.to(group_6_4, {x = default_width + (group_6_4.width * .5), time = 1000, transition = easing.inOutCubic})
            transition.to(group_6_5, {x = (group_6_5.width * .5), time = 800, transition = easing.inOutCubic})
            transition.to(group_6_6, {x = default_width + (group_6_6.width * .5), time = 800, transition = easing.inOutCubic})
            transition.to(group_6_7, {x = (group_6_7.width * .5), time = 650, transition = easing.inOutCubic})
            transition.to(group_6_8, {x = default_width + (group_6_8.width * .5), time = 650, transition = easing.inOutCubic})
        end
    else
        reverse_obs_4 = 0
        if random_obs_4 == 1 then
            transition.to(group_6_1, {x = -(group_6_1.width * .5), time = 1200, transition = easing.inOutCubic})
            transition.to(group_6_2, {x = default_width - (group_6_2.width * .5), time = 1200, rotation = 0, transition = easing.inOutCubic})
            transition.to(group_6_3, {x = -(group_6_3.width * .5), time = 1000, transition = easing.inOutCubic})
            transition.to(group_6_4, {x = default_width - (group_6_4.width * .5), time = 1000, rotation = 0, transition = easing.inOutCubic})
            transition.to(group_6_5, {x = -(group_6_5.width * .5), time = 800, transition = easing.inOutCubic})
            transition.to(group_6_6, {x = default_width - (group_6_6.width * .5), time = 800, rotation = 0, transition = easing.inOutCubic})
            transition.to(group_6_7, {x = -(group_6_7.width * .5), time = 650, transition = easing.inOutCubic})
            transition.to(group_6_8, {x = default_width - (group_6_8.width * .5), time = 650, rotation = 0, transition = easing.inOutCubic})
        end
    end
end
timer_zigzag = timer.performWithDelay(800, zigzag, 0)

local function move_Obstacle_6()
    for i = 1, #bodies_obs_6, 1 do
        if (taptostart == true and ifdone3 == true) then
            
            bodies_obs_6[i].y = bodies_obs_6[i].y + 1
            if bodies_obs_6[i].y >= (default_height * 2) then
                bodies_obs_6[i].y = default_height * -.5
                bodies_obs_6[i].x = math.random(0, default_width)
                ifdone = true
            end
        end
    end
end


local function onTouch(event)
    
    local obj = event.target
    local phase = event.phase
    
    if ("began" == phase) then
        
        obj:toFront()
        if (isMultitouchEnabled == true) then
            display.currentStage:setFocus(obj, event.id)
        else
            display.currentStage:setFocus(obj)
        end
        if (player.y >= (default_height_a)) then
            transition.moveTo(player, {y = default_centerY + (default_height * .5), time = 200, transition = easing.inOutCubic})
        end
        obj.isFocus = true
        taptostart = true
        if (isdead == false) then
            player.x0 = event.x - player.x
            player.y0 = event.y - player.y
        end
    elseif obj.isFocus then
        if ("moved" == phase) then
            -- taptostart = true
            if (isdead == false) then
                player.x = event.x - player.x0
                player.y = event.y - player.y0
            end
            if (player.y >= (default_height_a)) then
                transition.moveTo(player, {y = default_centerY + (default_height * .5), time = 200, transition = easing.inOutCubic})
            end
        
        
        elseif ("ended" == phase or "cancelled" == phase) then
            -- transition.moveTo(player, {y = default_centerY + (display.contentHeight * .5), time = 800, onComplete = reset})
            transition.moveTo(player, {y = default_centerY + (default_height * .5), time = 200, transition = easing.inOutCubic})
            
            if (isMultitouchEnabled == true) then
                display.currentStage:setFocus(obj, nil)
            else
                display.currentStage:setFocus(nil)
            end
            obj.isFocus = false
        end
    end
    return true
end

function scene:create(event)
    sceneGroup = self.view
    
    forbackground()
    myTextScore()
    sceneGroup:insert(background1)
    sceneGroup:insert(background2)
    sceneGroup:insert(background3)
    sceneGroup:insert(player)
    sceneGroup:insert(myText)
    myText:toFront()
    countercollide = 0
    
    
    timer.resume(timer_inhale_exhale)
    timer.resume(timer_zigzag)
    audio.setVolume(1, {channel = 2})
    
    local backgroundMusic = audio.loadStream("resources/sound/loop4.wav")
    local option = {
        channel = 2,
        loops = 50,
        fadeIn = 3000
    }
    local backgroundMusicChannel = audio.play(backgroundMusic, option)
end
function scene:show(event)
    local phase = event.phase
    if phase == "did" then
        
        physics.start()
        myText.isVisible = true
        player.x = default_centerX
        player.y = default_centerY + (display.contentHeight * .5)
        player.alpha = 1
        
        countercollide = 0
        
        Runtime:addEventListener("enterFrame", move_background)
        background3:addEventListener("touch", onTouch)
        Runtime:addEventListener("enterFrame", move_player)
        
        generate_cell()
        Runtime:addEventListener("enterFrame", move_cell)
        
        spawn_obs_1()
        Runtime:addEventListener("enterFrame", move_Obstacle_1)
        
        spawn_obs_2()
        Runtime:addEventListener("enterFrame", move_Obstacle_2)
        timer.resume(timer_inhale_exhale)
        
        spawn_obs_3()
        Runtime:addEventListener("enterFrame", move_Obstacle_3)
        
        spawn_Obs_4()
        Runtime:addEventListener("enterFrame", move_Obstacle_4)
        
        spawn_obs_6()
        Runtime:addEventListener("enterFrame", move_Obstacle_6)
        timer.resume(timer_zigzag)
    
    end
end

function scene:hide(event)
    local phase = event.phase
    if phase == "will" then
        physics.pause()
        timer.pause(timer_inhale_exhale)
        timer.pause(timer_zigzag)
        myText.isVisible = false
        for a = 1, #bodies_cell, 1 do
            display.remove(bodies_cell[a])
        end
        
        for a = 1, #bodies_obs_1, 1 do
            display.remove(bodies_obs_1[a])
        end
        
        for a = 1, #bodies_obs_2, 1 do
            display.remove(bodies_obs_2[a])
        end
        
        for a = 1, #bodies_obs_3, 1 do
            display.remove(bodies_obs_3[a])
        end
        
        for a = 1, #bodies_obs_4, 1 do
            display.remove(bodies_obs_4[a])
        end
        
        for a = 1, #bodies_obs_6, 1 do
            display.remove(bodies_obs_6[a])
        end
    
    end
end

function scene:destroy(event)
    local phase = event.phase
    physics.pause()
    timer.pause(timer_inhale_exhale)
    timer.pause(timer_zigzag)
    myText.isVisible = false
    for a = 1, #bodies_obs_1, 1 do
        display.remove(bodies_obs_1[a])
    end

end


scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
return scene
