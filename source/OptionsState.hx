package;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OptionsState extends MusicBeatState
{
	var groupOptions:FlxTypedGroup<OptionsTextList>;
	var listOptions:Array<String> = ["Controls", "Preferences"];
	var curSelected:Int = 0;

    override function create() {
        super.create();
        
        var bg:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menuDesat"));
		bg.color = 0x5D5D5D;
        add(bg);

		var optionsTitle:FunkinSprite = new FunkinSprite(FlxG.width - 575, 50);
        optionsTitle.frames = Paths.spritesheet("mainmenu/options", true, SPARROW);
        optionsTitle.addPrefix("idle", "options idle", 24, true);
		optionsTitle.playAnim("idle");
        add(optionsTitle);
		groupOptions = new FlxTypedGroup<OptionsTextList>();
		add(groupOptions);

		for (i in 0...listOptions.length)
		{
			var text:OptionsTextList = new OptionsTextList(30, 0, 0, listOptions[i], 64);
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
		if (controls.justPressed.UI_UP || controls.justPressed.UI_DOWN)
			changeSelection(controls.justPressed.UI_UP ? -1 : 1);
	}

	function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, groupOptions.length - 1);

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

class OptionsTextList extends FlxText
{
	public var asMenuItem:Bool = false;
	public var targetY:Float = 0;

	public function new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, ?Text:String, Size:Int = 8, EmbeddedFont:Bool = true)
	{
		super(X, Y, FieldWidth, Text, Size, EmbeddedFont);
		setFormat(Paths.font("vcr.ttf"), Size, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (asMenuItem)
		{
			var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);
			this.y = FlxMath.lerp(y, (scaledY * 40) + (FlxG.height * 0.48), 0.16);
		}
	}
}