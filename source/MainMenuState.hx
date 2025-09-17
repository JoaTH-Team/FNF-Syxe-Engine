package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;

class MainMenuState extends MusicBeatState
{
	var bg:FunkinSprite;
	var bgFlicker:FunkinSprite;
	var groupMenu:FlxTypedGroup<FunkinSprite>;
	var groupSong:Array<String> = ["storymode", "freeplay", "options", "credits"];

	var curSelected:Int = 0;

    override function create() {
        super.create();

		DiscordClient.updatePresence("On Menu");

		persistentUpdate = persistentDraw = true;
		bg = new FunkinSprite(0, 0, Paths.image("menuBG"));
		add(bg);

		bgFlicker = new FunkinSprite(0, 0, Paths.image("menuBGMagenta"));
		bgFlicker.alpha = 0;
		add(bgFlicker);

		groupMenu = new FlxTypedGroup<FunkinSprite>();
		add(groupMenu);

		for (i in 0...groupSong.length)
		{
			var menuItem:FunkinSprite = new FunkinSprite(0, 60 + (i * 160));
			menuItem.frames = Paths.spritesheet('mainmenu/${groupSong[i]}', true, SPARROW);
			menuItem.addPrefix('idle', groupSong[i] + " idle", 24, true);
			menuItem.addPrefix('selected', groupSong[i] + " selected", 24, true);
			menuItem.playAnim('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItem.x -= 275;
			menuItem.scrollFactor.set();
			groupMenu.add(menuItem);
		}

		changeSelection();
    }

    override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.justPressed.BACK)
		{
			MusicBeatState.switchStateWithTransition(TitleState);
		}

		if (controls.justPressed.UI_UP || controls.justPressed.UI_DOWN)
			changeSelection(controls.justPressed.UI_UP ? -1 : 1);
		if (controls.justPressed.ACCEPT)
		{
			switch (groupSong[curSelected])
			{
				case "options":
					MusicBeatState.switchStateWithTransition(OptionsState, LEFT);
				case "credits":
					MusicBeatState.switchStateWithTransition(CreditsState);
			}
		}
	}

	function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, groupSong.length - 1);

		groupMenu.forEach(function(sprite:FunkinSprite)
		{
			sprite.animation.play("idle");
			if (curSelected == sprite.ID)
			{
				sprite.animation.play("selected");
			}
		});
    }
}