package backend.game;

import flixel.FlxBasic;
import flixel.FlxG;

class FunkGame
{
	public static function doTimer(time:Float = 1, whenComplete:Dynamic)
		return new FunkTimer(true, time, whenComplete());
}
