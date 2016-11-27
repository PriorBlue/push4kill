require("lib/postshader")
require("lib/level")
require("lib/parts")
require("lib/player")
require("lib/bulletManager")
require("lib/bullet")

function love.load()
	world = love.physics.newWorld(0, 9.81 * 64, true)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	
	level = CreateLevel(world, 0, 0, "level", 256)
	
	player1 = CreatePlayer(world, 128, 128, 8)
	player2 = CreatePlayer(world, 512, 128, 8)
	
	joystickX = 0
	
	bulletManager = CreateBulletManager(world)
	bulletManager:newBullet(player1, 1, 0, player1)
end

function love.update(dt)
	if love.keyboard.isDown("d") then
		player1:moveLeft()
	end

	if love.keyboard.isDown("a") then
		player1:moveRight()
	end

	if joystickX > 0.5 then
		player2:moveLeft()
	end

	if joystickX < -0.5 then
		player2:moveRight()
	end

	player1:update(dt)
	player2:update(dt)
	level:update(dt)
	world:update(dt)
end

function love.draw()
	level:draw()
	
	player1:draw()
	player2:draw()
	
	bulletManager:draw()
end

function love.keypressed(key)
	if key == "space" then
		player1:jump()
	end
	
	if key == "up" then
		level:moveY(math.floor(player1.body:getX() / 256) + 2, -1)
	elseif key == "down" then
		level:moveY(math.floor(player1.body:getX() / 256) + 2, 1)
	elseif key == "left" then
		level:moveX(math.floor(player1.body:getY() / 256) + 2, -1)
	elseif key == "right" then
		level:moveX(math.floor(player1.body:getY() / 256) + 2, 1)
	end
end

function love.keyreleased(key)

end

function love.mousepressed(x, y, button)

end

function love.mousemoved(x, y, dx, dy)

end

function beginContact(a, b, coll)
	local data = {a:getUserData(), b:getUserData()}
	local n = {coll:getNormal()}

	for i = 1, 2 do
		if data[i] then
			if data[i].type == "player" and n[i] <= 0 then
				data[i].canJump = 2
			end
			
			if data[i].type == "bullet" then
				if data[3 - i] and data[3 - i].type == "player" and data[i].source ~= data[3 - i] then
					data[i]:destroy()
				end
			end
		end
	end
end
 
function endContact(a, b, coll)
	
end
 
function preSolve(a, b, coll)
		
end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
	
end

function love.gamepadpressed(joystick, button)
	if button == "a" then
		player2:jump()
	end
	
	if button == "dpup" then
		level:moveY(math.floor(player2.body:getX() / 256) + 2, -1)
	elseif button == "dpdown" then
		level:moveY(math.floor(player2.body:getX() / 256) + 2, 1)
	elseif button == "dpleft" then
		level:moveX(math.floor(player2.body:getY() / 256) + 2, -1)
	elseif button == "dpright" then
		level:moveX(math.floor(player2.body:getY() / 256) + 2, 1)
	end
	print(joystick,button)
end

function love.gamepadaxis(joystick, axis, value)
	if axis == "leftx" then
		joystickX = value
	end
end