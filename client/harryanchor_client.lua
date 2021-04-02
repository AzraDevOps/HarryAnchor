--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--
--*--------------------------------- HARRY BOAT ATTACH BY HARRY "AZRADEVOPS" -----------------------------------*--
--*														*--
--*														*--
--*-- FR --													*--
--*   v 2.0.0 du 29/03/2021 (pour les différentes étapes du dev, lisez le fichier README_DEV.md)		*--
--*   > Ajout de la fonction ANCRE à tous les bateaux								*--
--*   			> Cela permets de lancer l'ancre et de figer le bateau					*--
--*					- Attention il ne faut pas dépasser les 20Kmh pour pouvoir le faire 	*--
--*														*--
--*   Tous commentaires ou aides sont les bienvenus, allez sur  https://github.com/AzraDevOps/Harryattach	*--
--*														*--
--*														*--
--*-- EN --													*--
--*   v 2.0.0 of 29/03/2021 (for the roadmap dev read README_DEV.md)						*--
--*   > Add anchor function for all boats									*--
--*   			> Throw anchor and fix the boat								*--
--*					- Be careful of your speed, you must be under 20Kmh to throw the anchor	*--
--*														*--
--*   All comments or help welcome , go on  https://github.com/AzraDevOps/Harryattach	  			*--
--*														*--
--*														*--
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--



--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--
--*	DECLARATIONS VARIABLES & CONFIG & ESX FRAMEWORK	    *--
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShLittleACaredObjLittleACect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end) -- Fin Citizen.CreateThread(function()

-- Definition des touches pour jeter et remonter l'ancre
-- Definition for throw and takeback the anchor
ToucheAncre = 58 		-- Touche "G" / Keyboard "G"
TexteAncre = "G"		-- Texte touche "G" / Text info for "G"

-- Flag qui affiche (== true) ou non (== false) le texte d'information pour effectuer l'ATTACH
-- Flag that show (if true) or not (if false) the info text 
local TextVisible = true
-- Flag qui permets de savoir si l'ancre est jetée (== true) ou remontée (== false) - Initialisation à FALSE au démarrage
-- Flag that help to know it the anchor is throwed (if true) or not (if false) - Init to FALSE on startup
local AncreJetee = false



--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--
--*	FONCTIONS 					    *--
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--

-- Pas de fonctions nécessaires pour ce script
-- No functions needed in this script



--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--
--*	THREADS 					    *--
--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--

Citizen.CreateThread(function ()
    while true do
    	Citizen.Wait(25)
		
		-- Récupération du joueur
		-- Get player info
		local playerPed = GetPlayerPed(-1)
		
		-- Si le joueur est dans un véhicule
		-- If Player is in a vehicle
		if IsPedInAnyVehicle(playerPed, false) then

			-- Récupération du véhicule et de son Hash
			-- Take info on the vehicle and also it's hash
            local myVehicle = GetVehiclePedIsIn(playerPed, false)
			local myVehicleHash = GetEntityModel(myVehicle)
			
			-- Si le model == BATEAU et s'il presse la touche [G] il jette l'ancre (ou la remonte si déjà jetée)
			-- If the vehicle model is a boat and if the player press [G] then he throw anchor OR take back
			if IsThisModelABoat(myVehicleHash) then
					
				-- Si le Flag (== true) on affiche le texte d'information pour expliquer comment ATTACH
				if TextVisible then
					Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING")
					Citizen.InvokeNative(0x5F68520888E69014, "Bouton " .. TexteAncre .. " pour jeter ou remonter votre ancre")
					-- EN : Citizen.InvokeNative(0x5F68520888E69014, "Button " .. TexteAncre .. " for throw or take back the anchor")
					Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1)				
					TextVisible = false
				end
			
				-- Si la touche ToucheAncre (G) est pressée alors on jette ou remonte l'ancre
				-- If the player press [G] then he throw anchor OR take back
				if IsControlJustPressed(1, ToucheAncre) then
				
					-- Récupèration de la vitesse du véhicule
					-- Get speed of the vehicle
					local myVehicleSpeed = GetEntitySpeed(myVehicle)

					-- Si la vitesse est supérieur à 20Kmh alors on affiche un message
					-- If the speed is more 20kmh then display a message
					if (myVehicleSpeed * 3.6) > 20 then
					
						Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING")
						Citizen.InvokeNative(0x5F68520888E69014, "Trop rapide pour jeter l'ancre")
						-- EN : Citizen.InvokeNative(0x5F68520888E69014, "Too much speed for throwing anchor")
						Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1)	
					
					-- Si la vitesse est inférieur à 20Kmh alors on peut jeter l'ancre
					-- If the speed is less than 20kmh then we can throw anchor
					else
								-- TODO : Ajouter animation pour le jeté de l'ancre
						
						-- Si l'ancre est déjà jetée, alors on la remonte
						-- If the anchor always throwed, then take it back
						if AncreJetee then
							FreezeEntityPosition(myVehicle, false)
							AncreJetee = false
							SetVehicleEngineOn(myVehicle, true, false, true)								
							Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING")
							Citizen.InvokeNative(0x5F68520888E69014, "Ancre remontée")
							-- EN : Citizen.InvokeNative(0x5F68520888E69014, "Anchor back")
							Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1)				
							TextVisible = false
						-- Si l'ancre n'est pas encore jetée, on la jette
						-- if anchor is onboard, then throw it to stop the boat
						elseif AncreJetee == false then
							FreezeEntityPosition(myVehicle, true)
							AncreJetee = true
							SetVehicleEngineOn(myVehicle, false, false, true)
							TaskLeaveVehicle(playerPed, myVehicle, 64)
							Citizen.InvokeNative(0x8509B634FBE7DA11, "STRING")
							Citizen.InvokeNative(0x5F68520888E69014, "Ancre jetée, bateau arrêté")
							-- EN : Citizen.InvokeNative(0x5F68520888E69014, "Throwed anchor, boat stopped")
							Citizen.InvokeNative(0x238FFE5C7B0498A6, 0, false, true, -1)				
							TextVisible = false
						end	
						
					end -- Fin if Speed > 20Kmh
						
				end -- Fin if G pressed												
					
			end	-- Fin if Bateau

		else
        	TextVisible = true
			
		end -- Fin if Joueur dans véhicule
				
	end -- Fin boucle
	
end) -- Fin Thread Citizen
