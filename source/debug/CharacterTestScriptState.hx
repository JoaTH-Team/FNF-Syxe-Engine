package debug;

class CharacterTestScriptState extends MusicBeatState
{
    override function create() {
        super.create();
    }    

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.justPressed.BACK)
        {
            MusicBeatState.switchStateWithTransition(MainMenuState);
        }
    }
}