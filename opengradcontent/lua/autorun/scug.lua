player_manager.AddValidModel( "Slugcat", "models/crusader/rainworld/scug.mdl" )
list.Set( "PlayerOptionsModel", "Slugcat", "models/crusader/rainworld/scug.mdl" )
player_manager.AddValidHands( "Slugcat", "models/crusader/rainworld/arms/scug_arms.mdl", 0, "0000000", "True" )

player_manager.AddValidModel( "Slugcat Artificer", "models/crusader/rainworld/scugARTI.mdl" )
list.Set( "PlayerOptionsModel", "Slugcat Artificer", "models/crusader/rainworld/scugARTI.mdl" )
player_manager.AddValidHands( "Slugcat Artificer", "models/crusader/rainworld/arms/scug_arms.mdl", 0, "0000000", "True" )

player_manager.AddValidModel( "Slugcat Gourmand", "models/crusader/rainworld/scugGORM.mdl" )
list.Set( "PlayerOptionsModel", "Slugcat Gourmand", "models/crusader/rainworld/scugGORM.mdl" )
player_manager.AddValidHands( "Slugcat Gourmand", "models/crusader/rainworld/arms/scug_arms.mdl", 0, "0000000", "True" )

player_manager.AddValidModel( "Slugcat Rivulet", "models/crusader/rainworld/scugRiv.mdl" )
list.Set( "PlayerOptionsModel", "Slugcat Rivulet", "models/crusader/rainworld/scugRiv.mdl" )
player_manager.AddValidHands( "Slugcat Rivulet", "models/crusader/rainworld/arms/scug_arms.mdl", 0, "0000000", "True" )

player_manager.AddValidModel( "Slugcat Saint", "models/crusader/rainworld/scugSaint.mdl" )
list.Set( "PlayerOptionsModel", "Slugcat Saint", "models/crusader/rainworld/scugSaint.mdl" )
player_manager.AddValidHands( "Slugcat Saint", "models/crusader/rainworld/arms/scug_arms.mdl", 0, "0000000", "True" )

local Category = "Rainworld"


local NPC = 
{
    Name = "Slugcat",
    Class = "npc_scug_f",
	Health = "100",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )



local NPC = 
{
    Name = "Slugcat Dumb",
	Class = "npc_scug_h",
	Health = "100",
	Category = Category
}
list.Set( "NPC", NPC.Class, NPC )