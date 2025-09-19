package;

import Song.SwagSong;
import flixel.FlxG;

class PlayState extends MusicBeatState
{
	public static var SONG:SwagSong;

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
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
