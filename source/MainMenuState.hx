package;

import flixel.FlxG;

class MainMenuState extends MusicBeatState
{
    override function create() {
        super.create();

        if (!FlxG.sound.music.playing) {
            FunkinSound.playMusic(true, "freakyMenu/freakyMenu", 1, true);
        }

        persistentUpdate = persistentDraw = true;        
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }
}