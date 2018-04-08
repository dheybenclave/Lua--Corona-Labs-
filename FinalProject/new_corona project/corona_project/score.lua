local sqlite3 = require("sqlite3")
local widget = require("widget")
local score = 0
local path = system.pathForFile("mydb.db", system.DocumentsDirectory)
print(path)
local db = sqlite3.open(path)
local function onSystemEvent(event)
    if (event.type == "applicationExit") then
        db:close()
    end
end

local function createdb()
    local createTable = [[CREATE TABLE IF NOT EXISTS tblScore(UserID INTEGER PRIMARY KEY AUTOINCREMENT,
                                                        Score INTEGER);]]
    
    db:exec(createTable)
end

local userID = "0"
local hasScore = false
local function GetScore()
    for row in db:nrows("SELECT Score FROM tblScore WHERE UserID =" .. userID .. ";") do
        -- local result = row.UserID
        -- if result == nil then
        --     hasScore = false
        -- else
        --     hasScore = true
        --     userID = result
        if row.Score == nil then
            return 0
        else
            return row.Score
        end
    end
    return 0
end
local function handleButtonEvent(event)
    for row in db:nrows("SELECT UserID FROM tblScore") do
        if row.UserID == nil then
            hasScore = false
        else
            hasScore = true
            userID = row.UserID
        -- body
        end
    end
    if ("ended" == event.phase) then
        score = GetScore()
        if (hasScore) then
            print("The Score is " .. score)
            local query = [[UPDATE tblScore SET Score=Score+1 WHERE UserID=]] .. userID
            db:exec(query)
        else
            local query = [[INSERT INTO tblScore(Score) VALUES(]] .. score .. [[);]]
            db:exec(query)
        end
    end
end
-- local button = widget.newButton(
--     {
--         width = 240,
--         height = 120,
--         defaultFile = "b1.png",
--         overFile = "b2.png",
--         onEvent = handleButtonEvent
--     }
-- )
-- button.x = display.contentCenterX
-- button.y = 20
-- button:setLabel("Click Me")
