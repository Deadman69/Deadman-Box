AddCSLuaFile("cl_init.lua") -- DONT TOUCH IT
AddCSLuaFile("shared.lua") -- DONT TOUCH IT
include("shared.lua") -- DONT TOUCH IT

function ENT:Initialize() -- DONT TOUCH IT


-- START OF USER CONFIG DONT TOUCH UPPER THESES LINES
-- START OF USER CONFIG DONT TOUCH UPPER THESES LINES
-- START OF USER CONFIG DONT TOUCH UPPER THESES LINES
-- START OF USER CONFIG DONT TOUCH UPPER THESES LINES
-- START OF USER CONFIG DONT TOUCH UPPER THESES LINES
-- START OF USER CONFIG DONT TOUCH UPPER THESES LINES
-- START OF USER CONFIG DONT TOUCH UPPER THESES LINES

	self:SetModel("models/props_junk/wood_crate001a.mdl") -- Model of the box
    self.maxitems = 3 -- Max items inside this entity
    self.timebeforereenter = 3 -- Seconds before an item wich has been pulled out can be put in the box
    self.vectortospawn = Vector( 0, 0, 30 ) -- The position the items will spawn (relative to the box)
    self.blacklistitems = { -- Items that will never be in the box
    	"deadman_box_box", -- Strongly recommended to let it
    	"deadman_box_helper", -- Strongly recommended to let it

    	"npc_crow",
    	"npc_seagull",
    	"npc_pigeon",
    }

    self.blacklistmodels = { -- Models that will never be in the box
    	"models/genius/incredible/wouhaou/model.mdl",
    	"models/props/blabla.mdl"
    }


-- END OF USER CONFIG DONT TOUCH BELOW THESES LINES
-- END OF USER CONFIG DONT TOUCH BELOW THESES LINES
-- END OF USER CONFIG DONT TOUCH BELOW THESES LINES
-- END OF USER CONFIG DONT TOUCH BELOW THESES LINES
-- END OF USER CONFIG DONT TOUCH BELOW THESES LINES
-- END OF USER CONFIG DONT TOUCH BELOW THESES LINES
-- END OF USER CONFIG DONT TOUCH BELOW THESES LINES

    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType( SIMPLE_USE )
    local phys = self:GetPhysicsObject()
    phys:Wake()



    self.itemsinside = 0 -- Don't touch it
    self.timeuse = 0 -- Don't touch it
    self.used = false -- Don't touch it
    self.stored = nil -- Don't touch it
    self.model = nil -- Don't touch it

end

function ENT:StartTouch( ent )

	if table.HasValue( self.blacklistitems, ent:GetClass() ) then return end -- Si il est dans la blacklist items on annule tout
	if table.HasValue( self.blacklistmodels, ent:GetModel() ) then return end -- Si il est dans la blacklist models on annule tout
	if self.timeuse + self.timebeforereenter >= CurTime() then return end -- Si le temps est inférieur au temps nécéssaire on annule tout

	if not self.used then -- Si il n'est pas utilisé
		if self.itemsinside <= self.maxitems then -- Si il n'est pas pleins
            if ent:GetClass() == "spawned_weapon" then -- Si c'est une arme
            	self.stored = ent:GetWeaponClass()
				self.used = true
				self.itemsinside = self.itemsinside + 1
				self.model = "models/weapons/w_rif_ak47.mdl"
				ent:Remove()
			else -- Si c'est autre chose (un props, une entitée...)
				self.stored = ent:GetClass()
				self.used = true
				self.itemsinside = self.itemsinside + 1
				self.model = ent:GetModel()
				ent:Remove()
            end
		end
	else -- Si la boite est déjà utilisée
		if ent:GetClass() ~= self.stored or ent:GetModel() ~= self.model then return end -- Si le classe/model de l'ent est différent du stored, on annule tout
		if self.itemsinside <= self.maxitems then
			self.itemsinside = self.itemsinside + 1
			ent:Remove()
		end
	end

end



function ENT:Use(activator, caller, usetype, value)

	if not activator:IsPlayer() or not activator:Alive() or not activator:IsValid() then return end

	if self.used and self.itemsinside > 0 then

		local ent = self.stored
		local spawnit = ents.Create( ent )
			if ( !IsValid( spawnit ) ) then return end
			spawnit:SetModel( self.model )
			spawnit:SetPos( self:GetPos() + self.vectortospawn )
			spawnit:SetOwner(activator)
			spawnit:Spawn()
		self.timeuse = CurTime()
		self.itemsinside = self.itemsinside - 1

		if self.itemsinside == 0 then
			self.used = false
		end

    end

end