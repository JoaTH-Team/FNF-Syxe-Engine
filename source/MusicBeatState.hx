package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.sound.FlxRhythmConductor;

class MusicBeatState extends FlxState
{
	var controls:Controls;
	var curBeat:Int = 0;
	var curStep:Int = 0;

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

	override function tryUpdate(elapsed:Float)
	{
		super.tryUpdate(elapsed);
		FlxRhythmConductor.instance.update(null);

		FlxRhythmConductor.beatHit.add(function(time:Int, backward:Bool)
		{
			curBeat += time;
			beatHit();
		});

		FlxRhythmConductor.stepHit.add(function(time:Int, backward:Bool)
		{
			curStep += time;
			stepHit();
		});
	}

	public function stepHit() {}

	public function beatHit() {}
}