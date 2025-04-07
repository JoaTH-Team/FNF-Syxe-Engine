package backend.state;

import backend.chart.Conductor.BPMChangeEvent;
import backend.chart.Conductor;
import backend.game.FunkGame;
import flixel.addons.ui.FlxUIState;

class MusicBeatState extends FlxUIState
{
	var curBeat:Int = 0;
	var curStep:Int = 0;

	override function create()
	{
		super.create();

		Paths.cleanMemory();
		FunkGame.clearVariable();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();
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

	public function stepHit()
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit() {}
}