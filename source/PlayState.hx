package;

import Song.SwagSong;
import flixel.FlxG;
import flixel.util.FlxTimer;

class PlayState extends MusicBeatState
{
	public static var SONG:SwagSong;
	var wasPauseMan:Bool = false;

	override public function create()
	{
		super.create();
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		persistentUpdate = persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);
		FlxG.sound.playMusic(Paths.formatToSongPath(SONG.song.toString()), 1);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (wasPauseMan == false && (controls.justPressed.BACK || controls.justPressed.ACCEPT))
		{
			FlxG.sound.play(Paths.sound('menu/scrollMenu'));
			wasPauseMan = true;
			openSubState(new PauseSubState());
		}
	}

	override function closeSubState()
	{
		super.closeSubState();
		FlxTimer.wait(0.1, function()
		{
			wasPauseMan = false;
		});
	}
}
