
local function IsDST()
	return TheSim:GetGameID() == "DST"
end
local function Init(Sim)
	local assets=
	{
		Asset("ANIM", "anim/st_preserve.zip"),
		Asset("ATLAS", "images/inventoryimages/st_preserve.xml"),
		Asset("IMAGE", "images/inventoryimages/st_preserve.tex"),
	}
	local function onfinished(inst)
		inst:Remove()
	end
	local function fn(Sim)
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		if IsDST() then
			inst.entity:AddNetwork()
		end
		MakeInventoryPhysics(inst)
    
    
		inst.AnimState:SetBank("st_preserve")
		inst.AnimState:SetBuild("st_preserve")
		inst.AnimState:PlayAnimation("idle")
		
		if IsDST() then
			inst.entity:SetPristine()
		
			if not TheWorld.ismastersim then
				return inst
			end
		end
		

		inst:AddComponent("edible")
		inst.components.edible.foodtype = "ELEMENTAL"
		inst.components.edible.hungervalue = 2
		inst:AddComponent("tradable")
    
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    
		inst:AddComponent("inspectable")
    
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = "st_preserve"
		inst.components.inventoryitem.atlasname = "images/inventoryimages/st_preserve.xml"

		inst:AddComponent("repairer")


		inst.components.repairer.repairmaterial = "st_preserve"
		if IsDST() then
			inst.components.repairer.perishrepairpercent = TUNING.ST_PRESERVE.PRESERVATIVE.REPAIR_VALUE
		else
			inst.components.repairer.perishrepairvalue = TUNING.ST_PRESERVE.PRESERVATIVE.REPAIR_VALUE
		end
		
		return inst
	end

	return Prefab( "common/inventory/st_preserve", fn, assets) 

end

return Init(Sim)