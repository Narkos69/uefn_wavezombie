
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using { /Verse.org/Simulation/Tags }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Verse.org/Simulation/Tags }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI}
using { /Fortnite.com/UI }

    # TagClasses
     fiendSpawnerTag := class(tag){}
     rangedSpawnerTag := class(tag){}
     bruteSpawnerTag := class(tag){}

log_wave_zombie := class(log_channel){}



# A Verse-authored creative device that can be placed in a level
enemy_wave_spawner := class(creative_device):



    ##### PERKS #####
    #ShieldManager Fiend
    @editable OnFiendKilledShield : health_powerup_device  = health_powerup_device {}
    #Juggernaut perk +100hp
    @editable JuggernautPerk : conditional_button_device = conditional_button_device{}
    #Juggernaut perk +100 Shield
    @editable JuggernautShieldPerk : conditional_button_device = conditional_button_device{}


    #Decrement ennemy count on HUD
    @editable NewWaveTextHUD : hud_message_device = hud_message_device{}

    #Give XP when a round/wave is over
    @editable RoundXPAccolade : accolades_device  = accolades_device {}

    #Message 4 neww ennemy
    @editable HudMessageNewEnnemy : hud_message_device  = hud_message_device {}


    @editable P_Ref_1 : player_reference_device = player_reference_device{}

    @editable StartGame : conditional_button_device = conditional_button_device{}

    @editable TrackerZombieKilled : tracker_device = tracker_device{}
    @editable TrackerCurrentWave : tracker_device = tracker_device{}
    @editable TrackerTotalZombieKilledDuringGame : tracker_device = tracker_device{}
    #SFXWaveSpawn
    @editable SFXWaveSpawn : audio_player_device = audio_player_device{}
    #SFXEndRound
    @editable SFXEndRound : audio_player_device = audio_player_device{}
    #RunningFromEvil
    @editable RunningFromEvil : audio_player_device = audio_player_device{}
    ## FiendSpawner
    var CreatureSpawners : []creature_placer_device = array{}
    ## Ranged
    var CreatureSpawnersRanged : []creature_placer_device = array{}
    ## Brute
    var CreatureSpawnersBrute : []creature_placer_device = array{}
    ## Used for tracking kills
    @editable ElimMGR :elimination_manager_device = elimination_manager_device{}
    ## Used for tracking kills
    @editable DebugWave : button_device = button_device{}
    #TimerBetweenRounds
    @editable TimerBetweenRoundsDevice : timer_device = timer_device{}
    #STOP MUSIC
    @editable StopMusic : button_device = button_device{}
    #START MUSIC
    @editable StartMusic : button_device = button_device{}
    #HUD ZOMBIE KILLED
    @editable HUDTotalZombieKilled : hud_message_device = hud_message_device{}
    #HUD MESSAGE GAME START
    @editable HUDMessageGameStart : hud_message_device = hud_message_device{}
    #HUD INFORMATION ABOUT ZOMBIE REMANING AND UNLOCK
    @editable HUDMessageInformationButtonUnlocked : hud_message_device = hud_message_device{}
    #HUD MESSAGE ZOMBIE KILLED NEEDED
    @editable HUDMessageZombieKilledNeeded : hud_message_device = hud_message_device{}
    #CONDITIONAL BUTTON GRILLE FENCE
    @editable ConditionalButtonFence : conditional_button_device = conditional_button_device{}
    #CONDITIONAL BUTTON EXIT GAME
    @editable ConditionalButtonExitGame : conditional_button_device = conditional_button_device{}
    #BILLBOARD GRILLE FENCE
    @editable BillBoardFence : billboard_device = billboard_device {}
    #BILLBOARD EXIT
    @editable BillBoardExit : billboard_device = billboard_device {}
    @editable SFXOpen<public> : audio_player_device = audio_player_device{}

    ##### GOLDS DROSP PAR LES MOBS #####
    @editable GoldsDropedByFiend : item_granter_device = item_granter_device{}
    @editable GoldsDropedByRanged : item_granter_device = item_granter_device{}
    @editable GoldsDropedByBrute : item_granter_device = item_granter_device{}

    #Stat à Track
    var statValue1:int = 0

    ## --- Game Logic
    _gameActive : logic = false
    var _ZombieKilledCount1 : logic = false
    var _ZombieKilledCount2 : logic = false
    var totalEnemiesKilled : int = 0
    var roundEnemiesKilled : int = 0

    var TotalZombieKilledDuringGame : int = 0

    var ZombieKilledNeededStep1 : int = 100
    var ZombieKilledNeededStep2 : int = 300
    var ZombieKilledNeededStep3 : int = 450
    var ZombieKilledNeededStep4 : int = 600
    var ZombieKilledNeededStep5 : int = 500

    var GoldsDropedByFiendBase : int = 5
    var GoldsDropedByRangedBase : int = 10
    var GoldsDropedByBruteBase : int = 15

    var MODE_DEBUG : logic = false
    var MODE_DEBUG_BOUTON : logic = false
    var currentWave : int = 0
    var waveKilledGoal : int = 15
    var creaturesSpawned: int = 0
    var additionalCreaturesSpawned: int = 0
    #########################################
    hud_device_custom : hud_message_device = hud_message_device{}

    var _myIntValue:int = 0
    var numberone:int = 0
    var hudIntValue:int = 0


    #HUD Messages
    var _textWiget: text_block = text_block{DefaultTextColor:= color{R:=0.1, G:=1.0, B:=0.1}}
    var _textWigetNewEnnemy: text_block = text_block{DefaultTextColor:= color{R:=1.0, G:=0.1, B:=0.1}}
    var _textWigetActualRound: text_block = text_block{DefaultTextColor:= color{R:=0.1, G:=0.1, B:=1.0}}
    var _textWigetTotalKillPerso: text_block = text_block{DefaultTextColor:= color{R:=1.0, G:=1.0, B:=0.1}}
    var _textWigetNewWave: text_block = text_block{DefaultTextColor:= color{R:=1.0, G:=1.0, B:=0.1}}


    

    SetDynamicText<localizes>(IntValue:int) : message = "Ennemy before the next wave : {IntValue}"
    SetDynamicTextHud<localizes>(hudInt:int) : message = "Dynamic text {hudInt}" 
    SetDynamicTextNewEnnemy<localizes>() : message = "A new ennemy has appeared.." 
    SetDynamicTextActualRound<localizes>(currWave:int) : message = "Wave : {currWave}" 
    SetDynamicTextTotalEnnemyKilledDuringGame<localizes>(totalEnnemyKilled:int) : message = "Total Zombies Killed : {totalEnnemyKilled}"
    SetDynamicTextHUDStartGame<localizes>() : message = "Find a way to <Strong>survive</> and <Strong>escape!</> You need to restore <EM>electricity</> at the <EM>guard</> <EM>post.</>"
    SetDynamicTextZombieKilledNeeded<localizes>(TotalZombieKilledDuringGameMessage:int) : message = "{TotalZombieKilledDuringGameMessage} Creatures remaining to continue."
    SetDynamicTextMissingItemToOpenDoor<localizes>() : message = "Missing items required.." 

    SetDynamicTextFenceButtonUnlocked<localizes>() : message = "The button near the <Strong>fences</> has been <EM>enabled!</> You can now continue your <EM>journey</> "
    SetDynamicTextExitButton<localizes>() : message = "The button for <Strong>EXIT</> has been <EM>enabled!</> You can now exit this <EM>madness</> "



    Logger : log = log{Channel := log_wave_zombie, DefaultLevel:=log_level.Debug}

    OnBegin<override>()<suspends>:void=

        Sleep(0.0)
        Setup()


    # On reset les var à 0 et on call le managers setup
    Setup(): void=
        set roundEnemiesKilled = 0
        set totalEnemiesKilled = 0
        set TotalZombieKilledDuringGame = 0
        # Setup Managers
        ManagerSetup()
        HUDMessageGameStart.SetText(SetDynamicTextHUDStartGame())
        HUDMessageGameStart.Show() 


     


    #Setting up the managers    
    ManagerSetup():void=

        ElimMGR.EliminatedEvent.Subscribe(OnZombieKilled)
        TimerBetweenRoundsDevice.SuccessEvent.Subscribe(SpawnWaveFromTimer)
        JuggernautPerk.ActivatedEvent.Subscribe(OnJuggernautActivated)
        JuggernautShieldPerk.ActivatedEvent.Subscribe(OnJuggernautShieldActivated)
        StartGame.ActivatedEvent.Subscribe(OnButtonInteractedWith)
        DebugWave.InteractedWithEvent.Subscribe(DebugWaveZombie)
        StopMusic.InteractedWithEvent.Subscribe(StopRunningFromEvil)
        StartMusic.InteractedWithEvent.Subscribe(StartRunningFromEvil)
       
     


    
    # Called when linked button device is pressed
    OnButtonInteractedWith(InPlayer:agent): void=
        SpawnWave()
   
 
        
    SFXOnWaveSpawn():void=
        SFXWaveSpawn.Play()
    SFXOnWaveEnded():void=
        SFXEndRound.Play()
    RunningFromEvilPlay():void=
        RunningFromEvil.Play()


    StopRunningFromEvil(InAgent: agent):void=
        RunningFromEvil.Stop(InAgent)    
    StartRunningFromEvil(InAgent: agent):void=
        RunningFromEvil.Play(InAgent)             

    ## démarre la prochaine wave.
    
    SpawnWave(): void =

        NewWaveTextHUD.Show()
        TimerBetweenRoundsDevice.Disable()
        
        #On récup les spawners (on reset en gros
        GetCreatureSpawnersFiend()  
        GetCreatureSpawnersRanged()
        GetCreatureSpawnersBrute()
        #On joue le son de début de round
        SFXOnWaveSpawn()
        

        #On remet le nbs de créa killed à Z
        set creaturesSpawned = 0

        # Réinitialisation du nombre d'ennemis tués pour la vague actuelle
        set roundEnemiesKilled = 0

        # On Incrémente le numéro de la vague actuelle
        set currentWave = currentWave + 1
    
        # Définir l'objectif de tués pour la vague actuelle
        set waveKilledGoal = waveKilledGoal + 5

       
        
        # Boucle de génération des ennemis pour la vague actuelle ( +3 au cas ou l'IA d'une créa est bug)
        for (x := 0..(waveKilledGoal) + 3):
            if(MODE_DEBUG = true):
                Logger.Print("ENTERING LOOP ITERATIONS: {x}  | GOAL : {waveKilledGoal + 1}",?Level:= log_level.Debug)
            
            # Générer des créatures "Fiend" si la vague actuelle est inférieure ou égale à 4
            if (currentWave <= 7):
                if(creaturesSpawned < (waveKilledGoal + 3)):
                    var iFiend: int = GetRandomInt(0, CreatureSpawners.Length)
                    if (spwnrFiend := CreatureSpawners[iFiend]):
                        spwnrFiend.Spawn()
                        set creaturesSpawned = creaturesSpawned + 1
                            if (TempArray := CreatureSpawners.RemoveElement[iFiend]):
                                set CreatureSpawners = TempArray
                                    if(MODE_DEBUG = true):        
                                        Logger.Print("Creature spawned Fiends :  {creaturesSpawned}",?Level:= log_level.Debug)




            if (currentWave > 7 and currentWave <= 14):                    
                if(creaturesSpawned < (waveKilledGoal + 3)):
                                      
                    var iFiend: int = GetRandomInt(0, CreatureSpawners.Length)
                        if (spwnrFiend := CreatureSpawners[iFiend]):
                            spwnrFiend.Spawn()
                            set creaturesSpawned = creaturesSpawned + 1
                                if (TempArray := CreatureSpawners.RemoveElement[iFiend]):
                                    set CreatureSpawners = TempArray
                                        if (MODE_DEBUG = true):
                                            Logger.Print("Creature spawned Fiends : {creaturesSpawned}",?Level:= log_level.Debug)
                                                    
                    var iRanged: int = GetRandomInt(0, CreatureSpawnersRanged.Length)
                        if (spwnrRanged := CreatureSpawnersRanged[iRanged]):
                            spwnrRanged.Spawn()
                            set creaturesSpawned = creaturesSpawned + 1
                                if (TempArray := CreatureSpawnersRanged.RemoveElement[iRanged]):
                                    set CreatureSpawnersRanged = TempArray
                                        if (MODE_DEBUG = true):
                                            Logger.Print("Creature spawned Ranged {creaturesSpawned}",?Level:= log_level.Debug)

                
            if (currentWave > 14): 
                if(creaturesSpawned < (waveKilledGoal + 3)):
                # Mix Fiend and Ranged creatures for waves greater than 4
                    var iFiend: int = GetRandomInt(0, CreatureSpawners.Length)
                        if (spwnrFiend := CreatureSpawners[iFiend]):
                            spwnrFiend.Spawn()
                            set creaturesSpawned = creaturesSpawned + 1
                                if (TempArray := CreatureSpawners.RemoveElement[iFiend]):
                                    set CreatureSpawners = TempArray
                                        if (MODE_DEBUG = true):
                                            Logger.Print("Creature spawned Fiends : {creaturesSpawned}",?Level:= log_level.Debug)
                            
                    var iRanged: int = GetRandomInt(0, CreatureSpawnersRanged.Length)
                        if (spwnrRanged := CreatureSpawnersRanged[iRanged]):
                            spwnrRanged.Spawn()
                            set creaturesSpawned = creaturesSpawned + 1
                                if (TempArray := CreatureSpawnersRanged.RemoveElement[iRanged]):
                                    set CreatureSpawnersRanged = TempArray
                                        if (MODE_DEBUG = true):
                                            Logger.Print("Creature spawned Ranged {creaturesSpawned}",?Level:= log_level.Debug)

                    var iBrute: int = GetRandomInt(0, CreatureSpawnersBrute.Length)
                        if (spwnrBrute := CreatureSpawnersBrute[iBrute]):
                            spwnrBrute.Spawn()
                            set creaturesSpawned = creaturesSpawned + 1
                                if (TempArray := CreatureSpawnersBrute.RemoveElement[iBrute]):
                                    set CreatureSpawnersBrute = TempArray
                                        if (MODE_DEBUG = true):
                                            Logger.Print("Creature spawned Brute {creaturesSpawned}",?Level:= log_level.Debug)
                     
        
        
        
        # Afficher le message pour le noueau type d'ennemi si nécessaire
            if (currentWave = 10):
                HudMessageNewEnnemy.Show()
            if (currentWave = 15):
                HudMessageNewEnnemy.Show()    
            #if (currentWave = 10):
                #HudMessageNewEnnemy.Show()    
    
        #On défini le nbs de Z à kill pour la currentwave
        
        TrackerZombieKilled.SetTarget(waveKilledGoal)
        TrackerZombieKilled.SetValue(0)
        TrackerZombieKilled.AssignToAll()
        
            
        #On défini la wave en cours dans le tracker
        TrackerCurrentWave.SetTarget(currentWave) 
        TrackerCurrentWave.SetValue(currentWave) 
        TrackerCurrentWave.AssignToAll()



        
        if(MODE_DEBUG = true):
            Logger.Print("TRACKER OK ! CURRENT WAVE : {currentWave}")
    
    

  
    
    #Despawn creatures
    ClearCreaturesFiend():void=
        for (spwnr : CreatureSpawners):
            spwnr.Despawn()

    ClearCreaturesRanged():void=
        for (spwnrRanged : CreatureSpawnersRanged):
            spwnrRanged.Despawn()
      
    ClearCreaturesBrute():void=
        for (spwnrBrute : CreatureSpawnersBrute):
            spwnrBrute.Despawn()

            


    DebugWaveZombie(InAgent: agent): void =
            if ((waveKilledGoal - roundEnemiesKilled) <= 5):
                GetCreatureSpawnersFiend()
                ClearCreaturesFiend()

                GetCreatureSpawnersRanged()
                ClearCreaturesRanged()

                GetCreatureSpawnersBrute()
                ClearCreaturesBrute()

                if(MODE_DEBUG = true):
                    Logger.Print("Wave cleared. Creatures CLEARED")
            else:

                if(MODE_DEBUG = true):
                    Logger.Print("Wave not cleared yet. Remaining zombies:   {waveKilledGoal} - {roundEnemiesKilled}")
        
        


    SpawnWaveFromTimer(InAgent:?agent):void=
        SpawnWave()    


    OnJuggernautActivated(Activator: agent): void =
        if(MODE_DEBUG = true):
            Logger.Print("Juggernaut Activated Event Triggered")
    
        # Vérifiez si l'Activator est un joueur
        if (Player := player[Activator]):
            if(MODE_DEBUG = true):
                Logger.Print("Activator is a Player")
    
            # Tentative de récupération du fort_character du joueur
            if (PlayerCharacter := Player.GetFortCharacter[]):
                if(MODE_DEBUG = true):
                    Logger.Print("Casting réussi - Agent est un fort_character")
    
                # Modifiez la santé maximale et actuelle du personnage
                PlayerCharacter.SetMaxHealth(200.0)
                PlayerCharacter.SetHealth(200.0)
                if(MODE_DEBUG = true):
                    Logger.Print("Santé du joueur augmentée à 200")
            else:
                if(MODE_DEBUG = true):
                    Logger.Print("Casting échoué - Impossible de récupérer fort_character")
        else:
            if(MODE_DEBUG = true):
                Logger.Print("Casting échoué - Agent nest pas un Player")
    

    OnJuggernautShieldActivated(Activator: agent): void =
            if(MODE_DEBUG = true):
                Print("Juggernaut Shield Activated Event Triggered")
            
                # Vérifiez si l'Activator est un joueur
                if (Player := player[Activator]):
                    if(MODE_DEBUG = true):
                        Print("Activator is a Player")
            
                    # Tentative de récupération du fort_character du joueur
                    if (PlayerCharacter := Player.GetFortCharacter[]):
                        if(MODE_DEBUG = true):
                            Print("Casting réussi - Agent est un fort_character")
            
                        # Modifiez la santé maximale et actuelle du personnage
                        PlayerCharacter.SetMaxShield(200.0)
                        PlayerCharacter.SetShield(200.0)
                        if(MODE_DEBUG = true):
                            Print("Shield du joueur augmentée à 200")
                    else:
                        if(MODE_DEBUG = true):
                            Print("Casting échoué - Impossible de récupérer fort_character")
                else:
                    if(MODE_DEBUG = true):
                        Print("Casting échoué - Agent nest pas un Player")


                    ##### FIN JUGGERNAUT PERK ####


    # Searches Fiend Spawners
    GetCreatureSpawnersFiend(): void=
        # Clear the existing array of spawners
        set CreatureSpawners = array{}

        FoundItems := GetCreativeObjectsWithTag(fiendSpawnerTag{})

        for (found : FoundItems):
            if (spwner := creature_placer_device[found]):
                set CreatureSpawners = CreatureSpawners + array{spwner}

        if(MODE_DEBUG = true):
            Logger.Print("Fiend Creature Spawners: {CreatureSpawners.Length}")


 # On cherches parmis les devices tagged
    GetCreatureSpawners(): void=
    # On clear l'array des spawners actuel
        set CreatureSpawners = array{}

        FoundItems := GetCreativeObjectsWithTag(fiendSpawnerTag{})

     for (found : FoundItems):
        if (spwner := creature_placer_device[found]):
            set CreatureSpawners = CreatureSpawners + array{spwner}
        if(MODE_DEBUG = true):
            Logger.Print("Total Creature Spawners: {CreatureSpawners.Length}")



    # On cherche parmis les spawners RANGED
    GetCreatureSpawnersRanged(): void=
    # On clear l'array des spawners actuel
        set CreatureSpawnersRanged = array{}

        FoundItems := GetCreativeObjectsWithTag(rangedSpawnerTag{})

        for (found : FoundItems):
            if (spwner := creature_placer_device[found]):
                set CreatureSpawnersRanged = CreatureSpawnersRanged + array{spwner}

        if(MODE_DEBUG = true):
            Logger.Print("Total Creature Spawners: {CreatureSpawnersRanged.Length}")
    # On cherche parmis les spawners BRUTOOOOS
    GetCreatureSpawnersBrute(): void=
           # On clear l'array des spawners actuel
                set CreatureSpawnersBrute = array{}
        
                FoundItems := GetCreativeObjectsWithTag(bruteSpawnerTag{})
        
                for (found : FoundItems):
                    if (spwner := creature_placer_device[found]):
                        set CreatureSpawnersRanged = CreatureSpawnersRanged + array{spwner}

    # Called quand un mob est kill
    OnZombieKilled(inAgent:agent):void=
        


            
        #Règle le sshield sur 0 lors d'une élimination
        OnFiendKilledShield.SetMagnitude(1.0)
        OnFiendKilledShield.Pickup(inAgent)

        #Incrèmente lorsqu'un zombie est tué
        set totalEnemiesKilled = totalEnemiesKilled + 1
        set roundEnemiesKilled = roundEnemiesKilled + 1
       

        #On change la valeur du nombre de zombie à tué par round
        TrackerZombieKilled.SetValue(roundEnemiesKilled)   

        #On incrémente la valeure
        set TotalZombieKilledDuringGame += 1
        #On change le HUD message avec le nombre de zombie tué pendant LA PARTIE
        HUDTotalZombieKilled.SetText(SetDynamicTextTotalEnnemyKilledDuringGame(TotalZombieKilledDuringGame))


        ##### BILLBOARD FENCES ###############
        #On Change le texte du panneau N°1
        BillBoardFence.SetText(SetDynamicTextZombieKilledNeeded(ZombieKilledNeededStep1 - TotalZombieKilledDuringGame))
        #On Update le display
        BillBoardFence.UpdateDisplay()
        ##### BILLBOARD FENCES ###############

        ##### BILLBOARD EXIT ###############
        BillBoardExit.SetText(SetDynamicTextZombieKilledNeeded(ZombieKilledNeededStep5 - TotalZombieKilledDuringGame))
        BillBoardExit.UpdateDisplay()
        ##### BILLBOARD EXIT ###############

        #Si le nbs de Z tués est supérieur à l'objectif
        if (TotalZombieKilledDuringGame >= ZombieKilledNeededStep1 and _ZombieKilledCount1 = false):
            #On enable le bouton
            ConditionalButtonFence.Enable()
            #On cache le texte
            BillBoardFence.HideText()
            HUDMessageInformationButtonUnlocked.SetText(SetDynamicTextFenceButtonUnlocked())
            HUDMessageInformationButtonUnlocked.SetDisplayTime(5.0)
            HUDMessageInformationButtonUnlocked.Show()
            set _ZombieKilledCount1 = true


        if(TotalZombieKilledDuringGame >= ZombieKilledNeededStep5 and _ZombieKilledCount2 = false):
            ConditionalButtonExitGame.Enable()
            BillBoardExit.HideText()
            HUDMessageInformationButtonUnlocked.SetText(SetDynamicTextExitButton())
            HUDMessageInformationButtonUnlocked.SetDisplayTime(5.0)
            HUDMessageInformationButtonUnlocked.Show()
            set _ZombieKilledCount2 = true

        if(MODE_DEBUG = true):
            Print("{totalEnemiesKilled} Total Fiends Killed!")
            Print("{waveKilledGoal - roundEnemiesKilled} Until the next round!")

     

        #On check si on a atteint le nbs de zombies à tué
        if (roundEnemiesKilled = waveKilledGoal):
           
            if(currentWave <= 7):
             #On récup et on clear les Créa FIEND
                GetCreatureSpawnersFiend()
                ClearCreaturesFiend()
                GetCreatureSpawnersRanged()
                ClearCreaturesRanged()
                GetCreatureSpawnersBrute()
                ClearCreaturesBrute()

            else:
                GetCreatureSpawnersFiend()
                ClearCreaturesFiend()
                GetCreatureSpawnersBrute()
                ClearCreaturesBrute()
                GetCreatureSpawnersRanged()
                ClearCreaturesRanged()  
            <# if(currentWave > 7 and currentWave < 10):
                GetCreatureSpawnersRanged()
                ClearCreaturesRanged()
            if(currentWave > 10):
                GetCreatureSpawnersBrute()
                ClearCreaturesBrute() #>

                
            #On joue le son d'inro
            SFXOnWaveEnded()
            #On Affiche le timer & On set le timer sur X secondes en fonction de la wave actuelle
            if(currentWave <= 7):
                
                TimerBetweenRoundsDevice.SetMaxDuration(5.0)
                TimerBetweenRoundsDevice.Enable()
                TimerBetweenRoundsDevice.Start()
            else:
                TimerBetweenRoundsDevice.SetMaxDuration(7.0)
                TimerBetweenRoundsDevice.Enable()
                TimerBetweenRoundsDevice.Start()
            #ON File l'xp
            RoundXPAccolade.Award(inAgent)


    LargeModdedWeapon():void=
        Print("TEST")
