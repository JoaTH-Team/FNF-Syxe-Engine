package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import scripts.HScript;
import sys.FileSystem;

class FreeplayState extends MusicBeatState
{
	var scripts:Array<HScript> = [];
	var groupSong:FlxTypedGroup<Alphabet>;
	var listSong:Array<SongMetadata> = [];
	var curSelected:Int = 0;

    override function create() {
        super.create();
        
		var bg:FlxSprite = new FlxSprite(0, 0, Paths.image("menuDesat"));
        add(bg);
		var filePaths = [Paths.file("data/freeplay.hxs")];
		for (mod in PolymodHandler.getModIDs())
			filePaths.push(Paths.file('mods/${mod}/data/freeplay.hxs'));
		for (filePath in filePaths)
		{
			if (FileSystem.exists(filePath) && !FileSystem.isDirectory(filePath))
			{
				if (Paths.validScriptType(filePath))
				{
					try
					{
						var script = new HScript(filePath, this);
						scripts.push(script);
						trace('Loaded script: $filePath');
					}
					catch (e:Dynamic)
					{
						trace('Failed to load script: $filePath - Error: $e');
					}
				}
			}
		}

		groupSong = new FlxTypedGroup<Alphabet>();
		add(groupSong);
		for (i in 0...listSong.length)
		{
			var songTxt:Alphabet = new Alphabet(0, (70 * i) + 30, listSong[i].songName, true, false);
			songTxt.isMenuItem = true;
			songTxt.targetY = i;
			groupSong.add(songTxt);
		}

		changeSelection();
	}

	public function addSong(songName:Array<String>, iconStuff:Array<String>, isTheWholeWeek:Bool = false)
	{
		for (song in songName)
		{
			listSong.push(new SongMetadata(song, 0, iconStuff[songName.indexOf(song)]));
		}

		changeSelection();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.justPressed.BACK) {
			FlxG.sound.play(Paths.sound('menu/cancelMenu'));
            MusicBeatState.switchStateWithTransition(MainMenuState, LEFT);
        }
		if (controls.justPressed.UI_UP || controls.justPressed.UI_DOWN)
			changeSelection(controls.justPressed.UI_UP ? -1 : 1);

		if (controls.justPressed.ACCEPT)
		{
			FlxG.sound.play(Paths.sound('menu/confirmMenu'));
			var poop:String = HighScore.formatSong(listSong[curSelected].songName.toLowerCase(), 1);
			PlayState.SONG = Song.loadFromJson(poop, listSong[curSelected].songName.toLowerCase());
			MusicBeatState.switchStateWithTransition(PlayState, RIGHT);
		}
	}

	function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, listSong.length - 1);
		FlxG.sound.play(Paths.sound('menu/scrollMenu'));

		var inSelected:Int = 0;
		groupSong.forEach(function(text:Alphabet)
		{
			text.targetY = inSelected - curSelected;
			inSelected += 1;
			if (text.ID == curSelected)
			{
				text.color = FlxColor.YELLOW;
				text.alpha = 1;
			}
			else
			{
				text.color = FlxColor.WHITE;
				text.alpha = 0.5;
			}
		});
	}
}