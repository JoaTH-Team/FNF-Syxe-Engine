package;

import flixel.FlxG;
import flixel.FlxSprite;

class TitleState extends MusicBeatState
{
	public function new()
	{
		super();

		PolymodHandler.reload();
	}

	var gfDance:FlxSprite;
	var dancedLeft:Bool = false;
	var logoBump:FlxSprite;

	override function create()
	{
		super.create();
		FunkinSound.playMusic(true, "freakyMenu/freakyMenu");

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.spritesheet("gfDanceTitle", true, SPARROW);
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		add(gfDance);
	}

    override function update(elapsed:Float) {
        super.update(elapsed);
		if (controls.justPressed.ACCEPT)
		{
			FlxG.switchState(PlayState.new);
		} 
    }
	override function beatHit()
	{
		super.beatHit();
		dancedLeft = !dancedLeft;

		if (dancedLeft)
			gfDance.animation.play("danceLeft", true);
		else if (!dancedLeft)
			gfDance.animation.play("danceRight", true);
	}
}