package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;

class TitleState extends MusicBeatState
{
	public function new()
	{
		super();

		PolymodHandler.reload();
		setupTransition();
	}

	function setupTransition():Void
	{
		var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
			new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1), {asset: diamond, width: 32, height: 32},
			new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
	}


	var gfDance:FlxSprite;
	var dancedLeft:Bool = false;
	var logoBl:FlxSprite;
	var titleText:FlxSprite;

	override function create()
	{
		super.create();
		FunkinSound.playMusic(true, "freakyMenu/freakyMenu");
		FlxG.sound.music.fadeIn(4, 0, 0.7);
		persistentUpdate = true;

		logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.spritesheet('logoBumpin', true, SPARROW);
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		add(logoBl);

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.spritesheet("gfDanceTitle", true, SPARROW);
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
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
		logoBl.animation.play("bump", true);
	}
}