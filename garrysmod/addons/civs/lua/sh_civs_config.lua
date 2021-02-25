--[[
==========================================Civs==================================================
-------------------------------------Legal Notices:---------------------------------------------
Civs is copyright © 2016 by Robert Blackmon; alias Bobbleheadbob.
Do not sell or distribute Civs without permission. That's not cool.
------------------------------------------------------------------------------------------------
CIVS DOWNLOAD: https://scriptfodder.com/scripts/view/2092
CONTACT ME: http://steamcommunity.com/id/bobblackmon/ | http://facepunch.com/member.php?u=438603
================================================================================================



Thank you for using Civs!

To install, place the 'civs' folder in your addons folder.

In order for Civs to actually walk around, you'll need to create a navmesh for your map.
Creating a navmesh MUST BE DONE IN SINGLEPLAYER. You can then transfer your nav file to your server.
Run sv_cheats 1 in the console, then spawn a Navmesh Editing SWEP from the spawnmenu and right click to get started.

If you're using one of the prepackaged navmeshes, please place it in GarrysModDS/garrysmod/maps/nav_mesh.nav

Please note:
THE NAVMESH MUST BE GENERATED IN A SINGLEPLAYER GAME.
THE NAVMESH MUST BE GENERATED IN A SINGLEPLAYER GAME.
THE NAVMESH MUST BE GENERATED IN A SINGLEPLAYER GAME.
THE NAVMESH MUST BE GENERATED IN A SINGLEPLAYER GAME.
(I receive about 2 support tickets a day because people don't read that lol)

Here's some important tips while creating your navmesh:

	Try to do all your navmesh editing in singleplayer, especially generating a new one.
	
	If your console says "No valid walkable seed positions.  Cannot generate Navigation Mesh." when generating a navmesh, walk to a place on the ground and run 'nav_mark_walkable' in the console, then try again.
	
	Set 'nav_split_place_on_ground 1' to create sloped nav areas.
	
	Use 'nav_begin_drag_selecting' and 'nav_end_drag_selecting' to select large groups of nav areas. Then use a one-click nav tool to take that action, such as the delete tool.
	
	Use the splice tool to easily correct misgenerated stairs. You can run 'nav_check_stairs' to update stair status without having to reload.
	
	The max navarea size is 76561198210920158 units. Make sure any nav areas you create are smaller than this.
	
	For your final save, set 'nav_quicksave 0' to make sure everything compiles correctly.
	
	If your map is downloaded from the steam workshop, you will have to extract it and put it in your maps folder with your nav file.
	
	For more info, see this page: https://developer.valvesoftware.com/wiki/Navigation_Meshes

]]

// This is your config file. When updating to a new version, make sure this file is not overwritten.
-- Ceci est votre fichier de configuration. Lorsque vous mettez à jour l'addon, faîtes attention à ce que ce fichier ne soit pas écrasé.

Civs.Health 			= 60	// How much health Civs spawn with.
								-- La santé des Civils lorqu'ils apparaissent.
Civs.BodyDisappear		= 60	// How long it takes dead Civ bodies to disappear.
								-- Le temps de disparition des corps des Civils

Civs.AlertDist			= 1200	// How far Civs can see illegal actions and freak out.
								-- La distance à laquelle un Civil peut voir des actions illégales et paniquer.
Civs.RequireLineOfSight	= true	// Whether Civs have to be able to directly see the illegal action before freaking out.
								-- Si les Civils doivent voir l'action illégal pour paniquer ou non.
Civs.ScaredTime			= 10	// How long Civs will spend crouched in fear.
								-- Le temps que les Civils restent accroupis.

Civs.WalkSpeed			= 80	// How fast Civs walk when not doing anything.
								-- La vitesse des Civils en marchant (décontracté)
Civs.RunSpeed			= 350	// How fast Civs run when scared.
								-- La vitesse des Civils qui court quand ils sont effrayés.
Civs.StepHeight			= 30 	// How high Civs can step up while walking. Player step size is 18 but we need a lot more or we'll get stuck.
								-- La hauteur que les civils peuvent atteindre en marchant. La Taille de pas d'un joueur est 18 mais il faut beaucoup plus où ils seront bloqués.

Civs.LoiterChance		= .20	// Percent chance that a Civ will stand still for a while after reaching their destination (1.00 is 100%; .50 is 50%; .00 is 0%)
								-- Pourcentage de chance qu'un Civil se tiendra tranquille pour un moment après avoir atteint sa destination(1.00 est 100%; .50 est 50%; .00 est 0%)
Civs.LoiterTime			= 5		// How long Civs will stand around and do nothing after reaching their destination.
								-- Le temps qu'un Civil se tiendra tranquille après avoir atteint sa destination.
Civs.WanderDist			= 20	// Max navareas the Civs will attempt to move when finding a new destination. 
								-- Max d'aires nav que les Civils tenteront de bouger lorsqu'ils ont trouvé une nouvelle destination

Civs.AutoPopulate		= true	// Whether to automatically spawn and remove Civs.
								-- Si les Civils apparaissent et disparaissent automatiquement.
Civs.SpawnInterval		= 25	// How often to spawn and remove Civs.
								-- A quel fréquence les Civils apparaissent et disparaissent. 
Civs.DespawnMode		= 2		// 1 = Despawn using PVS. 2 = Despawn using through line-of-sight. Some maps are incompatible with PVS. If your Civs aren't despawning, then switch to 2.
								-- 1 = Disparait en utlisant PVS. 2 = Disparait hors du champ de vision. Quelques maps sont incompatibles avec les PVS. Si vos Civils ne disparaissent pas, alors mettez 2.
Civs.SpawnDist			= 3000	// Max spawn distance from any given player.
								-- Max distance de spawn de n'importe quel joueur.
Civs.CivsPerPlayer		= 4		// Max Civs allowed to exist per online player.
								-- Max Civils autorisés à exister par joueurs en ligne.
Civs.MaxCivs			= 40	// Absolute max Civs allowed on the map at once.
								-- Max Absolu de Civils autorisés sur la map en même temps.
Civs.PlayerLimit		= -1	//Civs stop spawning at this number of players. -1 means they always spawn
								
Civs.OutsideOnly 		= true	// Whether to spawn Civs in outside areas only. (Skybox must be above their head.)
								-- Si les Civils spawn à l'exterieur des aires seulement. (La Skybox doit être au-dessus de leur tête.)

Civs.CanOpenDoors		= true	// Whether Civs will try to open doors. Buggy.
								-- Si les Civils vont essayer d'ouvrir les portes. Créer des Bugs.
Civs.CanOpenBrushes		= false	// Whether Civs can open brush-based doors, such as glass doors (anything with no door handle).
								-- Si les Civils peuvent ouvrir les portes brush-based, tels que les vitres(tout ce qui est sans poignets).
Civs.NoCollide			= false	// Whether Civs will collide with players, props, and each other. True can help keep them from getting stuck, at the cost of realism.
								-- Si les Civils rentreront en collisions avec les joueurs, props, et entre eux. True vont les aider à ne pas se bloquer, mais ce ne sera pas réaliste.

Civs.VehKillSpeed		= 400	// How fast a vehicle must be going to kill an NPC. One fourth this (or more) will harm the NPC. Less than 1/4 of this speed will have no effect.
								-- Si les Civils rentreront en collisions avec les joueurs, props, et entre eux. True vont les aider à ne pas se bloquer, mais ce ne sera pas réaliste.

Civs.CopsCanRob			= false	// Whether cops can rob Civs.
								-- Si les policiers peuvent voler les Civils.
Civs.CashMin			= 3		// Minimum cash in a Civ's wallet.
								-- Minimum d'argent dans la poche d'un Civil.
Civs.CashMax			= 10	// Maximum cash in a Civ's wallet.
								-- Maximum d'argent dans la poche d'un Civil.
Civs.KillRequired		= true	// Whether a Civ must be killed to drop its money.
								-- Si un Civil doit être tué pour récuperer son argent.
Civs.Toughness			= 30	// If not KillRequired, then how much damage (on average) a Civ must take before dropping its money.
								-- Si La mort du civ n'est pas obligatoire, quel est le dommage (en moyenne) un Civil doit prendre avant de jeter son argent.
Civs.TimeBetweenMugs	= 0		// Minimum time between mugging one Civ before another Civ will drop its money.
								-- Minimum de temps entre l'agression d'un Civil avant qu'un autre Civ jette son argent.

Civs.CallPolice			= true	// Whether Civs will call the police when they see something bad happen.
								-- Si les Civils vont appeler la police lorsqu'il voit une mauvaise chose arriver.
Civs.CallingLabel		= "Calling Police..."	// The label on the police call progress bar.
								-- Le texte sur la barre de progrès d'appel de police.
Civs.MakeWanted			= true	// Whether calling the police will automatically makethe player wanted.
								-- Si appeler la police va automatiquement mettre le joueur 'recherché'.
Civs.CallChance			= .15	// Percent chance that a scared Civ will call the police (1.00 is 100%; .50 is 50%; .00 is 0%)
								-- Pourcentage de chance qu'un Civil effrayé appellera la police (1.00 est 100%; .50 est 50%; .00 est 0%)
Civs.CallTime			= 10	// How long it takes to call the police.
								-- Le temps qu'il faut pour appeler la police.
Civs.DmgStopsCalls		= false	// Whether taking any amount of damage will cancel the police call.
								-- Si la prise de dommages annulera l'appel de police.
Civs.PoliceBeaconTime	= 60	// How long the police beacon lasts.
								-- Le temps que dure la balise de police.
Civs.ProgPersistTime 	= 2 	// How long the "calling..." progress bar lasts after success or interrupt.
								-- Le temps de la barre de progrès "calling..." dure après l'interruption ou le succès de cet appel.
Civs.ProgRequireLOS		= true	// Whether to only show the "calling..." progress bar if we can see the Civ who is making the call.
								-- Si il faut seulement montrer la barre de progrès "calling..." lorsqu'on peut voir le Civil qui effectue l'appel.
Civs.ProgBarColor		= Color(20,20,150)	// The color to make the "calling..." progress bar.
											-- La couleur pour faire la barre de progrès "calling...".
Civs.ProgInterruptColor	= Color(100,0,0)	// The color to make the "Interrupted!" progress bar.
											-- La couleur pour faire la barre de progrès "Interrupted!".
Civs.ProgSuccessColor	= Color(20,150,20)	// The color to make the "Success!" progress bar.
											-- La couleur pour faire la barre de progrès "Success!".
Civs.BeaconMaterial		= Material("icon16/exclamation.png", "unlitgeneric")	// The material to use for the Police Beacon
																				-- Le Material à utiliser pour la Balise de Police
Civs.AllowArrest 		= true		//Whether cops can arrest civs.

Civs.AllowMug			= false		//Whether Civs can be mugged by pressing E on them.
Civs.TimeBetweenMugs 	= 60		//How many seconds between player muggings of Civs.
Civs.MugWeapons = {					//Weapons which can be used to mug civs. Add your own below the last one.
	"weapon_ak472",
	"weapon_mp52",
	"weapon_p2282",
	"weapon_pumpshotgun2",
	"weapon_deagle2",
	"weapon_glock2",
	"weapon_m42",
	"weapon_mac102",
	"weapon_fiveseven2",
	"ls_sniper",
}
																				
// Change desc or time to modify the wanted message and how long it lasts.
// Civilians which witness a crime will report the one with the lowest severity.
// Probably don't try to add more items to this list; it won't do anything.
-- Changez le temps ou la description pour modifier le message Wanted et combien de temps cela dure.
-- Les Civils qui sont témoins d'un crime rapporteront celui avec la sévérité la plus basse.
-- N'essayez probablement pas d'ajouter plus d'articles à cette liste; il ne fera rien.
Civs.Wanted = {
	shoot = {severity = 3, desc = "Shooting a Weapon", time=60*1},
	hurt = {severity = 2, desc = "Harming a Civilian", time=60*2},
	murder = {severity = 1, desc = "Murdering a Civilian", time=60*4}
}

// This function is used by civilians to determine if a player is a cop.
--Cette fonction est utilisée par des civils pour déterminer si un joueur est un policier.
// Don't change it if you're running DarkRP.
--Ne le changez pas si vous exécutez DarkRP.
function Civs.IsCop(ply)
	if DarkRP then
		return ply:isCP() //This is the default DarkRP cop check.
		-- Verifie les policiers dans le DarkRP.
	elseif Civs.Gamemode == "terrortown" then
		return ply:GetRole() == ROLE_DETECTIVE //Detectives are cops.
		-- Les detectives sont des policiers.
	elseif Civs.Gamemode == "sandbox" then
		return false //Nobody is a cop.
					 -- Personne n'est policier
	end
	
	-- return ply:isCP() 				//This is the default DarkRP cop check. Verifie les policiers dans le DarkRP.
	-- return ply:Team() == TEAM_COP 	//only TEAM_COP is a cop. Seul TEAM_COP est policier.
	-- return true 						//everyone is cop. Tout le monde est policier.
	-- return false						//nobody is cop. Personne est policier.
end

// This function checks if a certain player, 'otherply' should see the "calling police" progress bar.
// 'attacker' is the person who committed the crime. 'otherply' is any player.
// This function is called once per player, with 'otherply' being the player in question.
-- Cette fonction vérifie si un certain joueur, 'otherply' doit voir la barre de progression "calling police".
-- 'attacker' est la personne qui a commis le crime. 'Otherply' est n'importe quel joueur.
-- Cette fonction est appelée une fois par joueur, avec 'otherply' étant le joueur en question.
function Civs.ShouldSeeCall(attacker, otherply)
	if Civs.Gamemode == "terrortown" then
		return attacker == otherply or (attacker:GetRole() == ROLE_TRAITOR and otherply:GetRole() == ROLE_TRAITOR)
	else
		return attacker == otherply
	end
	
end


--[[
	A list of all models to use, with accompanying animations.
	To get a list of animations for a model:
		1. Spawn a ragdoll of that model
		2. Look at it
		3. Run 'civs_animlist' in the console.
	If animations are broken IT'S THE MODEL'S FAULT; NOT THIS ADDON.
]]
--[[
Une liste de tous les modèles à utiliser, avec l'accompagnement d'animations.
 	Obtenir une liste d'animations pour un modèle:
 		1. Spawn un ragdoll de ce modèle.
 		2. Regardez-le.
 		3. Exécuté 'civs_animlist' dans la console.
 	Si les animations sont cassées c'est LA FAUTE du modèle; PAS CET ADDON.
]]
Civs.Models = {
	male = {
		{
			mdl = Model("models/Humans/Group01/Male_02.mdl"), 
			anims = {
				idle = "LineIdle03",
				run = "run_protected_all",
				hide = "crouchidlehide"
			}
		},
		{
			mdl=Model("models/Humans/Group01/Male_04.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_protected_all",
				hide = "crouchidlehide"
			}
		},
		{
			mdl=Model("models/Humans/Group01/Male_06.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_protected_all",
				hide = "crouchidlehide"
			}
		},
		{
			mdl=Model("models/Humans/Group01/Male_08.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_protected_all",
				hide = "crouchidlehide"
			}
		},
		{
			mdl=Model("models/Humans/Group02/male_01.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_protected_all",
				hide = "crouchidlehide"
			}
		},
		{
			mdl=Model("models/Humans/Group02/male_02.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_protected_all",
				hide = "crouchidlehide"
			}
		},
		{
			mdl=Model("models/Humans/Group02/male_03.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_protected_all",
				hide = "crouchidlehide"
			}
		},
		{
			mdl=Model("models/Humans/Group02/male_04.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_protected_all",
				hide = "crouchidlehide"
			}
		},
		{
			mdl=Model("models/Humans/Group02/male_05.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_protected_all",
				hide = "crouchidlehide"
			}
		},
		{
			mdl=Model("models/Humans/Group02/male_06.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_protected_all",
				hide = "crouchidlehide"
			}
		},
		{
			mdl=Model("models/Humans/Group02/male_07.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_protected_all",
				hide = "crouchidlehide"
			}
		},
	},
	
	female = {
		{
			mdl=Model("models/Humans/Group01/Female_01.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_panicked_2_all",
				hide = "crouch_panicked"
			}
		},
		{
			mdl=Model("models/Humans/Group01/Female_02.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_panicked_2_all",
				hide = "crouch_panicked"
			}
		},
		{
			mdl = Model("models/Humans/Group01/Female_03.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_panicked_2_all",
				hide = "crouch_panicked",
			}
		},
		{
			mdl = Model("models/Humans/Group01/Female_04.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_panicked_2_all",
				hide = "crouch_panicked",
			}
		},
		{
			mdl = Model("models/Humans/Group01/Female_07.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_panicked_2_all",
				hide = "crouch_panicked",
			}
		},
		{
			mdl = Model("models/Humans/Group02/Female_02.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_panicked_2_all",
				hide = "crouch_panicked",
			}
		},
		{
			mdl = Model("models/Humans/Group02/Female_03.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_panicked_2_all",
				hide = "crouch_panicked",
			}
		},
		{
			mdl = Model("models/Humans/Group02/Female_04.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_panicked_2_all",
				hide = "crouch_panicked",
			}
		},
		{
			mdl = Model("models/Humans/Group02/Female_06.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_panicked_2_all",
				hide = "crouch_panicked",
			}
		},
		{
			mdl = Model("models/Humans/Group02/Female_07.mdl"),
			anims = {
				idle = "LineIdle03",
				run = "run_panicked_2_all",
				hide = "crouch_panicked",
			}
		},
	}
}

hook.Add("Civ_TakeDamage", "Civs_Config_Default", function(civ, dmginfo)
	//Called serverside when a civ is hurt.
	--Utilisé en serverside quand un Civil est blessé
	
end)

hook.Add("Civ_Killed", "Civs_Config_Default", function(civ, dmginfo)
	//Called serverside when a civ is killed.
	--Utilisé en serverside quand un Civil est tué.
	
end)

hook.Add("Civ_DroppedMoney", "Civs_Config_Default", function(civ, attacker, money)
	// Called serverside when a Civ is about to drop its money.
	// Return false to prevent money from dropping.
	// Return a number to drop that amount of money instead.
	-- Utilisé en serverside quand un Civil va jeter de l'argent.
	-- Return false pour empêcher l'argent d'être jeter
	-- Retourne un nombre pour jeter cette somme d'argent.
	
	
end)

hook.Add("Civ_StartFreakingOut", "Civs_Config_Default", function(civ, pos, attacker, reason)
	// Called serverside when a Civ is about to freak out.
	// 'pos' is the position where the 'attacker' was spotted doing illegal activities.
	// 'reason' is a string, either "hurt", "shoot", or "murder". You can use this with Civs.Wanted
	// return false to prevent the freakout.
	-- Utilisé en serverside quand un Civil va paniquer.
	-- 'pos' est la position où l'attacker' a été pris en trian de faire des activitées illégales.
	-- 'reason' est une séquence de caractère , soit "hurt", "shoot", ou "murder". Vous pouvez utilisé ça avec Civs.Wanted
	-- return false pour empêcher la panique.
	
	
end)

hook.Add("Civ_PoliceCallInterrupted", "Civs_Config_Default", function(civ)
	// Called shared when a police call is interrupted.
	-- Utilisé en shared lorsqu'un appel vers la police est interrompu.
	
	
	
end)

hook.Add("Civ_PoliceBeaconCreated","Civs_Config_Default", function(civ, pos, attacker, reason)
	// Called shared when a police beacon is placed.
	// pos, attacker, and reason are only available clientside.
	-- Utilisé en shared lorsqu'une balise de police est placé.
	-- pos, attacker, et reason sont seulement disponibles clientside.
	
end)


//A list of sounds to play when a Civ gets scared or is calling the police.
-- Une liste de sons à jouer quand Un Civil a peur ou appelle la police.
Civs.AfraidSounds = {
	male = {
		Sound("vo/npc/male01/gethellout.wav"),
		Sound("vo/npc/male01/help01.wav"),
		Sound("vo/npc/male01/behindyou01.wav"),
		Sound("vo/npc/male01/behindyou02.wav"),
		Sound("vo/npc/male01/goodgod.wav"),
		Sound("vo/npc/male01/letsgo01.wav"),
		Sound("vo/npc/male01/letsgo02.wav"),
		Sound("vo/npc/male01/no01.wav"),
		Sound("vo/npc/male01/ohno.wav"),
		Sound("vo/npc/male01/runforyourlife01.wav"),
		Sound("vo/npc/male01/runforyourlife02.wav"),
		Sound("vo/npc/male01/runforyourlife03.wav"),
		Sound("vo/npc/male01/startle01.wav"),
		Sound("vo/npc/male01/startle02.wav"),
		Sound("vo/npc/male01/strider_run.wav"),
		Sound("vo/npc/male01/civilprotection01.wav"),
		Sound("vo/npc/male01/civilprotection02.wav"),
		Sound("vo/npc/male01/cps01.wav"),
		Sound("vo/npc/male01/cps02.wav"),
		Sound("vo/npc/male01/watchout.wav")
	},
	female = {
		Sound("vo/npc/female01/gethellout.wav"),
		Sound("vo/npc/female01/help01.wav"),
		Sound("vo/npc/female01/behindyou01.wav"),
		Sound("vo/npc/female01/behindyou02.wav"),
		Sound("vo/npc/female01/goodgod.wav"),
		Sound("vo/npc/female01/letsgo01.wav"),
		Sound("vo/npc/female01/letsgo02.wav"),
		Sound("vo/npc/female01/no01.wav"),
		Sound("vo/npc/female01/ohno.wav"),
		Sound("vo/npc/female01/runforyourlife01.wav"),
		Sound("vo/npc/female01/runforyourlife02.wav"),
		Sound("vo/npc/female01/startle01.wav"),
		Sound("vo/npc/female01/startle02.wav"),
		Sound("vo/npc/female01/strider_run.wav"),
		Sound("vo/npc/female01/civilprotection01.wav"),
		Sound("vo/npc/female01/civilprotection02.wav"),
		Sound("vo/npc/female01/cps01.wav"),
		Sound("vo/npc/female01/cps02.wav"),
		Sound("vo/npc/female01/watchout.wav")
	}
}

//A list of sounds to play when we bump into a player.
-- Une liste de sons à jouer lorsqu'on va dans un autre joueur
Civs.ExcuseMeSounds = {
	male = {
		Sound("vo/npc/male01/outofyourway02.wav"),
		Sound("vo/npc/male01/excuseme01.wav"),
		Sound("vo/npc/male01/excuseme02.wav"),
		Sound("vo/npc/male01/pardonme01.wav"),
		Sound("vo/npc/male01/pardonme02.wav"),
		Sound("vo/npc/male01/sorry01.wav"),
		Sound("vo/npc/male01/sorry02.wav"),
		Sound("vo/npc/male01/sorry03.wav"),
		Sound("vo/npc/male01/vquestion01.wav"),
		Sound("vo/npc/male01/uhoh.wav"),
		Sound("vo/npc/male01/watchwhat.wav")
	},
	female = {
		Sound("vo/npc/female01/outofyourway02.wav"),
		Sound("vo/npc/female01/excuseme01.wav"),
		Sound("vo/npc/female01/excuseme02.wav"),
		Sound("vo/npc/female01/pardonme01.wav"),
		Sound("vo/npc/female01/pardonme02.wav"),
		Sound("vo/npc/female01/sorry01.wav"),
		Sound("vo/npc/female01/sorry02.wav"),
		Sound("vo/npc/female01/sorry03.wav"),
		Sound("vo/npc/female01/vquestion01.wav"),
		-- Sound("vo/npc/female01/uhoh.wav"), //too freaked out.
		Sound("vo/npc/female01/watchwhat.wav")
	}
}

//A list of sounds to play when we take damage
-- Une liste de sons à jouer quand on prend des dommages
Civs.HurtSounds = {
	male = {
		Sound("vo/npc/male01/myarm01.wav"), 
		Sound("vo/npc/male01/myarm02.wav"),
		Sound("vo/npc/male01/myleg01.wav"),
		Sound("vo/npc/male01/myleg02.wav"),
		Sound("vo/npc/male01/mygut02.wav"),
		Sound("vo/npc/male01/ow01.wav"),
		Sound("vo/npc/male01/ow02.wav"),
		Sound("vo/npc/male01/pain01.wav"),
		Sound("vo/npc/male01/pain02.wav"),
		Sound("vo/npc/male01/pain03.wav"),
		Sound("vo/npc/male01/pain04.wav"),
		Sound("vo/npc/male01/pain05.wav"),
		Sound("vo/npc/male01/pain06.wav"),
		Sound("vo/npc/male01/pain07.wav"),
		Sound("vo/npc/male01/pain08.wav"),
		Sound("vo/npc/male01/pain09.wav"),
		Sound("vo/npc/male01/gordead_ans06.wav"),
		Sound("vo/npc/male01/no02.wav")
	},
	female = {
		Sound("vo/npc/female01/myarm01.wav"), 
		Sound("vo/npc/female01/myarm02.wav"),
		Sound("vo/npc/female01/myleg01.wav"),
		Sound("vo/npc/female01/myleg02.wav"),
		Sound("vo/npc/female01/mygut02.wav"),
		Sound("vo/npc/female01/ow01.wav"),
		Sound("vo/npc/female01/ow02.wav"),
		Sound("vo/npc/female01/pain01.wav"),
		Sound("vo/npc/female01/pain02.wav"),
		Sound("vo/npc/female01/pain03.wav"),
		Sound("vo/npc/female01/pain04.wav"),
		Sound("vo/npc/female01/pain05.wav"),
		Sound("vo/npc/female01/pain06.wav"),
		Sound("vo/npc/female01/pain07.wav"),
		Sound("vo/npc/female01/pain08.wav"),
		Sound("vo/npc/female01/pain09.wav"),
		Sound("vo/npc/female01/gordead_ans06.wav"),
		Sound("vo/npc/female01/no02.wav")
	}
}

//A list of sounds to play when another player/npc dies nearby.
-- Une liste de sons à jouer quand un autre joueur/npc meurt à coté
Civs.OtherDieSounds = {
	male = {
		Sound("vo/npc/male01/strider_run.wav"),
		Sound("vo/npc/male01/gordead_ques01.wav"),
		Sound("vo/npc/male01/gordead_ques02.wav"),
		Sound("vo/npc/male01/gordead_ques06.wav"),
		Sound("vo/npc/male01/gordead_ques07.wav"),
		Sound("vo/npc/male01/gordead_ques14.wav"),
		Sound("vo/npc/male01/gordead_ques10.wav"),
		Sound("vo/npc/male01/ohno.wav"),
		Sound("vo/npc/male01/no01.wav"),
		Sound("vo/npc/male01/goodgod.wav"),
		Sound("vo/npc/male01/help01.wav"),
	},
	female = {
		Sound("vo/npc/female01/strider_run.wav"),
		Sound("vo/npc/female01/gordead_ques01.wav"),
		Sound("vo/npc/female01/gordead_ques02.wav"),
		Sound("vo/npc/female01/gordead_ques06.wav"),
		Sound("vo/npc/female01/gordead_ques07.wav"),
		Sound("vo/npc/female01/gordead_ques14.wav"),
		Sound("vo/npc/female01/gordead_ques10.wav"),
		Sound("vo/npc/female01/no01.wav"),
		Sound("vo/npc/female01/goodgod.wav"),
		Sound("vo/npc/female01/help01.wav"),
	}
}


// This will come in a future update. Leave it commented for now.
-- Ceci viendra dans une prochaine mise à jour. Laissez la commentée pour l'instant.

-- Civs.HurtSounds = {
	-- male = {
		-- arm = { 
			-- Sound("vo/npc/male01/myarm01.wav"), 
			-- Sound("vo/npc/male01/myarm02.wav")
		-- },
		-- leg = {
			-- Sound("vo/npc/male01/myleg01.wav"),
			-- Sound("vo/npc/male01/myleg02.wav") 
		-- },
		-- gut = {
			-- Sound("vo/npc/male01/mygut02.wav") 
		-- },
		-- other = { 
			-- Sound("vo/npc/male01/ow01.wav"),
			-- Sound("vo/npc/male01/ow02.wav"),
			-- Sound("vo/npc/male01/pain01.wav"),
			-- Sound("vo/npc/male01/pain02.wav"),
			-- Sound("vo/npc/male01/pain03.wav"),
			-- Sound("vo/npc/male01/pain04.wav"),
			-- Sound("vo/npc/male01/pain05.wav"),
			-- Sound("vo/npc/male01/pain06.wav"),
			-- Sound("vo/npc/male01/pain07.wav"),
			-- Sound("vo/npc/male01/pain08.wav"),
			-- Sound("vo/npc/male01/pain09.wav"),
			-- Sound("vo/npc/male01/gordead_ans06.wav"),
			-- Sound("vo/npc/male01/no02.wav")
		-- }
	-- },
	-- female = {
		-- arm = { 
			-- Sound("vo/npc/female01/myarm01.wav"), 
			-- Sound("vo/npc/female01/myarm02.wav")
		-- },
		-- leg = {
			-- Sound("vo/npc/female01/myleg01.wav"),
			-- Sound("vo/npc/female01/myleg02.wav") 
		-- },
		-- gut = {
			-- Sound("vo/npc/female01/mygut02.wav")
		-- },
		-- {{ user_id | 76561198006484623}}
		-- other = {
			-- Sound("vo/npc/female01/ow01.wav"),
			-- Sound("vo/npc/female01/ow02.wav"),
			-- Sound("vo/npc/female01/pain01.wav"),
			-- Sound("vo/npc/female01/pain02.wav"),
			-- Sound("vo/npc/female01/pain03.wav"),
			-- Sound("vo/npc/female01/pain04.wav"),
			-- Sound("vo/npc/female01/pain05.wav"),
			-- Sound("vo/npc/female01/pain06.wav"),
			-- Sound("vo/npc/female01/pain07.wav"),
			-- Sound("vo/npc/female01/pain08.wav"),
			-- Sound("vo/npc/female01/pain09.wav"),
			-- Sound("vo/npc/female01/gordead_ans06.wav"),
			-- Sound("vo/npc/female01/no02.wav")
		-- }
	-- }
-- }