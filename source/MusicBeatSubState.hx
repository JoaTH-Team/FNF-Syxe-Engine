package;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.addons.sound.FlxRhythmConductor;

class MusicBeatSubState extends FlxSubState
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

	override function tryUpdate(elapsed:Float)
	{
		super.tryUpdate(elapsed);
		FlxRhythmConductor.instance.update(null);
	}

	public function stepHit() {}

	public function beatHit() {}
}