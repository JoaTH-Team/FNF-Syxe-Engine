package options;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class OptionsPreferencesSubState extends MusicBeatSubState
{
    var groupOptions:FlxTypedGroup<OptionsTextList>;
    
    var options:Array<OptionDefinition> = [
        {
            name: "Ghost tap",
            type: "Bool",
            getValue: () -> SaveData.settings.ghosttap,
            setValue: (value) -> SaveData.settings.ghosttap = value,
            display: (value) -> value ? "ENABLE" : "DISABLE"
        },
        {
            name: "Downscroll",
            type: "Bool",
            getValue: () -> SaveData.settings.downscroll,
            setValue: (value) -> SaveData.settings.downscroll = value,
            display: (value) -> value ? "ENABLE" : "DISABLE"
        },
        {
            name: "Antialiasing",
            type: "Bool",
            getValue: () -> SaveData.settings.antialiasing,
            setValue: (value) -> SaveData.settings.antialiasing = value,
            display: (value) -> value ? "ENABLE" : "DISABLE"
        },
        {
            name: "Accurary",
            type: "String",
            getValue: () -> SaveData.settings.accuracy,
            setValue: (value) -> SaveData.settings.accuracy = value,
            options: ["Simple", "Complex", "Unfair"],
            display: (value) -> value
        },
        {
            name: "Frame Skip",
            type: "Int",
            getValue: () -> SaveData.settings.frameSkip,
            setValue: (value) -> SaveData.settings.frameSkip = value,
            range: {min: 0, max: 2, step: 1},
            display: (value) -> Std.string(value)
        },
        {
            name: "Framerate Capped",
            type: "Int",
            getValue: () -> SaveData.settings.framerate,
            setValue: function (value) {
                SaveData.settings.framerate = value;
                CoolUtil.updateFPS();
            },
            range: {min: 60, max: 240, step: 5},
            display: (value) -> Std.string(value)
        },
        {
            name: "Transition Type",
            type: "String",
            getValue: () -> SaveData.settings.transitionType,
            setValue: (value) -> SaveData.settings.transitionType = value,
            options: ["Default", "Single", "None"],
            display: (value) -> value
        }
    ];

    var currentValues:Map<String, Dynamic> = new Map();
    var curSelected:Int = 0;

    override function create() {
        super.create();

        var bg:FunkinSprite = new FunkinSprite();
        bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0.65;
        add(bg);

        for (option in options) {
            currentValues.set(option.name, option.getValue());
        }

        groupOptions = new FlxTypedGroup<OptionsTextList>();
        add(groupOptions);

        for (i in 0...options.length) {
            var option = options[i];
            var displayText = option.name + ": " + option.display(currentValues.get(option.name));
            
            var text:OptionsTextList = new OptionsTextList(100, 0, 0, displayText, 64);
            text.targetY = i;
            text.ID = i;
            text.asMenuItem = true;
            groupOptions.add(text);
        }

        changeSelection();
    }

    function refreshList() {
        for (i in 0...groupOptions.length) {
            if (i < options.length) {
                var option = options[i];
                var displayText = option.name + ": " + option.display(currentValues.get(option.name));
                groupOptions.members[i].text = displayText;
            }
        }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.justPressed.BACK) {
            SaveData.saveSettings();
            this.close();
        }

        if (controls.justPressed.UI_UP || controls.justPressed.UI_DOWN) {
            changeSelection(controls.justPressed.UI_UP ? -1 : 1);
        }

        if (controls.justPressed.ACCEPT) {
            var option = options[curSelected];
            if (option.type == "Bool") {
                var newValue = !currentValues.get(option.name);
                currentValues.set(option.name, newValue);
                option.setValue(newValue);
                refreshList();
            }
        }

        if (controls.justPressed.UI_LEFT || controls.justPressed.UI_RIGHT) {
            var option = options[curSelected];
            var currentValue = currentValues.get(option.name);

            switch (option.type) {
                case "Int", "Float":
                    if (option.range != null) {
                        var change = controls.justPressed.UI_LEFT ? -option.range.step : option.range.step;
                        var newValue = FlxMath.bound(currentValue + change, option.range.min, option.range.max);
                        
                        if (newValue != currentValue) {
                            currentValues.set(option.name, newValue);
                            option.setValue(newValue);
                            refreshList();
                        }
                    }

                case "String":
                    if (option.options != null) {
                        var currentIndex = option.options.indexOf(currentValue);
                        if (currentIndex < 0) currentIndex = 0;
                        
                        var change = controls.justPressed.UI_LEFT ? -1 : 1;
                        var newIndex = FlxMath.wrap(currentIndex + change, 0, option.options.length - 1);
                        var newValue = option.options[newIndex];
                        
                        currentValues.set(option.name, newValue);
                        option.setValue(newValue);
                        refreshList();
                    }
            }
        }
    }

    function changeSelection(change:Int = 0) {
        curSelected = FlxMath.wrap(curSelected + change, 0, groupOptions.length - 1);

        var inSelected:Int = 0;
        groupOptions.forEach(function(text:OptionsTextList) {
            text.targetY = inSelected - curSelected;
            inSelected += 1;
            if (text.ID == curSelected) {
                text.color = FlxColor.YELLOW;
                text.alpha = 1;
            } else {
                text.color = FlxColor.WHITE;
                text.alpha = 0.5;
            }
        });
    }
}

typedef OptionDefinition = {
    name:String,
    type:String,
    getValue:Void->Dynamic,
    setValue:Dynamic->Void,
    ?options:Array<String>,
    ?range:{min:Int, max:Int, step:Int},
    display:Dynamic->String
}