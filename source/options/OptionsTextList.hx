package options;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class OptionsTextList extends FunkinText
{
	public var asMenuItem:Bool = false;
	public var targetY:Float = 0;

	public function new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, ?Text:String, Size:Int = 8)
	{
		super(X, Y, FieldWidth, Text, Size);
		setFormat(Paths.font("phantommuff.ttf"), Size, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		setBorderStyle(OUTLINE, FlxColor.BLACK, 5, 1);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (asMenuItem)
		{
			var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);
			this.y = FlxMath.lerp(y, (scaledY * 80) + (FlxG.height * 0.48), 0.16);
			this.x = FlxMath.lerp(x, 100 + (Math.abs(targetY) * -50), 0.16);
		}
	}
}