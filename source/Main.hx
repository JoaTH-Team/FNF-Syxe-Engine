package;

import objects.counter.DebugGame;
import flixel.util.FlxColor;
import flixel.FlxG;
import openfl.display.Sprite;
import flixel.FlxGame;

class Main extends Sprite
{
	var game:FlxGame;

	public function gameConfig()
	{
		return {
			"width": FlxG.width,
			"height": FlxG.height,
			"states": states.TitleState, // Set a State to load game
			"fps": #if html5 60 #else 144 #end,
			"introHaxe": false
		}
	}

	var debugGame:DebugGame;

	public function new()
	{
		super();

		game = new FlxGame(gameConfig().width, gameConfig().height, gameConfig().states, gameConfig().fps, gameConfig().fps, gameConfig().introHaxe, false);
		// Init Game
		addChild(game);

		debugGame = new DebugGame(10, 10, FlxColor.fromString("0xFFFFFF"), "vcr.ttf");
		addChild(debugGame);
	}
}
