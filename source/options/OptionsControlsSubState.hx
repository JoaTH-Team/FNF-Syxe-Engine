package options;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class OptionsControlsSubState extends MusicBeatSubState
{
	var inChange:Bool = false;
	var groupOptions:FlxTypedGroup<OptionsTextList>;
	var groupCategories:FlxTypedGroup<OptionsTextList>;
	var curSelected:Int = 0;
	var curGroup:Int = 0;
	var listOptions:Array<String> = [];
	var controlsGroup:Array<String> = ["gameplay", "ui", "action"];
	var categoryNames:Array<String> = ["GAMEPLAY", "UI", "ACTION"];

	var gameplayLabels:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT", "LEFT ALT", "DOWN ALT", "UP ALT", "RIGHT ALT"];
	var uiLabels:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT", "LEFT ALT", "DOWN ALT", "UP ALT", "RIGHT ALT"];
	var actionLabels:Array<String> = ["ACCEPT", "BACK"];

	override function create()
	{
		super.create();
		var bg = new FunkinSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.65;
		add(bg);

		groupCategories = new FlxTypedGroup<OptionsTextList>();
		add(groupCategories);

		for (i in 0...categoryNames.length)
		{
			var text:OptionsTextList = new OptionsTextList(20, 50 + i * 40, 0, categoryNames[i], 32);
			text.ID = i;
			groupCategories.add(text);
		}

		groupOptions = new FlxTypedGroup<OptionsTextList>();
		add(groupOptions);

		changeGroup();
	}

	function changeGroup(?change:Int = 0)
	{
		curGroup = FlxMath.wrap(curGroup + change, 0, controlsGroup.length - 1);

		groupCategories.forEach(function(text:OptionsTextList)
		{
			if (text.ID == curGroup)
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

		var currentKeys:Array<String> = [];
		var currentLabels:Array<String> = [];

		switch (controlsGroup[curGroup])
		{
			case "gameplay":
				currentKeys = SaveData.settings.gameplayKey;
				currentLabels = gameplayLabels;
			case "ui":
				currentKeys = SaveData.settings.uiKey;
				currentLabels = uiLabels;
			case "action":
				currentKeys = SaveData.settings.actionKey;
				currentLabels = actionLabels;
		}

		groupOptions.clear();
		listOptions = [];

		for (i in 0...currentKeys.length)
		{
			var displayText = currentLabels[i] + ": " + currentKeys[i];
			listOptions.push(displayText);

			var text:OptionsTextList = new OptionsTextList(250, 150 + i * 30, 0, displayText, 64);
			text.targetY = i;
			text.ID = i;
			text.defaultX = 150;
			text.defaultSpaceX = 0;
			text.asMenuItem = true;
			groupOptions.add(text);
		}

		curSelected = 0;
		changeSelection();
	}

	function refreshList()
	{
		var currentKeys:Array<String> = [];
		var currentLabels:Array<String> = [];

		switch (controlsGroup[curGroup])
		{
			case "gameplay":
				currentKeys = SaveData.settings.gameplayKey;
				currentLabels = gameplayLabels;
			case "ui":
				currentKeys = SaveData.settings.uiKey;
				currentLabels = uiLabels;
			case "action":
				currentKeys = SaveData.settings.actionKey;
				currentLabels = actionLabels;
		}

		for (i in 0...groupOptions.length)
		{
			if (i < currentKeys.length)
			{
				var displayText = currentLabels[i] + ": " + currentKeys[i];
				groupOptions.members[i].text = displayText;
				groupOptions.members[i].color = FlxColor.WHITE;
				groupOptions.members[i].alpha = 0.5;
			}
		}

		changeSelection(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (inChange)
		{
			if (FlxG.keys.firstJustPressed() != -1)
			{
				FlxG.sound.play(Paths.sound('menu/confirmMenu'));
				var pressedKey = FlxG.keys.firstJustPressed();
				var keyName = FlxKey.toStringMap.get(pressedKey);

				if (keyName != null)
				{
					switch (controlsGroup[curGroup])
					{
						case "gameplay":
							SaveData.settings.gameplayKey[curSelected] = keyName;
						case "ui":
							SaveData.settings.uiKey[curSelected] = keyName;
						case "action":
							SaveData.settings.actionKey[curSelected] = keyName;
					}

					refreshList();
				}

				inChange = false;
			}

			if (FlxG.keys.justPressed.ESCAPE)
			{
				FlxG.sound.play(Paths.sound('menu/cancelMenu'));
				inChange = false;
				refreshList();
			}
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.sound.play(Paths.sound('menu/cancelMenu'));
			SaveData.saveSettings();
			this.close();
		}
		if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.RIGHT)
		{
			changeGroup(FlxG.keys.justPressed.LEFT ? -1 : 1);
		}

		if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.DOWN)
		{
			changeSelection(FlxG.keys.justPressed.UP ? -1 : 1);
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.sound.play(Paths.sound('menu/scrollMenu'));
			inChange = true;
			groupOptions.members[curSelected].text = "PRESS ANY KEY...";
			groupOptions.members[curSelected].color = FlxColor.YELLOW;
		}
	}

	function changeSelection(change:Int = 0)
	{
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