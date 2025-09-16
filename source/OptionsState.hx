package;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OptionsState extends MusicBeatState
{
	var groupOptions:FlxTypedGroup<OptionsTextList>;
	var listOptions:Array<String> = [];

	var defaultOptions:Array<String> = ["Controls", "Preferences"];

	/**
	 * Some common type are support with the following work how is work:
	 * - Bool: A Toggle Check
	 * - String, Int, Float: A Selection Type with have MIN and MAX value (Should both are Dynamic for String Type)
	 */
	var prefOptions:Array<Array<String>> = [
		["Ghost tap", "Bool"],
		["Downscroll", "Bool"],
		["Accurary", "String"],
		["Frame Skip", "Int"]
	];

	var optionRanges:Map<String, Array<Dynamic>> = [
		"Accurary" => ["Simple", "Complex", "Unfair"],
		"Frame Skip" => [0, 10, 1] // min, max, step
	];
	var currentValues:Map<String, Dynamic> = new Map();
	var inPreferences:Bool = false;

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

		changeGroupSelect(null);
		loadCurrentValue();
	}

	function loadCurrentValue()
	{
		currentValues.set("Ghost tap", SaveData.settings.ghosttap);
		currentValues.set("Downscroll", SaveData.settings.downscroll);
		currentValues.set("Accurary", SaveData.settings.accuracy);
		currentValues.set("Frame Skip", SaveData.settings.frameSkip);
	}

	function changeGroupSelect(arrayList:Array<String>)
	{
		inPreferences = (arrayList != null);

		if (arrayList == null)
			listOptions = defaultOptions;
		else
		{
			listOptions = [];
			for (option in prefOptions)
			{
				var optionName = option[0];
				var optionType = option[1];
				var displayText = optionName + ": ";

				switch (optionType)
				{
					case "Bool":
						displayText += currentValues.get(optionName) ? "ENABLE" : "DISABLE";
					case "String":
						displayText += currentValues.get(optionName);
					case "Int", "Float":
						displayText += Std.string(currentValues.get(optionName));
				}

				listOptions.push(displayText);
			}
		}

		while (groupOptions.members.length > 0)
		{
			groupOptions.remove(groupOptions.members[0], true);
		}	
		
		for (i in 0...listOptions.length)
		{
			var text:OptionsTextList = new OptionsTextList(30, 0, 0, listOptions[i], 64);
			text.targetY = i;
			text.ID = i;
			text.asMenuItem = true;
			groupOptions.add(text);
		}

		curSelected = 0;
		changeSelection();
	}

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.justPressed.BACK) {
			SaveData.saveSettings();
			if (!inPreferences)
				MusicBeatState.switchStateWithTransition(MainMenuState, RIGHT);
			else
				changeGroupSelect(null);
		}
		if (controls.justPressed.ACCEPT)
		{
			if (inPreferences)
			{
				var optionData = prefOptions[curSelected];
				var optionName = optionData[0];
				var optionType = optionData[1];

				switch (optionType)
				{
					case "Bool":
						var currentValue = currentValues.get(optionName);
						currentValues.set(optionName, !currentValue);

						switch (optionName)
						{
							case "Ghost tap": SaveData.settings.ghosttap = !currentValue;
							case "Downscroll": SaveData.settings.downscroll = !currentValue;
						}
				}

				changeGroupSelect(prefOptions.map(opt -> opt[0]));
			}
			else
			{
				switch (listOptions[curSelected])
				{
					case "Preferences":
						changeGroupSelect(prefOptions.map(opt -> opt[0]));
					case "Controls":
						trace("Open controls menu");
				}
			}
		}

		if (inPreferences && (controls.justPressed.UI_LEFT || controls.justPressed.UI_RIGHT))
		{
			var optionData = prefOptions[curSelected];
			var optionName = optionData[0];
			var optionType = optionData[1];

			if ((optionType == "Int" || optionType == "Float") && optionRanges.exists(optionName))
			{
				var range = optionRanges.get(optionName);
				var min = range[0];
				var max = range[1];
				var step = range.length > 2 ? range[2] : 1;

				var currentValue = currentValues.get(optionName);
				var change = controls.justPressed.UI_LEFT ? -step : step;
				var newValue = FlxMath.bound(currentValue + change, min, max);

				if (newValue != currentValue)
				{
					currentValues.set(optionName, newValue);

					switch (optionName)
					{
						case "Frame Skip":
							SaveData.settings.frameSkip = Std.int(newValue);
					}

					changeGroupSelect(prefOptions.map(opt -> opt[0]));
				}
			}
			else if ((optionType == "String") && optionRanges.exists(optionName))
			{
				var options = optionRanges.get(optionName);
				var currentValue = currentValues.get(optionName);
				var currentIndex = options.indexOf(currentValue);

				if (currentIndex < 0)
					currentIndex = 0;

				var nextIndex = (currentIndex + 1) % options.length;
				var nextValue = options[nextIndex];
				currentValues.set(optionName, nextValue);

				switch (optionName)
				{
					case "Accurary":
						SaveData.settings.accuracy = nextValue;
				}

				changeGroupSelect(prefOptions.map(opt -> opt[0]));
			}
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