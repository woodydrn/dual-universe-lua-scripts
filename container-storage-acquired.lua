local items = container.getItemsList()
local decoded = json.decode(items)
local html = [[
<div class="bootstrap">
<h1 style="font-size: 4em;">Container Items</h1>
<table style="
	margin-top: 10px;
	margin-left: auto;
	margin-right: auto;
	width: 90%;
	font-size: 3em;
">
	<tr style="
		width: 100%;
		margin-bottom: 10px;
		background-color: blue;
		color: white;
	">
		<th>Name</th>
		<th>Volume</th>
	</tr>
]]
    
for k,v in pairs(decoded) do
	if (string.find(v.name, "Pure ") ~= 1 and string.find(v.name, "Nickel pure") ~= 1) then
		html = html .. [[
		<tr>
			<td>]]..v.name..[[</td>
			<td>]]..round(v.quantity,1)..[[KL</td>
		</tr>
		]]
	end
end

html = html .. "</table>"

containerScreen.setHTML(html)

