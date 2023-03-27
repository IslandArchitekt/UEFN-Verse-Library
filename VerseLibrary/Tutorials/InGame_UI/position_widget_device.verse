using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath}

position_widget_device := class(creative_device):

    # Set the Button device in the Editor to reference the device in the level
    @editable
    MyButton : button_device = button_device{}
    
    # Localizable messages to display as text in the UI
    TextForMyUpperLeftUI<localizes> : message = "UpperLeft"
    TextForMyUpperMiddleUI<localizes> : message = "UpperMiddle"
    TextForMyUpperRightUI<localizes> : message = "UpperRight"
    TextForMyMiddleLeftUI<localizes> : message = "MiddleLeft"
    TextForMyCenterUI<localizes> : message = "Center"
    TextForMyMiddleRightUI<localizes> : message = "MiddleRight"
    TextForMyLowerLeftUI<localizes> : message = "LowerLeft"
    TextForMyLowerMiddleUI<localizes> : message = "LowerMiddle"
    TextForMyLowerRightUI<localizes> : message = "LowerRight"

    # A mapping between the Player and the widget that may have been added to their UI
    var MaybeMyUIPerPlayer : [player]?canvas = map{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends> : void =
        MyButton.InteractedWithEvent.Subscribe(HandleButtonInteraction)

    # A custom UI can only be associated with a specific player, and only that player can see it
    HandleButtonInteraction(Agent : agent) : void =
        # Agents can be a player or AI, but you can only get the UI of a player
        # so you must cast the Agent, who interacted with the Button device, to the player type
        if (InPlayer := player[Agent], PlayerUI := GetPlayerUI[InPlayer]):
            if (MyUI := MaybeMyUIPerPlayer[InPlayer]?):
                PlayerUI.RemoveWidget(MyUI)
                if (set MaybeMyUIPerPlayer[InPlayer] = false) {}
            else:
                NewUI := CreateMyUI()
                PlayerUI.AddWidget(NewUI)
                if (set MaybeMyUIPerPlayer[InPlayer] = option{NewUI}) {}
    
    # A canvas widget that displays a button with text at various positions around the screen
    CreateMyUI() : canvas =
        MyCanvas : canvas = canvas:
            Slots := array:
                canvas_slot: # Upper Left of Screen
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 0.0}, Maximum := vector2{X := 0.0, Y := 0.0}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.0, Y := 0.0}
                    SizeToContent := true
                    Widget := button_loud{DefaultText := TextForMyUpperLeftUI}
                canvas_slot: # Upper Middle of Screen
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.0}, Maximum := vector2{X := 0.5, Y := 0.0} }
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.0}
                    SizeToContent := true
                    Widget := button_loud{DefaultText := TextForMyUpperMiddleUI}
                canvas_slot: # Upper Right of Screen
                    Anchors := anchors{Minimum := vector2{X := 1.0, Y := 0.0}, Maximum := vector2{X := 1.0, Y := 0.0}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 1.0, Y := 0.0}
                    SizeToContent := true
                    Widget := button_loud{ DefaultText := TextForMyUpperRightUI}
                canvas_slot: # Middle Left of Screen
                    Anchors := anchors{ Minimum := vector2{X := 0.0, Y := 0.5}, Maximum := vector2{X := 0.0, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.0, Y := 0.5}
                    SizeToContent := true
                    Widget := button_loud{DefaultText := TextForMyMiddleLeftUI}
                canvas_slot: # Center of Screen
                    Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.5}, Maximum := vector2{X := 0.5, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 0.5}
                    SizeToContent := true
                    Widget := button_loud{DefaultText := TextForMyCenterUI}
                canvas_slot: # Middle Right of Screen
                    Anchors := anchors{Minimum := vector2{X := 1.0, Y := 0.5}, Maximum := vector2{X := 1.0, Y := 0.5}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 1.0, Y := 0.5}
                    SizeToContent := true
                    Widget := button_loud{DefaultText := TextForMyMiddleRightUI}
                canvas_slot: # Lower Left of Screen
                    Anchors := anchors{Minimum := vector2{X := 0.0, Y := 1.0}, Maximum := vector2{X := 0.0, Y := 1.0}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.0, Y := 1.0}
                    SizeToContent := true
                    Widget := button_loud{DefaultText := TextForMyLowerLeftUI}
                canvas_slot: # Lower Middle of Screen
                    Anchors := anchors{ Minimum := vector2{X := 0.5, Y := 1.0}, Maximum := vector2{X := 0.5, Y := 1.0}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 0.5, Y := 1.0}
                    SizeToContent := true
                    Widget := button_loud{DefaultText := TextForMyLowerMiddleUI}
                canvas_slot: # Lower Right of Screen
                    Anchors := anchors{Minimum := vector2{X := 1.0, Y := 1.0}, Maximum := vector2{X := 1.0, Y := 1.0}}
                    Offsets := margin{Top := 0.0, Left := 0.0, Right := 0.0, Bottom := 0.0}
                    Alignment := vector2{X := 1.0, Y := 1.0}
                    SizeToContent := true
                    Widget := button_loud{DefaultText := TextForMyLowerRightUI}
        
        return MyCanvas