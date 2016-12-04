playerImg = love.graphics.newImage("gfx/player_anim.png")
playerHead = love.graphics.newImage("gfx/player_head.png")
playerWeapon = love.graphics.newImage("gfx/player_weapon.png")
playerQuad = love.graphics.newQuad(0, 0, 20, 29, playerImg:getWidth(), playerImg:getHeight())
playerHeadQuad = love.graphics.newQuad(0, 0, 58, 48, playerHead:getWidth(), playerHead:getHeight())

function CreatePlayer(world, x, y, radius)
	local obj = {}

	obj.type = "player"

	obj.x = x or 0
	obj.y = y or 0
	obj.radius = radius or 16
	obj.frame = 0
	obj.frame2 = 0
	obj.frameMax = 10
	obj.frameMax2 = 75
	obj.health = 10

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
	obj.anim = 0
	obj.angle = 0

	obj.body = love.physics.newBody(world, x, y, "dynamic")
	obj.body:setFixedRotation(true)
	obj.body:setSleepingAllowed(false)
	obj.shape = love.physics.newCircleShape(obj.radius)
	obj.fixture = love.physics.newFixture(obj.body, obj.shape)
	obj.fixture:setFriction(0)
	obj.fixture:setUserData(obj)

	obj.shape2 = love.physics.newRectangleShape(0, -32, 16, 64)
	obj.hitBox = love.physics.newFixture(obj.body, obj.shape2)
	obj.hitBox:setUserData(obj)
	obj.hitBox:setSensor(true)

	obj.update = function(self, dt)
		local x, y = self.body:getLinearVelocity()

		if self.isMoving ~= 0 then
			obj.body:setLinearVelocity(obj.speed * self.isMoving, y)
			obj.direction = self.isMoving
			
			self.isMoving = 0
			self.anim = 1
		else
			obj.body:setLinearVelocity(0, y)
			self.anim = 0
		end
		
		if not self.isMoving then
			self:stop()
		end
		
		obj.frame = obj.frame + dt * 10
		obj.frame2 = obj.frame2 + dt * 30
		
		if obj.animDirection < obj.direction then
			obj.animDirection = math.min(1, obj.animDirection + dt * 10)
		elseif obj.animDirection > obj.direction then
			obj.animDirection = math.max(-1, obj.animDirection - dt * 10)
		end
	end

	obj.draw = function(self)
		love.graphics.setColor(255, 255, 255)
		self.quad:setViewport(obj.anim * 20, math.floor(obj.frame % obj.frameMax) * 29, 20, 29)
		love.graphics.draw(self.img, obj.quad, obj.body:getX(), obj.body:getY(), 0, obj.animDirection, 1, 11, 20)
		self.quad2:setViewport(0, math.floor(obj.frame2 % obj.frameMax2) * 48, 58, 48)
		love.graphics.draw(self.img2, obj.quad2, obj.body:getX(), obj.body:getY(), 0, obj.direction, 1, 28, 58)
		love.graphics.draw(playerWeapon, obj.body:getX(), obj.body:getY() - 12, -obj.angle - math.pi * 1.5, 1, 1, 8, 10)
		love.graphics.print(self.health, obj.body:getX(), obj.body:getY() - 64)
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