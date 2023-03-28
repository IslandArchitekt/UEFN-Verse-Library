using { /Verse.org/Simulation }
using { /Fortnite.com/Devices}
 
expose_properties := class<concrete>(creative_device):

    @editable
    GreetingMessage : string = "Hello, stranger"
    @editable
    IntroMessages : []string = array{"Welcome to the Game", "Have Fun!"}

    OnBegin<override>()<suspends> : void =
        Print("{GreetingMessage}")
        for (Message : IntroMessages):
            Print("{Message}")