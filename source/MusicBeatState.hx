package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxUIState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

enum TransitionDirection
{
	UP;
	DOWN;
	LEFT;
	RIGHT;
}

class MusicBeatState extends FlxUIState
{
	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls:Controls;

	// Transition variables
	public static var transitionInProgress:Bool = false;
	public static var nextState:Class<FlxState>;
	public static var transitionDirection:TransitionDirection = UP;
	public static var transitionDuration:Float = 1.0;
	public static var transitionZoom:Float = 2.0;

	public function new()
	{
		super();
		controls = new Controls("Main");
		FlxG.inputs.addInput(controls);
	}

	override function create()
	{
		if (transIn != null)
			trace('reg ' + transIn.region);

		super.create();
		if (transitionInProgress)
		{
			applyEnterTransition();
		}
	}

	override function update(elapsed:Float)
	{
		Conductor.update(elapsed);

		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep >= 0)
			stepHit();

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}

		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void {}

	function applyEnterTransition()
	{
		switch (transitionDirection)
		{
			case UP:
				camera.y = FlxG.height * 2;
			case DOWN:
				camera.y = -FlxG.height * 2;
			case LEFT:
				camera.x = FlxG.width * 2;
			case RIGHT:
				camera.x = -FlxG.width * 2;
		}

		camera.alpha = 0;
		camera.zoom = transitionZoom;

		var targetX:Float = 0;
		var targetY:Float = 0;

		FlxTween.tween(camera, {
			x: targetX,
			y: targetY,
			zoom: 1,
			alpha: 1
		}, transitionDuration, {
			ease: FlxEase.circOut,
			onComplete: function(tween:FlxTween)
			{
				transitionInProgress = false;
			}
		});
	}

	public static function switchStateWithTransition(targetState:Class<FlxState>, direction:TransitionDirection = UP, duration:Float = 1.0, zoom:Float = 2.0)
	{
		transitionInProgress = true;
		nextState = targetState;
		transitionDirection = direction;
		transitionDuration = duration;
		transitionZoom = zoom;

		applyExitTransition();
	}

	static function applyExitTransition()
	{
		var targetX:Float = 0;
		var targetY:Float = 0;

		switch (transitionDirection)
		{
			case UP:
				targetY = -FlxG.height * 2;
			case DOWN:
				targetY = FlxG.height * 2;
			case LEFT:
				targetX = -FlxG.width * 2;
			case RIGHT:
				targetX = FlxG.width * 2;
		}

		FlxTween.tween(FlxG.camera, {
			x: targetX,
			y: targetY,
			zoom: transitionZoom,
			alpha: 0
		}, transitionDuration, {
			ease: FlxEase.circIn,
			onComplete: function(tween:FlxTween)
			{
				FlxG.switchState(() -> Type.createInstance(nextState, []));
			}
		});
	}
}