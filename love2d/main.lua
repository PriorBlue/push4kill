require("lib/postshader")
require("lib/level")
require("lib/parts")
require("lib/player")
require("lib/bulletManager")
require("lib/bullet")

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest", 0)

	world = love.physics.newWorld(0, 9.81 * 64, true)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	
	level = CreateLevel(world, 0, 0, "level", 256)
	
	player1 = CreatePlayer(world, 128, 128, 8)
	player2 = CreatePlayer(world, 512, 128, 8)
	
	joystickX = 0
	
	bulletManager = CreateBulletManager(world, 1500)
	
	backImg = love.graphics.newImage("gfx/back.jpg")
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
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(backImg)
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
	if button == 1 then
		bulletManager:newBullet(player1, math.atan2(x - player1.body:getX(), y - player1.body:getY()))
	end
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
				if data[3 - i] then
					if data[3 - i].type == "player" then
						if data[i].source ~= data[3 - i] then
							data[3 - i].health = data[3 - i].health - 1
							data[i]:destroy()
						end
					end
				else
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