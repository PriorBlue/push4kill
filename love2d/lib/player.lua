playerImg = love.graphics.newImage("gfx/player_idle.png")
playerQuad = love.graphics.newQuad(0, 0, 43, 31, playerImg:getWidth(), playerImg:getHeight())

function CreatePlayer(world, x, y, radius)
	local obj = {}

	obj.x = x or 0
	obj.y = y or 0
	obj.radius = radius or 16
	obj.frame = 0
	obj.frameMax = 16

	obj.img = playerImg
	obj.quad = playerQuad
	obj.speed = 100
	obj.jumpStrength = 100

	obj.body = love.physics.newBody(world, x, y, "dynamic")
	obj.body:setFixedRotation(true)
	obj.shape = love.physics.newCircleShape(obj.radius)
	obj.fixture = love.physics.newFixture(obj.body, obj.shape)

	obj.update = function(self, dt)
		if love.keyboard.isDown("d") then
			player1:moveLeft()
		end

		if love.keyboard.isDown("a") then
			player1:moveRight()
		end

		if love.keyboard.isDown("space") then
			player1:jump()
		end
		
		obj.frame = obj.frame + dt * 20
	end

	obj.draw = function(self)
		obj.quad:setViewport(0, math.floor(obj.frame % obj.frameMax) * 31, 43, 31)
		love.graphics.draw(self.img, obj.quad, obj.body:getX(), obj.body:getY(), 0, 1, 1, 11, 24)
		
		love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
	end
	
	obj.moveLeft = function(self)
		local x, y = self.body:getLinearVelocity()
		
		obj.body:setLinearVelocity(obj.speed, y)
	end
	
	obj.moveRight = function(self)
		local x, y = self.body:getLinearVelocity()
		
		obj.body:setLinearVelocity(-obj.speed, y)
	end
	
	obj.jump = function(self)
		local x, y = self.body:getLinearVelocity()
		
		obj.body:setLinearVelocity(x, -obj.jumpStrength)
	end

	return obj
end