local composer = require("composer")
local scene = composer.newScene()


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





display.setDefault("background", 24 / 255, 24 / 255, 25 / 255)

local mario = nil
local coin = nil
local id_jumpsound = nil
local id_coinsound = nil

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


function onTapListnerMario(event)
	
	audio.play(id_jumpsound)
	return true
end

function onTapListnerCoin(event)
	audio.play(id_coinsound)
	return true
end


function scene:create(event)
	local sceneGroup = self.view
	
	local helpText = display.newText("Tap mo si marion gago!", default_width_a, default_height_half - 200, native.Systemfontm, 30)
	helpText:setFillColor(1, 0, 0)
	
	mario = display.newImageRect("mario.png", 190, 250)
	mario.x = default_width_half
	mario.y = default_height_half + 20
	mario:addEventListener("tap", onTapListnerMario)
	
	coin = display.newImageRect("star_coin.png", 150, 145)
	coin.x = default_width_half
	coin.y = default_height_half - 200
	coin:addEventListener("tap", onTapListnerCoin)
	
	audio.setVolume(1.0)
	audio.setVolume(0.12, {channel = 1})
	
	local backgroundMusic = audio.loadStream("paper_mario_main_title.mp3")
	local option = {
		channel = 1,
		loops = 1,
		fadeIn = 3000
	}
	
	local backgroundMusicChannel = audio.play(backgroundMusic, option)
	id_jumpsound = audio.loadSound("mario_jump.wav")
	id_coinsound = audio.loadSound("get_coin.wav")
	
	sceneGroup:insert(helpText)
	sceneGroup:insert(coin)
	sceneGroup:insert(mario)
	
end

function scene:show(event)
	local phase = event.phase
	if phase == "did" then
		
	end
end

function scene:hide(event)
	local phase = event.phase
	if phase == "will" then
		
	end
end


























scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene
