using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/UI }

countdown_timer_example := class(creative_device):

    @editable
    AddMoreTimeButton : button_device = button_device{}

    @editable
    EndGame : end_game_device = end_game_device{}

    var CountdownTimer : countdown_timer = countdown_timer{}
    InitialCountdownTime : float = 30.0

    OnBegin<override>()<suspends> : void =
        AddMoreTimeButton.InteractedWithEvent.Subscribe(OnButtonInteractedWith)

        if:
            FirstPlayer := Self.GetPlayspace().GetPlayers()[0]
            PlayerUI := GetPlayerUI[player[FirstPlayer]]
        then:
            set CountdownTimer = countdown_timer{MaybePlayerUI := option{PlayerUI}, RemainingTime := InitialCountdownTime}
        
            CountdownTimer.StartCountdown()

            CountdownTimer.CountdownEndedEvent.Await()
            
            EndGame.Activate(FirstPlayer)
        else:
            Print("Can't find player")

    OnButtonInteractedWith(Agent : agent) : void =
        TimeToAdd : float = 20.0
        CountdownTimer.AddRemainingTime(TimeToAdd)