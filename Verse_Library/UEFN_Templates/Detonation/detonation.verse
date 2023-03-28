
using { /Fortnite.com/Devices }
using { /Verse.org/Native }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }


# enum to determine the state of the bombs
bomb_state<public>:= enum {AllUnarmed, BombAArmed, BombBArmed}

# A Verse-authored creative device that can be placed in a level
# 
# Getting started:
#     https://www.epicgames.com/fortnite/en-US/creative/docs/uefn/Verse/onboarding-guide-to-programming-with-verse-in-unreal-editor-for-fortnite
#
detonation := class(creative_device):

    @editable 
    TimedObjectiveA : timed_objective_device = timed_objective_device{}
    @editable 
    TimedObjectiveB : timed_objective_device = timed_objective_device{}
    @editable
    ExplosiveBarrelsA : []explosive_device = array{}
    @editable
    ExplosiveBarrelsB : []explosive_device = array{}
    @editable
    EndGameDevice : end_game_device = end_game_device{}
    @editable
    BombAMapIndicators : []map_indicator_device = array{}
    @editable
    BombBMapIndicators : []map_indicator_device = array{}
    @editable
    BombABeaconArm : beacon_device = beacon_device{}
    @editable
    BombABeaconDisarm : beacon_device = beacon_device{}
    @editable
    BombBBeaconArm : beacon_device = beacon_device{}
    @editable
    BombBBeaconDisarm : beacon_device = beacon_device{}

    var BombState : bomb_state = bomb_state.AllUnarmed

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # The race expression is used to run a block of two or more async expressions concurrently (simultaneously). When the fastest expression completes, it "wins the race".
        race:
            block:
                # Wait for Bomb A to be armed
                ArmingPlayer := TimedObjectiveA.BeganEvent.Await()
                Print("Bomb A Armed", ?Duration:=5.0)
                
                # Used to know which beacons to enable and barrels need to explode
                set BombState = bomb_state.BombAArmed
                
                # Disable the other Timed Objective device
                TimedObjectiveB.Disable(ArmingPlayer)
                
                # Disable map indicators for Bomb B
                for (MapIndicator : BombBMapIndicators):
                    MapIndicator.Disable()

            block:
                # Wait for Bomb B to be armed
                ArmingPlayer := TimedObjectiveB.BeganEvent.Await()
                Print("Bomb B Armed", ?Duration:=5.0)
                
                # Used to know which beacons to enable and barrels need to explode
                set BombState = bomb_state.BombBArmed
                
                # Disable the other Timed Objective device
                TimedObjectiveA.Disable(ArmingPlayer)

                 # Disable map indicators for Bomb A
                for (MapIndicator : BombAMapIndicators):
                    MapIndicator.Disable()
        
        # Enable the correct Beacon Devices now a bomb is armed
        UpdateBeacons()
        
        # Wait for the TimedObjective to Complete or be Stopped
        race:
            BombDetonated(TimedObjectiveA.CompletedEvent.Await())

            BombDetonated(TimedObjectiveB.CompletedEvent.Await())
            
            block:
                DisarmingPlayer := TimedObjectiveA.EndedEvent.Await()
                Print("Bomb Disarmed", ?Duration:=5.0)
                EndGameDevice.Activate(DisarmingPlayer)

            block:
                DisarmingPlayer := TimedObjectiveB.EndedEvent.Await()
                Print("Bomb Disarmed", ?Duration:=5.0)
                EndGameDevice.Activate(DisarmingPlayer)

        
    # Disable the unarmed Beacons and enable the Beacon over the armed bomb
    UpdateBeacons():void=
        BombABeaconArm.Disable()
        BombBBeaconArm.Disable()
        
        if (BombState = bomb_state.BombAArmed):
            BombABeaconDisarm.Enable()
        else:
            BombBBeaconDisarm.Enable()

    BombDetonated(Agent:agent):void=
        Print("Bomb Detonated", ?Duration:=5.0)
        # Determine which set barrels should explode
        if (BombState = bomb_state.BombAArmed):
            ExplodeBarrels(ExplosiveBarrelsA, Agent)
        else:
            ExplodeBarrels(ExplosiveBarrelsB, Agent)

        EndGameDevice.Activate(Agent)
    
    ExplodeBarrels(Barrels:[]explosive_device, Agent:agent):void=
        for (Barrel : Barrels):
            Barrel.Explode(Agent)