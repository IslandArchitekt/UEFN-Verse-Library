using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath }

button_widget_device := class(creative_device):

    # Set the Button device in the Editor to reference the device in the level
    @editable
    MyButton : button_device = button_device{}

    # Localizable message to display as text in the UI
    TextForMyUI<localizes> : message = "Option"

    # A mapping between the Player and the widget that may have been added to their UI
    var MaybeMyUIPerPlayer : [player]?canvas = map{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends> : void =
        MyButton.InteractedWithEvent.Subscribe(HandleButtonInteraction)

    # A custom UI can only be associated with a specific player, and only that player can see it
    HandleButtonInteraction(Agent : agent) : void =
        if (InPlayer := player[Agent], PlayerUI := GetPlayerUI[InPlayer]):
            if (MyUI := MaybeMyUIPerPlayer[InPlayer]?):
                PlayerUI.RemoveWidget(MyUI)
                if (set MaybeMyUIPerPlayer[InPlayer] = false) {}
            else:
                NewUI := CreateMyUI()
                PlayerUI.AddWidget(NewUI, player_ui_slot{InputMode := ui_input_mode.All})
                if (set MaybeMyUIPerPlayer[InPlayer] = option{NewUI}) {}

    CreateMyUI() : canvas =
        MyUIButton : button_loud = button_loud{DefaultText := TextForMyUI}

        MyUIButton.OnClick().Subscribe(HandleSelectedUIButton)

        MyInteractableButtons : canvas = canvas:
            Slots := array:
                canvas_slot:
                    Anchors := anchors{Minimum := vector2{X := 0.25, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := true
                    Widget := MyUIButton

        return MyInteractableButtons

    HandleSelectedUIButton(Message : widget_message) : void =
        if (PlayerUI := GetPlayerUI[Message.Player], MyUI := MaybeMyUIPerPlayer[Message.Player]?, SelectedButton := text_button_base[Message.Source]):
            Print("Player selected {SelectedButton.GetText()}")
            PlayerUI.RemoveWidget(MyUI)
            if (set MaybeMyUIPerPlayer[Message.Player] = false) {}