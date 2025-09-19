package;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PauseSubState extends MusicBeatSubState
{
    var groupOptions:FlxTypedGroup<Alphabet>;
    var options:Array<String> = ["Resume", "Restart", "Exit"];
    var curSelected:Int = 0;
    var wasOpenMan:Bool = true;

    override public function create()
    {
        super.create();
        
        FlxTimer.wait(0.1, function() {
            wasOpenMan = false;
        });

        groupOptions = new FlxTypedGroup<Alphabet>();
        add(groupOptions);
        for (i in 0...options.length) {
			var songTxt:Alphabet = new Alphabet(0, (70 * i) + 30, options[i], true, false);
			songTxt.isMenuItem = true;
			songTxt.targetY = i;
			groupOptions.add(songTxt);
        }

        changeSelection();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (!wasOpenMan)
        {
            if (controls.justPressed.BACK || controls.justPressed.ACCEPT) {
                FlxG.sound.play(Paths.sound('menu/scrollMenu'));
                close();
            }

            if (controls.justPressed.UI_UP || controls.justPressed.UI_DOWN) {
                changeSelection(controls.justPressed.UI_UP ? -1 : 1);
            }

            if (controls.justPressed.ACCEPT) {
                FlxG.sound.play(Paths.sound('menu/confirmMenu'));
                switch (options[curSelected]) {
                    case "Resume":
                        close();
                    case "Restart":
                        FlxG.resetState();
                    case "Exit":
                        MusicBeatState.switchStateWithTransition(MainMenuState);
                }
            }
        }
    }

    function changeSelection(change:Int = 0) {
        curSelected = FlxMath.wrap(curSelected + change, 0, options.length);
        FlxG.sound.play(Paths.sound('menu/scrollMenu'));
        
		var inSelected:Int = 0;
		groupOptions.forEach(function(text:Alphabet)
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