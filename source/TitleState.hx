package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class TitleState extends MusicBeatState
{
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var logoBl:FlxSprite;
	var titleText:FlxSprite;

	override function create()
	{
		super.create();

		if (FlxG.sound.music == null || !FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu/freakyMenu'), 0);
			FlxG.sound.music.fadeIn(4, 0, 0.7);
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
			camera.zoom += 0.135;
			camera.flash(FlxColor.WHITE, 1, function()
			{
				MusicBeatState.switchStateWithTransition(MainMenuState);
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
		camera.zoom += 0.135;
	}
}