package;

import flixel.FlxSprite;

class FreeplayState extends MusicBeatState
{
    override function create() {
        super.create();
        
        var bg:FlxSprite = new FlxSprite(0, 0, Paths.image("menuDesat"));
        bg.color = 0x39A9FF;
        add(bg);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.justPressed.BACK) {
            MusicBeatState.switchStateWithTransition(MainMenuState, LEFT);
        }
    }
}