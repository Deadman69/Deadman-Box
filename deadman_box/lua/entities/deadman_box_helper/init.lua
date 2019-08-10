--[[---------------------------------------------------------------------------
This is an example of a custom entity.
---------------------------------------------------------------------------]]
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_c17/oildrum001.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType( SIMPLE_USE )
    local phys = self:GetPhysicsObject()
    phys:Wake()

    self.class = nil
    self.model = nil

end

function ENT:StartTouch( ent )

	self.class = ent:GetClass()
	self.model = ent:GetModel()

end



function ENT:Use(activator, caller, usetype, value)

	if activator:IsPlayer() and activator:Alive() and activator:IsValid() then
		
		activator:ChatPrint("Class of the thing: "..self.class)
		activator:ChatPrint("Model of the thing: "..self.model)

    end

end