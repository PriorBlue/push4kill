require("lib/postshader")
require("lib/level")
require("lib/parts")
require("lib/player")

function love.load()
	world = love.physics.newWorld(0, 9.81 * 64, true)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	
	level = CreateLevel(world, -128, -128, 6, 4)
	
	player1 = CreatePlayer(world, 128, 16, 8)
end

function love.update(dt)
	world:update(dt)
	player1:update(dt)
end

function love.draw()
	level:draw()
	
	player1:draw()
end

function love.keypressed(key)

end

function love.keyreleased(key)

end

function love.mousepressed(x, y, button)

end

function love.mousemoved(x, y, dx, dy)

end

function beginContact(a, b, coll)
	print(a)
end
 
function endContact(a, b, coll)
	
end
 
function preSolve(a, b, coll)
		
end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
	
end