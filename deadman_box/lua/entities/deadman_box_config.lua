DBOX = {} -- Don't touch it


DBOX.BlacklistItems = { -- Items that will never be in the box, to know it, open your props menu and right click on an item and then "Copy to clipboard"
    	["deadman_box_box"] = true, -- Strongly recommended to let it
    	["deadman_box_helper"] = true, -- Strongly recommended to let it

    	["npc_crow"] = true,
    	["npc_seagull"] = true,
    	["npc_pigeon"] = true,
}

DBOX.BlacklistModels = { -- Models that will never be in the box
    	["models/genius/incredible/wouhaou/model.mdl"] = true,
    	["models/props/blabla.mdl"] = true,
}

DBOX.BoxModel = "models/props_junk/wood_crate001a.mdl" -- The model of the Box

DBOX.MaxItemsInside = 3 -- Max items in the box (the same item)
DBOX.TimeBeforeEnter = 3 -- Timer, if set to '3', an item pulled out can't be stored before the timer is ended

DBOX.VectorToSpawn = Vector(0, 0, 30) -- Position where the item will spawn when pulled out
