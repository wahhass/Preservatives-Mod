local function IsDST()
	return GLOBAL.TheSim:GetGameID() == "DST"
end
	local assets=
	{
		Asset("ANIM", "anim/ST_PRESERVE.zip"),
		Asset("ATLAS", "images/inventoryimages/ST_PRESERVE.xml"),
		Asset("IMAGE", "images/inventoryimages/ST_PRESERVE.tex"),
		
	}
PrefabFiles = {
	"ST_PRESERVE",
	}

GLOBAL.TUNING.ST_PRESERVE = {
		PRESERVATIVE =	{ 
								CRAFTING_AMOUNT = GetModConfigData("craftingamount"),
								REPAIR_VALUE = GetModConfigData("repairvalue"),
						},
		CRAFTING =		{
								WOOL_AMOUNT_SUMMER = 6,
						},
}
if GLOBAL.rawget(GLOBAL, "MATERIALS") then
	GLOBAL.MATERIALS["ST_PRESERVE"] = "ST_PRESERVE"
end

local preservativeAtlas = "images/inventoryimages/ST_PRESERVE.xml"
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH
local require = GLOBAL.require
require "recipe"
require "tuning"
require "st_preserve_locale"

local function OnRepaired(inst)
	if inst.components.perishable then
		inst:PushEvent("perishchange", {percent = inst.components.perishable:GetPercent()})
	end
end
local function AddPreservativesToFood(inst)

	if inst.components.edible and inst.components.perishable and not inst.components.repairable then

		inst:AddComponent("repairable")
		inst.components.repairable.repairmaterial = "ST_PRESERVE"
		inst.components.repairable.announcecanfix = true
		inst.components.repairable.onrepaired = OnRepaired

		if GetModConfigData("stackawarerepairvalue") then
			local repair = inst.components.repairable.Repair
			inst.components.repairable.Repair = function(self, doer, repair_item)
													local repairValue = 0
													if IsDST() then
														repairValue = repair_item.components.repairer.perishrepairpercent
													else
														repairValue = repair_item.components.repairer.perishrepairvalue
													end
													if self.inst.components.stackable and self.inst.components.stackable:StackSize() > 1 then
														if IsDST() then
															repair_item.components.repairer.perishrepairpercent = string.format("%.4f",repair_item.components.repairer.perishrepairpercent/self.inst.components.stackable:StackSize())+0
														else
															repair_item.components.repairer.perishrepairvalue = string.format("%.4f",repair_item.components.repairer.perishrepairvalue/self.inst.components.stackable:StackSize())+0
														end
													end
													local result = repair(self, doer, repair_item)
													if IsDST() then
														repair_item.components.repairer.perishrepairpercent = repairValue
													else
														repair_item.components.repairer.perishrepairvalue = repairValue
													end
													
													return result
												end
		end

	end

end

local function TryAddRecipe(condition, recipeFactory)
	if condition then
		recipeFactory()
	end
end

local function AddPreservativeRecipe()
		Recipe("ST_PRESERVE", {Ingredient("nitre", 1)}, RECIPETABS.FARM,  TECH.SCIENCE_ONE,nil,nil,nil,TUNING.ST_PRESERVE.PRESERVATIVE.CRAFTING_AMOUNT).atlas =  preservativeAtlas
end
local function AddBeefaloWoolRecipe()
	 local preservativeIngredient = Ingredient("ST_PRESERVE", 4)
	 preservativeIngredient.atlas =  preservativeAtlas

	Recipe("beefalowool", {preservativeIngredient,Ingredient("trunk_summer", 1)}, RECIPETABS.REFINE,  TECH.SCIENCE_ONE,nil,nil,nil,TUNING.ST_PRESERVE.CRAFTING.WOOL_AMOUNT_SUMMER)

	 
end
local function AddBeefaloWoolRecipeCapy()
	 local preservativeIngredient = Ingredient("ST_PRESERVE", 4)
	 preservativeIngredient.atlas =  preservativeAtlas

	Recipe("beefalowool", {preservativeIngredient,Ingredient("trunk_summer", 1)}, RECIPETABS.REFINE,  TECH.SCIENCE_ONE,GLOBAL.RECIPE_GAME_TYPE.COMMON,nil,nil,nil,TUNING.ST_PRESERVE.CRAFTING.WOOL_AMOUNT_SUMMER)

	 
end
local function AddPreservativeRecipeCapy()
		Recipe("ST_PRESERVE", {Ingredient("nitre", 1)}, RECIPETABS.FARM,  TECH.SCIENCE_ONE,GLOBAL.RECIPE_GAME_TYPE.COMMON,nil,nil,nil,TUNING.ST_PRESERVE.PRESERVATIVE.CRAFTING_AMOUNT).atlas =  preservativeAtlas
end
local function AddRecipes()
	if not IsDST() and GLOBAL.IsDLCEnabled(GLOBAL.CAPY_DLC) then
			 AddPreservativeRecipeCapy()
			TryAddRecipe(GetModConfigData("craftwoolenabled"), AddBeefaloWoolRecipeCapy)
	else
	
	 AddPreservativeRecipe()
	 TryAddRecipe(GetModConfigData("craftwoolenabled"), AddBeefaloWoolRecipe)
	end
end

local function SetupPreservables()
	AddRecipes()
end

return SetupPreservables(), AddPrefabPostInitAny(AddPreservativesToFood)