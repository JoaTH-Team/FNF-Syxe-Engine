package;

import flixel.text.FlxText;
import flixel.util.FlxColor;

class FunkinText extends FlxText
{
    public function new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, ?Text:String, Size:Int = 8) {
        super(X, Y, FieldWidth, Text, Size);

        antialiasing = SaveData.settings.antialiasing;
		setFormat(Paths.font("vcr.ttf"), Size, FlxColor.WHITE, OUTLINE, FlxColor.BLACK);
    }
}