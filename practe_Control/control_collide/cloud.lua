
-------------------------------------------------------------------------------------------------------
-- Artwork used within this project is licensed under Public Domain Dedication
-- See the following site for further information: https://creativecommons.org/publicdomain/zero/1.0/
-------------------------------------------------------------------------------------------------------
-- Randomly generate a character in our sprite sheet to use



-- Create our player sprite sheet
local sheetOptions = {
	width = 50,
	height = 50,
	numFrames = 16,
	sheetContentWidth = 200,
	sheetContentHeight = 200
}

local sheet_cloud = graphics.newImageSheet("cloudsheet.png", sheetOptions)

local sequences_cloud = {


	{
		name = "even",
		--start = 1 + selOffset,
		--count = 4,
		frames = {(math.random(4))},
		-- time = 5000,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "odd",
		--start = 17 + selOffset,
		--count = 4,
		frames = {(math.random(4))},
		-- time = 5000,
		loopCount = 0,
		loopDirection = "forward"
	},
	-- {
	-- 	name = "walk-right",
	-- 	--start = 33 + selOffset,
	-- 	--count = 4,
	-- 	frames = {33 + selOffset, 34 + selOffset, 35 + selOffset, 33 + selOffset, 34 + selOffset, 36 + selOffset},
	-- 	time = 600,
	-- 	loopCount = 0,
	-- 	loopDirection = "forward"
	-- },
	-- {
	-- 	name = "walk-up",
	-- 	--start = 49 + selOffset,
	-- 	--count = 4,
	-- 	frames = {49 + selOffset, 50 + selOffset, 51 + selOffset, 49 + selOffset, 50 + selOffset, 52 + selOffset},
	-- 	time = 600,
	-- 	loopCount = 0,
	-- 	loopDirection = "forward"
	-- },
}

-- And, create the player that it belongs to
local cloud = display.newSprite(sheet_cloud, sequences_cloud)
-- character.x = display.contentCenterX
-- character.y = display.contentCenterY
-- character:setSequence("walk-right")

return cloud
