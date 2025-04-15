package;

import haxe.CallStack;
import openfl.events.UncaughtErrorEvent;
import sys.FileSystem;
import sys.io.File;
import openfl.Lib;
import objects.counter.DebugGame;
import flixel.util.FlxColor;
import flixel.FlxG;
import openfl.display.Sprite;
import flixel.FlxGame;

using StringTools;

class Main extends Sprite
{
	var game:FlxGame;

	public function gameConfig()
	{
		return {
			"width": FlxG.width,
			"height": FlxG.height,
			"states": states.TitleState, // Set a State to load game
			"fps": #if html5 60 #else 120 #end,
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

		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, (e:UncaughtErrorEvent) -> {
			var stack:Array<String> = [];
			stack.push(e.error);

			for (stackItem in CallStack.exceptionStack(true)) {
				switch (stackItem) {
					case CFunction:
						stack.push('C Function');
					case Module(m):
						stack.push('Module ($m)');
					case FilePos(s, file, line, column):
						stack.push('$file (line $line)');
					case Method(classname, method):
						stack.push('$classname (method $method)');
					case LocalFunction(name):
						stack.push('Local Function ($name)');
				}
			}

			e.preventDefault();
			e.stopPropagation();
			e.stopImmediatePropagation();

			final msg:String = stack.join('\n');

			#if sys
			try {
				if (!FileSystem.exists('./crash/'))
					FileSystem.createDirectory('./crash/');

				File.saveContent('./crash/'
					+ Lib.application.meta.get('file')
					+ '-'
					+ Date.now().toString().replace(' ', '-').replace(':', "'")
					+ '.txt',
					msg
					+ '\n');
			} catch (e:Dynamic) {
				Sys.println("Error!\nCouldn't save the crash dump because:\n" + e);
			}
			#end

			#if (flixel < "6.0.0")
			FlxG.bitmap.dumpCache();
			#end
			FlxG.bitmap.clearCache();

			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();

			FlxG.sound.play(Paths.sound('error'));

			Lib.application.window.alert('Uncaught Error: \n'
				+ msg
				+ '\n\nIf you think this shouldn\'t have happened, report this error to GitHub repository!\nhttps://github.com/Joalor64GH/Rhythmo-SC/issues',
				'Error!');
			Sys.println('Uncaught Error: \n' + msg
				+ '\n\nIf you think this shouldn\'t have happened, report this error to GitHub repository!\nhttps://github.com/Joalor64GH/Rhythmo-SC/issues');
			Sys.exit(1);
		});
	}
}
