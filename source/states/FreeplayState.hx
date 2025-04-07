package states;

import backend.HighScore;
import backend.chart.Song;
import backend.CoolUtil;
import flixel.math.FlxMath;
import openfl.Assets;
import sys.FileSystem;
import objects.Alphabet;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import objects.HealthIcon;
import backend.chart.SongMetaData;
import backend.game.FunkSprite;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetaData> = [];
	var groupSong:FlxTypedGroup<Alphabet>;
	var iconArray:Array<HealthIcon> = [];
	var bg:FunkSprite;
	var coolColors:Array<String> = [];
	var scoreBG:FunkSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Float = 0;
	var intendedScore:Int = 0;

	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	override function create()
	{
		super.create();

		bg = new FunkSprite(0, 0, Paths.image("menuDesat"));
		bg.scrollFactor.set();
		add(bg);

		loadWeek();

		groupSong = new FlxTypedGroup<Alphabet>();
		add(groupSong);

		for (i in 0...songs.length)
		{
			var text:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			text.isMenuItem = true;
			text.targetY = i;
			groupSong.add(text);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = text;
			iconArray.push(icon);
			add(icon);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		scoreBG = new FunkSprite(scoreText.x - 6, 0);
		scoreBG.makeGraphic(1, 66, 0x99000000);
		scoreBG.antialiasing = false;
		add(scoreBG);
		add(scoreText);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
		add(diffText);
	}

	function loadWeek():Void
	{
		var weekFiles = FileSystem.readDirectory(Paths.data("weeks/"));
		for (week in weekFiles)
		{
			if (week.endsWith(".txt"))
			{
				var weekData = Assets.getText(Paths.data("weeks/" + week));
				var weekLines = weekData.split("\n");
				var iconsArray:Array<String> = [];
				for (line in weekLines)
				{
					var lineData = line.split("::");
					if (line == "" || line.startsWith("#"))
						continue;
					switch (lineData[0])
					{
						case "freeplay_icon":
							iconsArray.push(lineData[1].split(',').join(','));
						case "song":
							addWeek(lineData[1].split(","), 1, iconsArray);
					}
				}
			}
		}
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String)
		songs.push(new SongMetaData(songName, weekNum, songCharacter));

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Controls.justPressed("exit"))
			FlxG.switchState(() -> new MainMenuState());

		if (Controls.justPressed("up") || Controls.justPressed("down"))
			changeSelection(Controls.justPressed("up") ? -1 : 1);

		if (Controls.justPressed("accept"))
		{
			PlayState.SONG = Song.loadFromJson(HighScore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty),
				songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			LoadingState.loadAndSwitchState(new PlayState(), true);
		}

		scoreText.text = "Score: " + CoolUtil.coolLerp(lerpScore, intendedScore, 0.1);
		diffText.text = "Difficulty: " + Std.string(curDifficulty);
	}

	function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, songs.length - 1);
		FlxG.sound.play(Paths.sound('menu/scrollMenu'));

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}
		iconArray[curSelected].alpha = 1;
		var bullShit:Int = 0;
		for (item in groupSong.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	override function beatHit()
	{
		super.beatHit();
	}
}
