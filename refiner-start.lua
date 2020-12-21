function oreStatus(percent, invert)
	if invert == 0 then
		if percent <= 25 then return "<th style=\"color: red;\">LOW</th>"
		elseif percent > 25 and percent < 50 then return "<th style=\"color: orange;\">LOW</th>"
		else return "<th style=\"color: green;\">GOOD</th>"
		end 
	else
		if percent <= 25 then return "<th style=\"color: green;\">GOOD</th>"
		elseif percent > 25 and percent < 75 then return "<th style=\"color: orange;\">OK</th>"
		else return "<th style=\"color: red;\">HIGH</th>"
		end 
	end
end

refiners = {refinerL1, refinerL2, refinerL3, refinerL4, refinerR1, refinerR2, refinerR3, refinerR4}
refinerNames = {"L1", "L2", "L3", "L4", "R1", "R2", "R3", "R4"}
clickableAreas = {}

function startRefiner(refiner)
    system.print("starting refiner")
    refiner.start()
    updateScreen()
end

function stopRefiner(refiner)
    system.print("stopping refiner")
    refiner.softStop()
    updateScreen()
end

function createButton(x, y, hx, hy, text, color, fun, refiner)
	button = "<div class='bootstrap' style='background:"..color..";width:5vw;height:4.5vh;overflow:hidden;font-size:2vh; position:fixed; left: "..(x*100).."vw; top:"..(y*100).."vh;'>" .. text .. "</div>"
	id = screen.addContent(x * 100,y * 100, button)

	local area = {id = id, x = x, y = y, hx = hx, hy = hy, fun = fun, refiner = refiner }
	clickableAreas[id] = area

	return button
end


function updateScreen()
	local refinerHTML = ""
	local buttonTop = 0.35
    
	clickableAreas = {}

	for i,refiner in pairs(refiners) do
		local status = refiner.getStatus()

		if status == "RUNNING" then status = "<span style=\"color:green\">Running</span>"
		else status = "<span style=\"color:red\">" .. status .. "</span>"
		end

		local schematicId = refiner.getCurrentSchematic()
		local schematicInfo = json.decode(core.getSchematicInfo(schematicId))
		local schematicName = schematicInfo["ingredients"][1]["name"]
        
		local stopButton = createButton(0.81, buttonTop, 0.048, 0.042, "stop", "red", stopRefiner, refiner)
		local startButton = createButton(0.9, buttonTop, 0.048, 0.042, "start", "green", startRefiner, refiner)
        
		buttonTop = buttonTop + 0.062

		refinerHTML = refinerHTML .. [[
<tr>
	<td>]]..refinerNames[i]..[[</td>
	<td>]]..schematicName..[[</td>
	<td>]]..status..[[</td>
	<td>]]..stopButton..startButton..[[</td>
</tr>]]
end

	html = [[
<div class="bootstrap">
<h1 style="font-size: 4em;">Refiner Status</h1>
<table 
style="
	margin-top: 10px;
	margin-left: auto;
	margin-right: auto;
	width: 90%;
	font-size: 3em;
">
	</br>
	<tr style="
		width: 100%;
		margin-bottom: 10px;
		background-color: blue;
		color: white;
	">
		<th>Name</th>
		<th>Schematic</th>
		<th>Status</th>
		<th>Action</th>
	</tr>
	]]..refinerHTML..[[
</table>
</div>
]]
    
	screen.setHTML(html)
end

screen.clear()
updateScreen()

