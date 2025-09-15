package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

@:keep
@:access(openfl.display.BitmapData)
class FunkinSprite extends FlxSprite
{
    public var frameSkip:Int = 1;
    public var frameSkipCounter:Int = 0;

    public function new(x:Float = 0, y:Float = 0, ?graphics:FlxGraphicAsset) {
        super(x, y, graphics);

        antialiasing = SaveData.settings.antialiasing;
        frameSkip = SaveData.settings.frameSkip;

        if (antialiasing != SaveData.settings.antialiasing)
        {
            dirty = true;
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (frameSkip > 0)
        {
            frameSkipCounter++;
            if (frameSkipCounter <= frameSkip)
            {
                return;
            }
            frameSkipCounter = 0;
        }
    }
	public function addPrefix(nameAnim:String, prefix:String, fps:Int = 24, looped:Bool = false)
	{
		return this.animation.addByPrefix(nameAnim, prefix, fps, looped);
	}

	public function addIndices(Name:String, Prefix:String, Indices:Array<Int>, Postfix:String, FrameRate:Float = 30, Looped:Bool = true, FlipX:Bool = false,
			FlipY:Bool = false)
	{
		return this.animation.addByIndices(Name, Prefix, Indices, Postfix, FrameRate, Looped, FlipX, FlipY);
	}

	public function playAnim(nameAnim:String, force:Bool = false)
	{
		return this.animation.play(nameAnim, force);
	}
}