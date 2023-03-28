using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }

spawner_button := class<concrete>(creative_device):
    @editable
    Button:button_device = button_device{}
    @editable
    ItemSpawner:item_spawner_device = item_spawner_device{}

    OnBegin<override>()<suspends> : void =
        Button.InteractedWithEvent.Subscribe(OnButtonInteractedWith) 

    OnButtonInteractedWith(InPlayer:agent) : void =
        ItemSpawner.SpawnItem()