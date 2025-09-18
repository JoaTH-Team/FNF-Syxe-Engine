package debug;

class CharacterTest extends MusicBeatState
{
    var char:Character;

    override function create() {
        super.create();

        char = new Character(0, 0);
        char.screenCenter();
        add(char);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.justPressed.BACK)
            MusicBeatState.switchStateWithTransition(MainMenuState);
    }
}