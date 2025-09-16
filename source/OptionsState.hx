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
		["Antialiasing", "Bool"],
		["Accurary", "String"],
		["Frame Skip", "Int"],
		["Transition Type", "String"]
	];

	var optionRanges:Map<String, Array<Dynamic>> = [
		"Accurary" => ["Simple", "Complex", "Unfair"],
		"Frame Skip" => [0, 2, 1], // min, max, step
		"Transition Type" => ["Default", "Single", "None"]
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
		currentValues.set("Antialiasing", SaveData.settings.antialiasing);
		currentValues.set("Accurary", SaveData.settings.accuracy);
		currentValues.set("Frame Skip", SaveData.settings.frameSkip);
		currentValues.set("Transition Type", SaveData.settings.transitionType);
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

		groupOptions.clear();
		
		for (i in 0...listOptions.length)
		{
			var text:OptionsTextList = new OptionsTextList(100, 0, 0, listOptions[i], 64);
			text.targetY = i;
			text.ID = i;
			text.asMenuItem = true;
			groupOptions.add(text);
		}

		curSelected = 0;
		changeSelection();
	}

	function refreshList()
	{
		for (i in 0...groupOptions.length)
		{
			if (i < listOptions.length)
			{
				var optionData = prefOptions[i];
				var optionName = optionData[0];
				var optionType = optionData[1];
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

				groupOptions.members[i].text = displayText;
			}
		}
	}

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.justPressed.BACK) {
			SaveData.saveSettings();

			if (!inPreferences)
			{
				MusicBeatState.switchStateWithTransition(MainMenuState, RIGHT);
			}
			else
			{
				inPreferences = false;
				changeGroupSelect(null);
			}
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
							case "Antialiasing": SaveData.settings.antialiasing = !currentValue;
						}
				}

				refreshList();
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

					refreshList();
				}
			}
			else if ((optionType == "String") && optionRanges.exists(optionName))
			{
				var options = optionRanges.get(optionName);
				var currentValue = currentValues.get(optionName);
				var currentIndex = options.indexOf(currentValue);

				if (currentIndex < 0)
					currentIndex = 0;

				var nextIndex:Int = 0;
				nextIndex = FlxMath.wrap(currentIndex + (controls.justPressed.UI_LEFT ? -1 : 1), 0, options.length - 1);

				var nextValue = options[nextIndex];
				currentValues.set(optionName, nextValue);

				switch (optionName)
				{
					case "Accurary":
						SaveData.settings.accuracy = nextValue;
					case "Transition Type":
						SaveData.settings.transitionType = nextValue;
				}

				refreshList();
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
		setFormat(Paths.font("phantommuff.ttf"), Size, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		setBorderStyle(OUTLINE, FlxColor.BLACK, 5, 1);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (asMenuItem)
		{
			var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);
			this.y = FlxMath.lerp(y, (scaledY * 80) + (FlxG.height * 0.48), 0.16);
			this.x = FlxMath.lerp(x, 100 + (Math.abs(targetY) * -50), 0.16);
		}
	}
}