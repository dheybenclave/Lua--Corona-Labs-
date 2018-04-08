-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local players = {
 "John Doe", 
 "Susan Baker" , 
 "Jose Rizal"
}

print(players[1])

local standings = {
    firstplace = "John Doe", 
    secondplace = "Susan Baker"
}
print(standings.firstplace)
------------------------------------------
local mixedTable = {
    10 , 
    "This is the value" , 
    myNumber = 12 , 
    myTable = {
        30 , 
        firstplace = "John Doe"
    },
    newItem = "Item 1"
}

print(mixedTable.myNumber) --12
print(mixedTable.myTable.firstplace)
print(mixedTable.myTable[0])

-------------------------------------------------------

local playerWeapon= {
    name="Laser Sword" , 
    damage = 5 , 
    attackRange = 1
}
local spellsTable= {}

spellsTable[1] = {
    name = "Rain and Fire",
    damage = 5 ,
    nameCost = 10 , 
    attackMode = "Auto Kill",
    range = 5
}

local spell1 = spellsTable[1]
print(spell1.name)
----------------------------
for k,v in pairs(spellsTable) do 
 --   print(k..""..v)
 end
---------------------------
for i =1 , 10 , 1 do 
    print(players[i])
end

-------------------------------
--table.insert(nameoftable , value)

----------------------------------------

local val = 2 

if  val >= 1 and val <= 10 then 
    --statement
end

------------
 if val >=1 or val <= 10 then
  ---statement
end
--------------------

if not hasKilled then 
 ---------statement 
end 
--------------------

local numbers = {1, 2, 3,4 , 5 ,6 }

for i =1 , # numbers do 
    print(numbers[i])
    if(i == value) then 
        break
    end
end

local number = 0 
while number <= 5 do
    ----
end


function printSomething(something)
    print(something)
end

myFunction = function()
    print("Game Over")
end

myFunction()
printSomething("something")

function sumNumber(num1 , num2) 
    return num1 + num2
end

local sum = sumNumber(10, 2)

----------------- 
local number = {27 , 45 , 88 , 13 , 10 , 99 , 77}

