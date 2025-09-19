package options;

import flixel.FlxG;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class OptionsState extends MusicBeatState
{
    var groupOptions:FlxTypedGroup<OptionsTextList>;
	var listOptions:Array<String> = ["Preferences", "Controls"];
    var curSelected:Int = 0;

    override function create() {
        super.create();
    
        var bg:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menuDesat"));
		bg.color = 0x5D5D5D;
        add(bg);

		var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
		grid.velocity.set(40, 40);
		add(grid);

		var optionsTitle:FunkinSprite = new FunkinSprite(FlxG.width - 575, 50);
        optionsTitle.frames = Paths.spritesheet("mainmenu/options", true, SPARROW);
        optionsTitle.addPrefix("idle", "options idle", 24, true);
		optionsTitle.playAnim("idle");
        add(optionsTitle);

        groupOptions = new FlxTypedGroup<OptionsTextList>();
        add(groupOptions);

		for (i in 0...listOptions.length)
		{
			var text:OptionsTextList = new OptionsTextList(100, 0, 0, listOptions[i], 64);
			text.targetY = i;
			text.ID = i;
			text.asMenuItem = true;
			groupOptions.add(text);
		}

        changeSelection();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.justPressed.BACK) {
			SaveData.saveSettings();
			MusicBeatState.switchStateWithTransition(MainMenuState, RIGHT);
		}

        if (controls.justPressed.ACCEPT) {
			FlxG.sound.play(Paths.sound('menu/confirmMenu'));
            switch (listOptions[curSelected])
            {
                case "Preferences":
                    openSubState(new OptionsPreferencesSubState());
                case "Controls":
                    openSubState(new OptionsControlsSubState());
            }
        }

		if (controls.justPressed.UI_UP || controls.justPressed.UI_DOWN)
			changeSelection(controls.justPressed.UI_UP ? -1 : 1);
    }

    function changeSelection(change:Int = 0) {
		curSelected = FlxMath.wrap(curSelected + change, 0, groupOptions.length - 1);
		FlxG.sound.play(Paths.sound('menu/scrollMenu'));

		var inSelected:Int = 0;
		groupOptions.forEach(function(text:OptionsTextList)
		{
			text.targetY = inSelected - curSelected;
			inSelected += 1;
			if (text.ID == curSelected)
			{
				text.color = FlxColor.YELLOW;
				text.alpha = 1;
			}
			else
			{
				text.color = FlxColor.WHITE;
				text.alpha = 0.5;
			}
		});
    }
}