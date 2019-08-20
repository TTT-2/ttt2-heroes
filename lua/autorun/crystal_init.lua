if SERVER then
	AddCSLuaFile()

	AddCSLuaFile("crystal/sh_init.lua")
	AddCSLuaFile("crystal/cl_init.lua")

	AddCSLuaFile("crystal/client/cl_menu.lua")

	resource.AddFile("materials/vgui/ttt/icon_diamond.vmt")
end

include("crystal/sh_init.lua")

if SERVER then
	include("crystal/init.lua")
else
	include("crystal/cl_init.lua")
end
