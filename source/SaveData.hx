package;

import flixel.FlxG;

@:structInit class SaveSettings {
	// preferences
    public var ghosttap:Bool = true;
    public var downscroll:Bool = false;
	public var antialiasing:Bool = true;
	public var frameSkip:Int = 1;

    // controls
	public var gameplayKey:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT", "A", "S", "W", "D"];
	public var uiKey:Array<String> = ["LEFT", "DOWN", "UP", "RIGHT", "A", "S", "W", "D"];
	public var actionKey:Array<String> = ["ENTER", "ESCAPE"];
}

class SaveData {
	public static var settings:SaveSettings = {};

	public static function init() {
		for (key in Reflect.fields(settings))
			if (Reflect.field(FlxG.save.data, key) != null)
				Reflect.setField(settings, key, Reflect.field(FlxG.save.data, key));
	}

	public static function saveSettings() {
		for (key in Reflect.fields(settings))
			Reflect.setField(FlxG.save.data, key, Reflect.field(settings, key));

		FlxG.save.flush();
	}

	public static function eraseData() {
		FlxG.save.erase();
		init();
	}
}