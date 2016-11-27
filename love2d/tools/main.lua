require("lib.serial")

function love.load()
	files = love.filesystem.getDirectoryItems("/gfx/")
	images = {}
	images_name = {}
	images_data = {}
	selection = 0
	curRect = {}
	drawRect = false
	
	for i, v in ipairs(files) do
		images[i] = love.graphics.newImage("/gfx/" .. v)
		images_name[i] = v
		if love.filesystem.exists(v .. ".lua") then
			images_data[i] = love.filesystem.load(v .. ".lua")()
		else
			images_data[i] = {}
		end
	end
end

function love.draw()
	for i, v in ipairs(images) do
		if i == selection + 1 then
			love.graphics.setColor(0, 127, 255)
			love.graphics.rectangle("fill", 256, (i - 1) * 16, 128, 16)
		end
		love.graphics.setColor(255, 255, 255)
		love.graphics.print(images_name[i], 256, (i - 1) * 16)
	end

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(images[selection + 1]);
	
	for i, v in ipairs(images_data[selection + 1]) do
		love.graphics.setColor(0, 255, 127, 127)
		love.graphics.rectangle("fill", v[2], v[3], v[4], v[5])
	end
	
	if drawRect then
		love.graphics.setColor(0, 127, 255, 127)
		love.graphics.rectangle("fill", curRect.x, curRect.y, curRect.width, curRect.height)
	end
end

function love.keypressed(key)
	if key == "w" then
		selection = (selection - 1)  % #images
	end

	if key == "s" then
		selection = (selection + 1) % #images
	end
	
	if key == "space" then
		if images_data[selection + 1] then
			love.filesystem.write(images_name[selection + 1] .. ".lua", "return " .. love.serial.packPretty(images_data[selection + 1]))
		end
	end
	
	if key == "escape" then
		if love.filesystem.exists(images_name[selection + 1] .. ".lua") then
			images_data[selection + 1] = love.filesystem.load(images_name[selection + 1] .. ".lua")()
		else
			images_data[selection + 1] = {}
		end
	end
end

function love.mousepressed(x, y, button)
	curRect.x = math.floor(x / 16) * 16
	curRect.y = math.floor(y / 16) * 16
	curRect.width = 0
	curRect.height = 0
	drawRect = true
end

function love.mousereleased(x, y, button)
	drawRect = false
	table.insert(images_data[selection + 1], {"box", curRect.x, curRect.y, curRect.width, curRect.height})
end

function love.mousemoved(x, y, dx, dy)
	if drawRect then
		curRect.width = math.floor((love.mouse.getX() - curRect.x) / 16 + 0.5) * 16
		curRect.height = math.floor((love.mouse.getY() - curRect.y) / 16 + 0.5) * 16
	end
end