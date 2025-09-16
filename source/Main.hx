package;

import cataclysm.Cataclysm;
import debug.FPS;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

#if desktop
import ALSoftConfig;
#end

class Main extends Sprite
{
	public function new()
	{
		super();

		addChild(new FlxGame(0, 0, InitState, 75, 75, true, false));
		addChild(new FPS(10, 3, 0xFFFFFF));

		stage.scaleMode = NO_SCALE;

		var crash_handler:Cataclysm = new Cataclysm();
		crash_handler.setup("crashlogs", "FNF_SyxeEngineLog");
		crash_handler.onApplicationCrash = function () {
			stage.window.alert("Oh No the game crased, check out the log on the crashlogs folder!", "FNF Syxe Engine Crashed");
		};
	}
}
