package;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class CreditsState extends MusicBeatState
{
    var groupCredits:FlxTypedGroup<Alphabet>;
    var creditsList:Array<String> = ["Huy1234TH"];
    var curSelected:Int = 0;

    override function create() {
        super.create();

        var bg:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menuDesat"));
		bg.color = 0x4C9DDA;
        add(bg);

		var creditsTitle:FunkinSprite = new FunkinSprite(FlxG.width - 575, 50);
        creditsTitle.frames = Paths.spritesheet("mainmenu/credits", true, SPARROW);
        creditsTitle.addPrefix("idle", "credits idle", 24, true);
		creditsTitle.playAnim("idle");
        add(creditsTitle);

        groupCredits = new FlxTypedGroup<Alphabet>();
        add(groupCredits);

        for (i in 0...creditsList.length)
        {
			var textCredits:Alphabet = new Alphabet(0, (70 * i) + 30, creditsList[i], true, false);
			textCredits.isMenuItem = true;
			textCredits.targetY = i;
			groupCredits.add(textCredits);
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.justPressed.BACK) {
            MusicBeatState.switchStateWithTransition(MainMenuState, DOWN);
        }

		if (controls.justPressed.UI_UP || controls.justPressed.UI_DOWN)
			changeSelection(controls.justPressed.UI_UP ? -1 : 1);

        if (controls.justPressed.ACCEPT) {

        }
    }

    function changeSelection(change:Int = 0) {
        curSelected = FlxMath.wrap(curSelected + change, 0, creditsList.length - 1);
		var inSelected:Int = 0;
		groupCredits.forEach(function(text:Alphabet)
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