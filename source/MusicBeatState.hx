package;

import flixel.FlxG;
import flixel.addons.ui.FlxUIState;

class MusicBeatState extends FlxUIState
{
    var controls:Controls;

    override function create() {
        super.create();

        controls = new Controls("Main");
        FlxG.inputs.addInput(controls);
    }    

    override function update(elapsed:Float) {
        super.update(elapsed);
    }
}