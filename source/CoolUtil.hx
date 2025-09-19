package;

import flixel.FlxG;
import flixel.math.FlxMath;

class CoolUtil {
	public static function camLerpShit(lerp:Float):Float
	{
		return lerp * (FlxG.elapsed / (1 / 60));
	}
    
	public static function coolLerp(a:Float, b:Float, ratio:Float):Float
	{
		return FlxMath.lerp(a, b, camLerpShit(ratio));
	}
	public static function updateFPS()
	{
		FlxG.updateFramerate = FlxG.drawFramerate = SaveData.settings.framerate;
	}
}