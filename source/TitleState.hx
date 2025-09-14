package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class TitleState extends MusicBeatState
{
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var logoBl:FlxSprite;
	var titleText:FlxSprite;

	public static var woaTransitionILoveYou:Bool = false;

	override function create()
	{
		super.create();
		if (MainMenuState.woaTransitionILoveYou)
		{
			camera.alpha = 0;
			camera.zoom = 2;
			camera.y = FlxG.height * 2;
			FlxTween.tween(camera, {y: 0, zoom: 1, alpha: 1}, 1, {
				ease: FlxEase.circOut,
			});
		}

		if (FlxG.sound.music == null || !FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music("freakyMenu/freakyMenu"));
		}
		Conductor.changeBPM(102);
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

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		camera.zoom = FlxMath.lerp(1, camera.zoom, 0.95);

		if (controls.justPressed.ACCEPT)
		{
			camera.zoom += 0.015;
			camera.flash(FlxColor.WHITE, 1, function()
			{
				FlxTween.tween(camera, {y: FlxG.height * 2, zoom: 2, alpha: 0}, 2, {
					ease: FlxEase.circIn,
					onComplete: function(tween:FlxTween)
					{
						woaTransitionILoveYou = true;
						FlxG.switchState(MainMenuState.new);
					}
				});
			});
		} 
	}
	override function beatHit()
	{
		super.beatHit();

		logoBl.animation.play('bump', true);

		danceLeft = !danceLeft;

		if (danceLeft)
			gfDance.animation.play('danceRight');
		else
			gfDance.animation.play('danceLeft');
	}
}