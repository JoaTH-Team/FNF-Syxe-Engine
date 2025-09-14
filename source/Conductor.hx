package;

import flixel.FlxG;
import flixel.util.FlxSignal.FlxTypedSignal;

typedef BPMChangeEvent = {
	var bpm:Float;
	var songPos:Float;
	var songOffset:Float;
	var stepsPerBeat:Int;
	var beatsPerMeasure:Int;
}

@:nullSafety
class Conductor
{
	/**
	 * Default values for: BPM, Song Offset, Steps Per Beat, Beats Per Measure
	 **/
	private final D_BPM:Float = 100.0;
	private final D_SONG_OFFSET:Float = 0.0;
	private final D_STEPS_PER_BEAT:Int = 4;
	private final D_BEATS_PER_MEASURE:Int = 4;

	/**
	 * Values needed for calculatung Steps, Beats and Measures
	 **/
	private var _bpm:Float = 0;
	private var _crochet:Float = 0;
	private var _stepCrochet:Float = 0;

	/**
	 * Song Time
	 **/
	private var _songPos:Float = 0;

	/**
	 * Read var's name, Teapot
	 **/
	private var step:Int = 0;
	private var beat:Int = 0;
	private var measure:Int = 0;

	/**
	 * Saves when BPM has been changed
	 **/
	private var bpmChanges:Array<BPMChangeEvent> = [];

	/**
	 * Getters/Setter for BPM, Crochet, Step Crochet and Song Time
	 **/
	public var bpm(get, never):Float;
	public var crochet(get, never):Float;
	public var stepCrochet(get, never):Float;
	public var songPos(get, never):Float;

	/**
	 * Offset for calculates
	 **/
	public var songOffset:Float = 0;

	/**
	 * Steps Per Beat: Amount of Steps in ONE Beat
	 * Beats Per Measure: Amount of Beats in ONE Measure
	 *
	 * If Steps Per Beat is 5 and Beats Per Measure is 4 then Amount of Steps in Measure is 20
	 **/
	public var stepsPerBeat:Int = 0;
	public var beatsPerMeasure:Int = 0;

	/**
	 * Signals that runs stepHit(), beatHit() and measureHit() in all MusicBeatState's and MusicBeatSubState's subclasses
	 **/
	public var onStep:FlxTypedSignal<Int -> Void>;
	public var onBeat:FlxTypedSignal<Int -> Void>;
	public var onMeasure:FlxTypedSignal<Int -> Void>;

	/**
	 * Preverents from updating when in pause menu
	 **/
	public var inPause:Bool = false;

	/**
	 * Getters and BPM's Setter
	 **/
	inline public function get_bpm():Float
		return _bpm;

	inline function set_bpm(value:Float):Float
	{
		_bpm = value <= 0 ? D_BPM : value;
		_crochet = ((60 / _bpm) * 1000);
		_stepCrochet = (_crochet / stepsPerBeat);
		
		return _bpm;
	}

	inline function get_crochet():Float
		return _crochet;

	inline function get_stepCrochet():Float
		return _stepCrochet;

	inline public function get_songPos():Float
		return _songPos;

	/**
	 * Constructor
	 **/
	public function new(?bpm:Float, ?stepsPerBeat:Int, ?beatsPerMeasure:Int, ?songOffset:Float)
	{
		this.stepsPerBeat = stepsPerBeat ?? D_STEPS_PER_BEAT;
		this.beatsPerMeasure = beatsPerMeasure ?? D_BEATS_PER_MEASURE;
		this.songOffset = songOffset ?? D_SONG_OFFSET;
		
		onStep = new FlxTypedSignal<Int -> Void>();
		onBeat = new FlxTypedSignal<Int -> Void>();
		onMeasure = new FlxTypedSignal<Int -> Void>();
		
		set_bpm(bpm ?? D_BPM);
		
		step = 0;
		beat = 0;
		measure = 0;
	}

	/**
	 * BPM's Refresher (saves BPM change event before changing value and recalculating of crochets)
	 **/
	public function refreshBPM(value:Float):Float
	{
		var change:BPMChangeEvent = {
			bpm: _bpm,
			songPos: _songPos,
			songOffset: songOffset,
			stepsPerBeat: stepsPerBeat,
			beatsPerMeasure: beatsPerMeasure
		}
		
		bpmChanges.push(change);
		
		set_bpm(value);
		
		return _bpm;
	}

	/**
	 * Conductor's Updater (won't work in Pause Menu (if use "inPause") or when music is missing)
	 **/
	public function update(time:Float):Void
	{
		if(inPause || FlxG.sound.music == null)
			return;
		
		_songPos = time + songOffset;
		
		final _step:Int = Math.floor(_songPos / stepCrochet);
		if(_step == step)
			return;
		
		step = _step;
		onStep.dispatch(step);
		
		final _beat:Int = Math.floor(step / stepsPerBeat);
		if(_beat != beat)
		{
			beat = _beat;
			onBeat.dispatch(beat);
			
			final _measure:Int = Math.floor(beat / beatsPerMeasure);
			if(_measure != measure)
			{
				measure = _measure;
				onMeasure.dispatch(measure);
			}
		}
	}

	/**
	 * reset(): Resets to default value (0 and empty array) some variables
	 * destroy(): Destroys this object
	 **/
	public function reset():Void
	{
		bpmChanges = [];
		inPause = false;
		step = 0;
		beat = 0;
		measure = 0;
	}

	public function destroy():Void
	{
		bpmChanges = [];
		onStep.destroy();
		onBeat.destroy();
		onMeasure.destroy();
	}

	/**
	 * Convertors
	 * P.S. Read function's name, Teapot
	 **/
	public function timeToStep(value:Float):Int
		return Math.floor(value / stepCrochet);

	public function timeToBeat(value:Float):Int
		return Math.floor(timeToStep(value) / stepsPerBeat);

	public function timeToMeasure(value:Float):Int
		return Math.floor(timeToBeat(value) / beatsPerMeasure);

	public function stepToTime(value:Int):Float
		return (value * _stepCrochet);

	public function beatToTime(value:Int):Float
		return (value * _crochet);

	public function measureToTime(value:Int):Float
		return ((value * _crochet) * beatsPerMeasure);

	/**
	 * Finds an BPM value at pos (@param value)
	 * Used Binary Search
	 **/
	public function bpmAtPos(value: Float):Float
	{
		if(bpmChanges.length == 0)
			return D_BPM;
		
		bpmChanges.sort((a, b) -> a.songPos < b.songPos ? -1 : 1);
		
		var low:Int = 0;
		var high:Int = bpmChanges.length;
		
		while(low < high)
		{
			var mid:Int = (low + high) >> 1;
			if(bpmChanges[mid].songPos <= value)
				low = mid + 1;
			else
				high = mid;
		}
		
		return low > 0 ? bpmChanges[low - 1].bpm : D_BPM;
	}
}