package debug;

import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class CharacterTest extends MusicBeatState
{
    var char:Character;
	var listAnim:Array<String> = [];
	var animTxt:FunkinText;
	var curSelected:Int = 0;

    override function create() {
        super.create();

        char = new Character(0, 0);
        char.screenCenter();
        add(char);
		@:privateAccess
		if (char.animation != null)
		{
			for (anim in char.animation._animations.keys())
			{
				// Filter out null/empty animations and special animations like "danceLeft"
				if (anim != null && anim != "")
					listAnim.push(anim);
			}
		}

		// Sort animations alphabetically for better organization
		listAnim.sort(function(a, b)
		{
			a = a.toLowerCase();
			b = b.toLowerCase();
			if (a < b)
				return -1;
			if (a > b)
				return 1;
			return 0;
		});

		animTxt = new FunkinText(30, 30, 0, "", 24);
		add(animTxt);

		changeSelection(0);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.justPressed.BACK)
            MusicBeatState.switchStateWithTransition(MainMenuState);
		if (controls.justPressed.UI_UP || controls.justPressed.UI_DOWN)
		{
			changeSelection(controls.justPressed.UI_UP ? -1 : 1);
		}
	}

	function changeSelection(change:Int = 0)
	{
		if (listAnim.length == 0)
			return;

		curSelected = FlxMath.wrap(curSelected + change, 0, listAnim.length - 1);
		char.playAnim(listAnim[curSelected], true);
		FlxG.sound.play(Paths.sound('menu/scrollMenu'));

		var text = "CURRENT ANIMATION: " + listAnim[curSelected];
		text += "\n\nUse UP/DOWN to navigate";
		text += "\n\nAnimations List:";

		// Show all animations with the current one highlighted
		for (i in 0...listAnim.length)
		{
			if (i == curSelected)
			{
				text += "\n> " + listAnim[i] + " <";
			}
			else
			{
				text += "\n  " + listAnim[i];
			}
		}

		animTxt.text = text;
    }
}