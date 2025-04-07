package states.test;

import flixel.FlxG;
import objects.Character;

class DaCharacter extends MusicBeatState
{
    var char:Character;

    override function create() {
        super.create();

        getCharacter("dad");
    }

    function getCharacter(name:String) {
        remove(char);
        char = new Character(0, 0, name);
        char.screenCenter();
        add(char);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (Controls.justPressed("up") || Controls.justPressed("down")) {
            char.playAnim(Controls.justPressed("up") ? "singUP" : "singDOWN");
        }

        if (Controls.justPressed("left") || Controls.justPressed("right")) {
            char.playAnim(Controls.justPressed("left") ? "singLEFT" : "singRIGHT");
        }

        char.animation.onFinish.add(function (name:String) {
            if (name == "singLEFT" || name == "singRIGHT" || name == "singUP" || name == "singDOWN") {
                char.playAnim("idle");
            }
        });

        if (Controls.justPressed("exit")) {
            FlxG.switchState(() -> new states.MainMenuState());
        } 
    }
}