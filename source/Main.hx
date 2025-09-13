package;

import cataclysm.Cataclysm;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

#if desktop
import ALSoftConfig;
#end

class Main extends Sprite
{
	public function new()
	{
		super();
		SaveData.init();

		addChild(new FlxGame(0, 0, TitleState, 75, 75, true, false));
		addChild(new FPS(10, 3, 0xFFFFFF));

		var crash_handler:Cataclysm = new Cataclysm();
		crash_handler.setup("crashlogs", "FNF_SyxeEngineLog");
		crash_handler.onApplicationCrash = function () {
			stage.window.alert("Oh No the game crased, check out the log on the crashlogs folder!", "FNF Syxe Engine Crashed");
		};
	}
}
