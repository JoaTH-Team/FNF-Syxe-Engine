package states;

import backend.chart.Conductor;
import flixel.util.FlxColor;
import flixel.FlxG;
import backend.game.FunkGame;
import backend.game.FunkSprite;
import openfl.Assets;
import backend.CoolUtil;

typedef TitleData =
{
	var gfPos:Array<Float>;
	var titlePos:Array<Float>;
	var logoPos:Array<Float>;
}

class TitleState extends MusicBeatState
{
	var titleData:TitleData;

	override function create()
	{
		super.create();

		FunkGame.doTimer(1, function()
		{
			initThing();
		});
	}

	function initThing():Void
	{
		// Init modding system
		#if MOD_ALLOW
		backend.PolyHandler.reload();
		#end

		// Init JSON
		titleData = cast tjson.TJSON.parse(Assets.getText(Paths.data("titleJson.json")));

		FunkGame.doTimer(1, function()
		{
			startIntro();
		});
	}

	var dancedLeft:Bool = true;
	var gfDance:FunkSprite;
	var titleText:FunkSprite;

	function startIntro():Void
	{
		FlxG.sound.playMusic(Paths.music("freakyMenu/freakyMenu"));
		Conductor.changeBPM(102);

		gfDance = new FunkSprite(titleData.gfPos[0], titleData.gfPos[1]);
		gfDance.frames = Paths.getSparrowAtlas("gfDanceTitle");
		gfDance.quickAddIncAnim("danceLeft", "gfDance", CoolUtil.genNumFromTo(0, 14));
		gfDance.quickAddIncAnim("danceRight", "gfDance", CoolUtil.genNumFromTo(15, 30));
		add(gfDance);

		titleText = new FunkSprite(titleData.titlePos[0], titleData.titlePos[1]);
		titleText.frames = Paths.getSparrowAtlas("titleEnter");
		titleText.quickAddPrefixAnim("idle", "Press Enter to Begin", true);
		titleText.quickAddPrefixAnim("pressed", "ENTER PRESSED", true);
		titleText.playAnim("idle", true);
		add(titleText);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);

		if (Controls.justPressed("accept"))
		{
			FlxG.sound.play(Paths.sound('menu/confirmMenu'));
			titleText.playAnim("pressed", true);
			camera.flash(FlxColor.WHITE, 2, function()
			{
				FlxG.switchState(() -> new MainMenuState());
			});
		}
	}

	override function beatHit()
	{
		super.beatHit();
		dancedLeft = !dancedLeft;

		gfDance.playAnim((dancedLeft ? "danceLeft" : "danceRight"));
	}
}
