package;

import flixel.FlxG;
import flixel.FlxState;

class MusicBeatState extends FlxState
{
	var controls:Controls;

	public function new()
	{
		super();

		// Controls Added
		controls = new Controls("Main");
		FlxG.inputs.addInput(controls);
    }
}