package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class MainMenuState extends MusicBeatState
{
	var bg:FlxSprite;
	var bgFlicker:FlxSprite;
	var groupMenu:FlxTypedGroup<FlxSprite>;
	var groupSong:Array<String> = ["storymode", "freeplay", "options", "credits"];
	var curSelected:Int = 0;

    override function create() {
        super.create();

		persistentUpdate = persistentDraw = true;
		bg = new FlxSprite(0, 0, Paths.image("menuBG"));
		add(bg);

		bgFlicker = new FlxSprite(0, 0, Paths.image("menuBGMagenta"));
		bgFlicker.alpha = 0;
		add(bgFlicker);

		groupMenu = new FlxTypedGroup<FlxSprite>();
		add(groupMenu);

		for (i in 0...groupSong.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.frames = Paths.spritesheet('mainmenu/${groupSong[i]}', true, SPARROW);
			menuItem.animation.addByPrefix('idle', groupSong[i] + " idle", 24);
			menuItem.animation.addByPrefix('selected', groupSong[i] + " selected", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItem.x -= 255;
			menuItem.scrollFactor.set();
			groupMenu.add(menuItem);
		}

		changeSelection();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
		if (controls.justPressed.BACK)
		{
			TransitionState.switchStateWithTransition(TitleState);
		}

		if (controls.justPressed.UI_UP || controls.justPressed.UI_DOWN)
			changeSelection(controls.justPressed.UI_UP ? -1 : 1);
	}

	function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, groupSong.length - 1);

		groupMenu.forEach(function(sprite:FlxSprite)
		{
			sprite.animation.play("idle");
			if (curSelected == sprite.ID)
			{
				sprite.animation.play("selected");
			}
		});
    }
}