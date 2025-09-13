package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.sound.FlxRhythmConductor;

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
	override function create()
	{
		super.create();

		Paths.clearUnusedMemory();
		Paths.clearStoredMemory();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
	
		stepHit();
	}

	public function stepHit()
	{
		if (FlxRhythmConductor.instance.currentStep % 4 == 0)
			beatHit();
	}

	public function beatHit() {}
}