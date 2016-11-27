require("lib/postshader")
require("lib/level")
require("lib/parts")
require("lib/player")

function love.load()
	world = love.physics.newWorld(0, 9.81 * 64, true)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	
	level = CreateLevel(world, 0, 0, 6, 4, 256)
	
	player1 = CreatePlayer(world, 128, 128, 8)
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
	if key == "space" then
		if player1.canJump >= 1 then
			player1.canJump = player1.canJump - 1
			player1:jump()
		end
	end
end

function love.keyreleased(key)

end

function love.mousepressed(x, y, button)

end

function love.mousemoved(x, y, dx, dy)

end

function beginContact(a, b, coll)
	local data1 = a:getUserData()
	
	if data1 then
		data1.canJump = 2
	end
	
	local data2 = b:getUserData()

	if data2 then
		data2.canJump = 2
	end
end
 
function endContact(a, b, coll)
	
end
 
function preSolve(a, b, coll)
		
end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
	
end