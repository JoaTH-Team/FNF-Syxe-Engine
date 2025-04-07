package states;

import flixel.group.FlxGroup.FlxTypedGroup;
import backend.game.FunkSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.text.FlxText;

class MainMenuState extends MusicBeatState
{
	var versionText:FlxText;
	var magenta:FunkSprite;
	var camFollow:FlxObject;

	var menuItems:FlxTypedGroup<FunkSprite>;
	var menuArray:Array<String> = ["storymode", "freeplay", "options", "credits"];
	var curSelected:Int = 0;

	override function create()
	{
		super.create();

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music("freakyMenu/freakyMenu"));
		}

		var bg:FunkSprite = new FunkSprite(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.17;
		bg.setGraphicSize(Std.int(bg.width * 1.2));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FunkSprite(Paths.image('menuDesat'));
		magenta.scrollFactor.x = bg.scrollFactor.x;
		magenta.scrollFactor.y = bg.scrollFactor.y;
		magenta.setGraphicSize(Std.int(bg.width));
		magenta.updateHitbox();
		magenta.x = bg.x;
		magenta.y = bg.y;
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);

		menuItems = new FlxTypedGroup<FunkSprite>();
		add(menuItems);

		var maxHeight:Float = openfl.Lib.current.stage.stageHeight - 120;
		var totalHeight:Float = menuArray.length * 180;
		var scale:Float = totalHeight > maxHeight ? maxHeight / totalHeight : 1;

		for (i in 0...menuArray.length)
		{
			var menuItem:FunkSprite = new FunkSprite(0, 60 + (i * 160 * scale));
			menuItem.frames = Paths.getSparrowAtlas("mainmenu/" + menuArray[i]);
			menuItem.quickAddPrefixAnim("idle", '${menuArray[i]} idle', true);
			menuItem.quickAddPrefixAnim("selected", '${menuArray[i]} selected', true);
			menuItem.scale.set(scale, scale);
			menuItem.screenCenter(X);
			menuItem.ID = i;
			menuItem.scrollFactor.set();
			menuItems.add(menuItem);
		}

		camFollow = new FlxObject(0, 0, 1, 1);
		FlxG.camera.follow(camFollow, LOCKON, 0.14);
		add(camFollow);

		versionText = new FlxText(10, FlxG.height - 24, 0, "FNF Syxe Engine v" + FlxG.stage.application.meta.get("version"), 12);
		versionText.scrollFactor.set();
		add(versionText);

		changeItem();
	}

	var justPressedSomething:Bool = false;

	override function update(elapsed:Float)
	{
		if (Controls.justPressed("up") || Controls.justPressed("down"))
		{
			if (!justPressedSomething)
				changeItem(Controls.justPressed("up") ? -1 : 1);
		}

		if (Controls.justPressed("accept"))
		{
			justPressedSomething = true;
			switch (curSelected)
			{
				case 0:
					FlxG.switchState(() -> new StoryMenuState());
				case 1:
					FlxG.switchState(() -> new FreeplayState());
			}
		}

		if (FlxG.keys.justPressed.SEVEN)
			FlxG.switchState(() -> new states.test.DaCharacter());

		super.update(elapsed);
		menuItems.forEach(function(spr:FunkSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;
		FlxG.sound.play(Paths.sound('menu/scrollMenu'));

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FunkSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
