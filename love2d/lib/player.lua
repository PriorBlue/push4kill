playerImg = love.graphics.newImage("gfx/player_idle.png")
playerHead = love.graphics.newImage("gfx/player_head.png")
playerQuad = love.graphics.newQuad(0, 0, 43, 31, playerImg:getWidth(), playerImg:getHeight())
playerHeadQuad = love.graphics.newQuad(0, 0, 58, 48, playerHead:getWidth(), playerHead:getHeight())

function CreatePlayer(world, x, y, radius)
	local obj = {}

	obj.type = "player"

	obj.x = x or 0
	obj.y = y or 0
	obj.radius = radius or 16
	obj.frame = 0
	obj.frameMax = 16
	obj.frameMax2 = 75

	obj.img = playerImg
	obj.quad = playerQuad
	obj.img2 = playerHead
	obj.quad2 = playerHeadQuad
	obj.speed = 200
	obj.jumpStrength = 300
	obj.canJump = 2
	obj.isMoving = 0
	obj.direction = 1
	obj.animDirection = 1

	obj.body = love.physics.newBody(world, x, y, "dynamic")
	obj.body:setFixedRotation(true)
	obj.body:setSleepingAllowed(false)
	obj.shape = love.physics.newCircleShape(obj.radius)
	obj.fixture = love.physics.newFixture(obj.body, obj.shape)
	obj.fixture:setFriction(0)
	obj.fixture:setUserData(obj)

	obj.update = function(self, dt)
		local x, y = self.body:getLinearVelocity()

		if self.isMoving ~= 0 then
			obj.body:setLinearVelocity(obj.speed * self.isMoving, y)
			obj.direction = self.isMoving
			
			self.isMoving = 0
		else
			obj.body:setLinearVelocity(0, y)
		end
		
		if not self.isMoving then
			self:stop()
		end
		
		obj.frame = obj.frame + dt * 30
		
		if obj.animDirection < obj.direction then
			obj.animDirection = math.min(1, obj.animDirection + dt * 10)
		elseif obj.animDirection > obj.direction then
			obj.animDirection = math.max(-1, obj.animDirection - dt * 10)
		end
	end

	obj.draw = function(self)
		love.graphics.setColor(255, 255, 255)
		obj.quad:setViewport(0, math.floor(obj.frame % obj.frameMax) * 31, 43, 31)
		love.graphics.draw(self.img, obj.quad, obj.body:getX(), obj.body:getY(), 0, obj.animDirection, 1, 11, 24)
		obj.quad2:setViewport(0, math.floor(obj.frame % obj.frameMax2) * 48, 58, 48)
		love.graphics.draw(self.img2, obj.quad2, obj.body:getX(), obj.body:getY(), 0, obj.direction, 1, 28, 60)
		
		--love.graphics.setColor(255, 0, 255, 63)
		--love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius())
	end
	
	obj.moveLeft = function(self)
		self.isMoving = 1
	end
	
	obj.moveRight = function(self)
		self.isMoving = -1
	end
	
	obj.jump = function(self)
		if self.canJump >= 1 then
			self.canJump = self.canJump - 1
			local x, y = self.body:getLinearVelocity()
		
			self.body:setLinearVelocity(x, -self.jumpStrength)
		end
	end

	return obj
end