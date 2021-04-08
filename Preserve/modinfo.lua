name = "Preserve"
description = "Adds some preservatives to your food into the game!"
author = "animetheme"

icon_atlas = "mod_icon.xml"
icon = "mod_icon.tex"
-- max stack size changed to 40
-- preservatives per nitre changed to 40,20,10,1

forumthread="n/a"
version = "0.4.1.1"
standalone = false
restart_required = false

api_version = 6
dst_api_version = 10

dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true
dst_compatible = true

all_clients_require_mod = true
client_only_mod = false

configuration_options =
{
    {
        name = "craftingamount",
        label = "Preservatives per nitre",
        options = 
        {
            {description = "1 for 1", data = 1}, 
            {description = "10 for 1", data = 10},
			{description = "20 for 1", data = 20},
			{description = "40 for 1", data = 30}
        }, 
        default = 20,
    },
    {
        name = "repairvalue", 
        label = "Repair value",
        options = 
        {
            {description = "Low", data = 0.1}, 
            {description = "Medium", data = 0.33}, 
            {description = "High", data = 0.5},
			{description = "Full", data = 1}
        },
        default = 0.33,
    },
	{
        name = "stackawarerepairvalue", 
        label = "Stackaware repair value",
        options = 
        {
            {description = "Disabled", data = false}, 
            {description = "Enabled", data = true},
        }, 
        default = true,
    },
    {
	    name = "craftwoolenabled",
        label = "Beefalo Woll Recipe",
        options = 
        {
            {description = "Disabled", data = false}, 
            {description = "Enabled", data = true},
        }, 
        default = true,
    },
}