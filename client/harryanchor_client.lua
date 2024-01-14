--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--
--*--------------------------------- HARRY BOAT ATTACH BY HARRY "AZRADEVOPS" -----------------------------------*--
--*																												*--
--*																												*--
--*-- FR --																										*--
--*   v 1.0.0 du 29/03/2021 (pour les différentes étapes du dev, lisez le fichier README_DEV.md)				*--
--*   > Ajout de la fonction ANCRE à tous les bateaux															*--
--*   			> Cela permets de lancer l'ancre et de figer le bateau											*--
--*					- Attention il ne faut pas dépasser les 20Kmh pour pouvoir le faire 						*--
--*   v 2.0.0 du 14/01/2024 																					*--
--*   > Remplacement de la native pour une ancre plus réalite													*--
--*																												*--
--*   Tous commentaires ou aides sont les bienvenus, allez sur  https://github.com/AzraDevOps/Harryattach		*--
--*																												*--
--*																												*--
--*-- EN --																										*--
--*   v 1.0.0 of 29/03/2021 (for the roadmap dev read README_DEV.md)											*--
--*   > Add anchor function for all boats																		*--
--*   			> Throw anchor and fix the boat																	*--
--*					- Be careful of your speed, you must be under 20Kmh to throw the anchor						*--
--*   v 2.0.0 du 14/01/2024 																					*--
--*   > Replace the native instruction for a more realistic anchor  											*--
--*																												*--
--*   All comments or help welcome , go on  https://github.com/AzraDevOps/Harryattach	  						*--
--*																												*--
--*																												*--
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--



--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--
--*	DECLARATIONS VARIABLES & CONFIG & ESX FRAMEWORK	    *--
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--

ESX = nil
ESX = exports['es_extended']:getSharedObject()

-- [FR] Definition des touches pour jeter et remonter l'ancre
-- [EN] Definition for throw and takeback the anchor
ToucheAncre = 58 		-- Touche "G" / Keyboard "G"
TexteAncre = "G"		-- Texte touche "G" / Text info for "G"

-- [FR] Flag qui affiche (== true) ou non (== false) le texte d'information pour effectuer l'ATTACH
-- [EN] Flag that show (if true) or not (if false) the info text 
local TextVisible = true
-- [FR] Flag qui permets de savoir si l'ancre est jetée (== true) ou remontée (== false) - Initialisation à FALSE au démarrage
-- [EN] Flag that help to know it the anchor is throwed (if true) or not (if false) - Init to FALSE on startup
local AncreJetee = false



--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--
--*	FONCTIONS 					    *--
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--

-- [FR] Pas de fonctions nécessaires pour ce script
-- [EN] No functions needed in this script



--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--
--*	THREADS 					    *--
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--

Citizen.CreateThread(function ()
    while true do
    	Citizen.Wait(25)
		
		-- [FR] Récupération du joueur
		-- [EN] Get player info
		local playerPed = PlayerId() --GetPlayerPed(-1)
		
		-- [FR] Si le joueur est dans un véhicule
		-- [EN] If Player is in a vehicle
		if IsPedInAnyVehicle(playerPed, false) then

			-- [FR] Récupération du véhicule et de son Hash
			-- [EN] Take info on the vehicle and also it's hash
            local myVehicle = GetVehiclePedIsIn(playerPed, false)
			local myVehicleHash = GetEntityModel(myVehicle)
			
			-- [FR] Si le model == BATEAU et s'il presse la touche [G] il jette l'ancre (ou la remonte si déjà jetée)
			-- [EN] If the vehicle model is a boat and if the player press [G] then he throw anchor OR take back
			if IsThisModelABoat(myVehicleHash) then
					
				-- [FR] Si le Flag (== true) on affiche le texte d'information pour expliquer comment ATTACH
				if TextVisible then
					Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING")
					Citizen.InvokeNative(0x5F68520888E69014, "Bouton " .. TexteAncre .. " pour jeter ou remonter votre ancre")
					-- EN_TextVersion : Citizen.InvokeNative(0x5F68520888E69014, "Button " .. TexteAncre .. " for throw or take back the anchor")
					Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1)				
					TextVisible = false
				end
			
				-- [FR] Si la touche ToucheAncre (G) est pressée alors on jette ou remonte l'ancre
				-- [EN] If the player press [G] then he throw anchor OR take back
				if IsControlJustPressed(1, ToucheAncre) then
				
					-- [FR] Récupèration de la vitesse du véhicule
					-- [EN] Get speed of the vehicle
					local myVehicleSpeed = GetEntitySpeed(myVehicle)

					-- [FR] Si la vitesse est supérieur à 20Kmh alors on affiche un message
					-- [EN] If the speed is more 20kmh then display a message
					if (myVehicleSpeed * 3.6) > 20 then
					
						Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING")
						Citizen.InvokeNative(0x5F68520888E69014, "Trop rapide pour jeter l'ancre")
						-- EN_TextVersion : Citizen.InvokeNative(0x5F68520888E69014, "Too much speed for throwing anchor")
						Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1)	
					
					-- [FR] Si la vitesse est inférieur à 20Kmh alors on peut jeter l'ancre
					-- [EN] If the speed is less than 20kmh then we can throw anchor
					else
								-- [FR] TODO : Ajouter animation pour le jeté de l'ancre
								-- [EN] TODO : Add animation
						
						-- [FR] Si l'ancre est déjà jetée, alors on la remonte
						-- [EN]If the anchor always throwed, then take it back
						if AncreJetee then
							FreezeEntityPosition(myVehicle, false)
							AncreJetee = false
							SetVehicleEngineOn(myVehicle, true, false, true)								
							Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING")
							Citizen.InvokeNative(0x5F68520888E69014, "Ancre remontée")
							-- EN_TextVersion : Citizen.InvokeNative(0x5F68520888E69014, "Anchor back")
							Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1)				
							TextVisible = false
						-- [FR] Si l'ancre n'est pas encore jetée, on la jette
						-- [EN] if anchor is onboard, then throw it to stop the boat
						elseif AncreJetee == false then
							FreezeEntityPosition(myVehicle, true)
							AncreJetee = true
							SetVehicleEngineOn(myVehicle, false, false, true)
							TaskLeaveVehicle(playerPed, myVehicle, 64)
							Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING")
							Citizen.InvokeNative(0x5F68520888E69014, "Ancre jetée, bateau arrêté")
							-- EN_TextVersion : Citizen.InvokeNative(0x5F68520888E69014, "Throwed anchor, boat stopped")
							Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1)				
							TextVisible = false
						end	
						
					end -- [FR] Fin if Speed > 20Kmh
						
				end -- [FR] Fin if G pressed												
					
			end	-- [FR] Fin if Bateau

		else
        	TextVisible = true
			
		end -- [FR] Fin if Joueur dans véhicule
				
	end -- [FR] Fin boucle
	
end) -- [FR] Fin Thread Citizen
