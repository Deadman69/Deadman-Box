AddCSLuaFile("shared.lua")
AddCSLuaFile( "deadman_box_config.lua" ) 
include("shared.lua") 
include( "deadman_box_config.lua" )

local entModel = DBOX.BoxModel
local maxItems = DBOX.MaxItemsInside
local timeBeforeEnter = DBOX.TimeBeforeEnter
local vectorToSpawn = DBOX.VectorToSpawn
local blacklistItems = DBOX.BlacklistItems
local blacklistModels = DBOX.BlacklistModels

function ENT:Initialize() 

	self:SetModel(entModel)

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType( SIMPLE_USE )
    local phys = self:GetPhysicsObject()
    phys:Wake()

end

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "ItemsInside" )
	self:NetworkVar( "Int", 1, "TimeUse" )
	self:NetworkVar( "Bool", 0, "Used" )
	self:NetworkVar( "String", 0, "Stored" )
	self:NetworkVar( "String", 1, "ModelStored" )

	self:SetItemsInside(0) -- Default Value
	self:SetTimeUse(0) -- Default Value
	self:SetUsed(false) -- Default Value
	self:SetStored("model") -- Default Value
	self:SetModelStored("model") -- Default Value
end

function ENT:StartTouch( ent )
	if ent:IsPlayer() then return end 

	if blacklistItems[ent:GetClass()] then return end -- Si il est dans la blacklist items on annule tout
	if blacklistModels[ent:GetModel()] then return end -- Si il est dans la blacklist models on annule tout
	if self:GetTimeUse() + timeBeforeEnter >= CurTime() then return end -- Si le temps est inférieur au temps nécéssaire on annule tout

	if not self:GetUsed() then -- Si il n'est pas utilisé
		if self:GetItemsInside() < maxItems then -- Si il n'est pas pleins
            if ent:GetClass() == "spawned_weapon" then -- Si c'est une arme
            	self:SetStored(ent:GetWeaponClass())
				self:SetModelStored("models/weapons/w_rif_ak47.mdl")
				ent:Remove()
			else -- Si c'est autre chose (un props, une entitée...)
				self:SetStored(ent:GetClass())
				self:SetModelStored(ent:GetModel())
            end
            self:SetUsed(true)
			self:SetItemsInside( self:GetItemsInside() + 1)
			ent:Remove()
		end
	else -- Si la boite est déjà utilisée
		if ent:GetClass() ~= self:GetStored() or ent:GetModel() ~= self:GetModelStored() then return end -- Si le classe/model de l'ent est différent du stored, on annule tout
		if self:GetItemsInside() < maxItems then
			self:SetItemsInside( self:GetItemsInside() + 1)
			ent:Remove()
		end
	end

end



function ENT:Use(activator, caller, usetype, value)

	if not activator:IsValid() or not activator:IsPlayer() or not activator:Alive() then return end

	if self:GetUsed() and self:GetItemsInside() > 0 then

		local ent = self:GetStored()
		local spawnit = ents.Create( ent )
		if ( !IsValid( spawnit ) ) then return end
		spawnit:SetModel( self:GetModelStored() )
		spawnit:SetPos( self:GetPos() + vectorToSpawn )
		spawnit:SetOwner(caller)
		spawnit:CPPISetOwner(caller)
		spawnit:PhysicsInit(SOLID_VPHYSICS)
		spawnit:SetMoveType(MOVETYPE_VPHYSICS)
		spawnit:SetSolid(SOLID_VPHYSICS)
		spawnit:SetUseType(SIMPLE_USE)
		spawnit:Spawn()
		spawnit:Activate()
		self:SetTimeUse(CurTime())
		self:SetItemsInside( self:GetItemsInside() - 1)

		if self:GetItemsInside() == 0 then
			self:SetUsed(false)
		end

    end

end
