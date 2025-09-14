package states;

import Conductor;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.addons.ui.FlxUISubState;

class MusicBeatSubState extends FlxUISubState
{
	public var Conductor:Conductor = new Conductor();

	var controls:Controls;

	public function new() {
		super();
		controls = new Controls("Main");
		FlxG.inputs.addInput(controls);
	}

	override function create():Void
	{
		super.create();
		
		Conductor.onStep.add(this.stepHit);
		Conductor.onBeat.add(this.beatHit);
		Conductor.onMeasure.add(this.measureHit);
	}

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		Conductor.update(FlxG.sound.music.time);
	}

	public override function destroy():Void
	{
		Conductor.onStep.remove(this.stepHit);
		Conductor.onBeat.remove(this.beatHit);
		Conductor.onMeasure.remove(this.measureHit);
		
		super.destroy();
	}

	public function reload():Void
		FlxG.resetState();

	public static function switchSubState(target:FlxSubState):Void
	{
		this.close();
		this._parentState.openSubState(target);
	}

	public function stepHit(step:Int):Void {}
	public function beatHit(beat:Int):Void {}
	public function measureHit(measure:Int):Void {}
}