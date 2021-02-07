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
schematics = {
    bauxit = 1199082577;
    petalite = 214807072;
    purite = 547899423;
    garnierite = 1085756222;
    quartz = 1678829760;
    limestone = 1358793857;
    chromite = 67742786;
    natron = 1843262763;
    hematite = 1833008839;
    
}
changeButtons = {}
clickableAreas = {}
changeContentId = 0
shouldUpdate = { update = false, endtime = system.getTime() }

function updateIn(time)
    local duration = system.getTime() + time
    shouldUpdate = { update = true, endtime = duration }
end

function startRefiner(refiner)
	refiner.start()
	updateIn(1)
end

function stopRefiner(refiner)
	refiner.softStop()
	updateIn(1)
end

function showSchematics(refiner)
	local html = "";
	local buttonTop = 0.15
	local buttonLeft = 0.2
	local counter = 1

	for schematicName, schematicId in pairs(schematics) do
		local parameter = { refiner = refiner, schematic = schematicId }
		local changeButton = createButton(buttonLeft, buttonTop, 0.20, 0.07, schematicName, "green", 3, changeSchematic, parameter)

		counter = counter + 1
		buttonLeft = buttonLeft + 0.22
		if counter % 3 == 1 then
                buttonLeft = 0.2;
                buttonTop = buttonTop + 0.1
		end
	end
end

function changeSchematic(parameters)
	local refiner = parameters.refiner
	local id = parameters.schematic

	refiner.setCurrentSchematic(id)
    
	for i, id in pairs(changeButtons) do
		screen.deleteContent(id)
     end
    
	updateIn(1)
end

function createButton(x, y, hx, hy, text, color, fontsize, fun, parameter)
	button = "<div class='bootstrap' style='background:"..color..";width:"..(hx*100).."vw;height:"..(hy*100).."vh;overflow:hidden;padding-top:"..(((hy*100)/2)-1.2).."vh;font-size:"..fontsize.."vh; position:fixed; left: "..(x*100).."vw; top:"..(y*100).."vh;'>" .. text .. "</div>"
	id = screen.addContent(x * 100,y * 100, button)
    
	if parameter and parameter.schematic ~= nil then table.insert(changeButtons, id) end

	local area = {id = id, x = x, y = y, hx = hx, hy = hy, fun = fun, parameter = parameter }
	clickableAreas[id] = area

	return button
end


function updateScreen()
	local refinerHTML = ""
	local buttonTop = 0.35
    
	clickableAreas = {}

	for i, refiner in pairs(refiners) do
		local status = refiner.getStatus()

		if status == "RUNNING" then status = "<span style=\"color:green\">Running</span>"
		else status = "<span style=\"color:red\">" .. status .. "</span>"
		end

		local schematicId = refiner.getCurrentSchematic()
		local schematicInfo = json.decode(core.getSchematicInfo(schematicId))
		local schematicName = schematicInfo["ingredients"][1]["name"]
        
		local stopButton = createButton(0.78, buttonTop, 0.05, 0.045, "stop", "red", 2, stopRefiner, refiner)
		local changeButton = createButton(0.84, buttonTop, 0.05, 0.045, "change", "blue", 2, showSchematics, refiner)
		local startButton = createButton(0.9, buttonTop, 0.05, 0.045, "start", "green", 2, startRefiner, refiner)

		buttonTop = buttonTop + 0.062

		refinerHTML = refinerHTML .. [[
<tr>
	<td>]]..refinerNames[i]..[[</td>
	<td>]]..schematicName..[[</td>
	<td>]]..status..[[</td>
	<td>]]..stopButton..changeButton..startButton..[[</td>
</tr>]]
	end

	html = [[
<div class="bootstrap">]] .. createButton(0.8, 0.1, 0.1, 0.06, "refresh", "blue", 2, updateScreen, false)..[[
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
