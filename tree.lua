--This is a computercraft program for harvesting vanilla trees - update from my previous version of 2016 to work with the new block naming convention
local tArgs = {...}

local height = 0
local save = {x=0,y=0}
local ups = 0
local boo,bran = false,{}
local max = 0
local spotted = false
local ambient = left
local two,woods = false,{}

function spiny()
  --should turtle continue up
  --tests for adjacent blocks and wood
  for y=1,4,1 do
    boo,bran = turtle.inspect()
    if boo and nil ~= string.find(bran.name, _log) then
      save.x = save.x + 1
      turtle.dig()
      fuel()
      turtle.forward()
      if boo then
        ups = 1
        max = 0
      end
      break
    end
    turtle.turnRight()
    ups=0
  end
end


function upy()
  if turtle.detectUp() or ups == 1 or max == 0 then
    if turtle.detectUp() == false then
      max = 1
    else
      max = 0
    end
    turtle.digUp()
    fuel()
    turtle.up()
    height = height + 1
    if save.x ~= 0 then
      save.y = save.y + 1
    end
  else
    downy()  --go down instead
  end
end

function downy()
  if save.y  0 then
    while save.y  0 do
      turtle.digDown()
      fuel()
      turtle.down()
      save.y = save.y - 1
      height = height - 1
    end
    if save.x  0 then
      turtle.turnLeft()
      turtle.turnLeft()
      while save.x  0 do
        turtle.dig()
        fuel()
        turtle.forward()
        save.x = save.x - 1
      end
    end
  else
    while height  0 do
      fuel()
      turtle.down()
      height = height - 1
    end
    spotted = true
  end
end

function checks()
  --determines how to run when no arguments are given
  two,woods = turtle.inspect()
	print(two,woods) --
  if two then
    turtle.turnLeft()
    if turtle.detect() then
      ambient = left
    else
      ambient = right
    end
    turtle.turnRight()
    if woods.name ~= minecraftspruce_log then
      heaven()
    else
      pines()
    end
  else
    two,woods = turtle.inspectUp()
    if woods.name ~= minecraftacacia_log then
      single()
    else
      orange()
    end
  end
end

function handedness()
  --used for 2x2 non spruce trees
  if ambient == left then
    turtle.turnLeft()
  else
    turtle.turnRight()
  end
end

function orange()
  while spotted == false do
    spiny()
    upy()
  end
end

function single()
  while turtle.detectUp() do
    height = height + 1
    turtle.digUp()
    fuel()
    turtle.up()
  end
  while height  0 do
    height = height - 1
    fuel()
    turtle.down()
  end
end

function pines()
  while turtle.detect() or turtle.detectUp() do
    height = height + 1
    turtle.dig()
    turtle.digUp()
    fuel()
    turtle.up()
  end
  handedness()
  turtle.dig()
  fuel()
  turtle.forward()
  if ambient == left then
    turtle.turnRight()
  else
    turtle.turnLeft()
  end
  while height  0 do
    height = height - 1
    turtle.dig()
    turtle.digDown()
    fuel()
    turtle.down()
  end
  turtle.dig()
end

function heaven()
  turtle.dig()
  fuel()
  turtle.forward()
  handedness()
  while turtle.detectUp() or turtle.detect() do
    turtle.dig()
    turtle.digUp()
    fuel()
    turtle.forward()
    handedness()
    turtle.digUp()
    fuel()
    turtle.up()
    height = height + 1
  end
  turtle.turnLeft()
  turtle.turnLeft()
  turtle.dig()
  fuel()
  turtle.forward()
  while height  0 do
    turtle.digDown()
    fuel()
    turtle.down()
    height = height - 1
  end
  turtle.turnRight()
end

function words()
  if #tArgs == 1 then
		-- acacia or other branching trees. very slow
    if tArgs[1] == a then
      orange()
    end
		-- straight up, minimal tests. fastest. default if check for 2 fails
    if tArgs[1] == one then
      single()
    end
  else
    if #tArgs == 2 then
      if tArgs[2] == left then
        ambient = left
      end
      if tArgs[2] == right then
        ambient = right
      end
			-- for 2x2 spruce (checked). pass this arg for other non branching 2x2 (modded) trees
      if tArgs[1] == spruce then
        pines()
      end
			-- for 2x2 trees that are expected to have branches. eg jungle, dark oak. mines a staircase into the tree and returns. default if check for 2 is success
      if tArgs[1] == two then
        heaven()
      end
    end
  end
end

function fuel()
	-- 36 is used as a buffer number for refueling
  if turtle.getFuelLevel()  36 then
    turtle.refuel(1)
  end
end

function main()
  turtle.select(1)
  turtle.dig()
  fuel()
  turtle.forward()
  if #tArgs  0 then
    words()
  else
    checks()
  end
  turtle.back()
end
main()