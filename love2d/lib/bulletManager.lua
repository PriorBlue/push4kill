function CreateBulletManager(world)
	local obj = {}
	
	obj.world = world
	obj.bullets = {}

	obj.newBullet = function(self, player, dx, dy)
		local bullet = CreateBullet(self.world, player, dx, dy, self)
		
		table.insert(obj.bullets, bullet)
	end
	
	obj.draw = function(self)
		for i, v in ipairs(self.bullets) do
			v:draw(dt)
		end
	end
	
	return obj
end