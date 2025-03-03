package backend;

import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

typedef Bind =
{
	key:Array<FlxKey>,
	gamepad:Array<FlxGamepadInputID>
}

class Controls
{
	public static var binds:Map<String, Bind> = [
		'down' => {key: [DOWN, S], gamepad: [DPAD_DOWN, LEFT_SHOULDER]},
		'right' => {key: [RIGHT, D], gamepad: [DPAD_RIGHT, RIGHT_TRIGGER]},
		'up' => {key: [UP, W], gamepad: [DPAD_UP, RIGHT_SHOULDER]},
		'left' => {key: [LEFT, D], gamepad: [DPAD_LEFT, LEFT_TRIGGER]},
		'accept' => {key: [ENTER, SPACE], gamepad: [A, START]},
		'exit' => {key: [ESCAPE, BACKSPACE], gamepad: [B, BACK]},
	];

	public static function justPressed(tag:String):Bool
		return checkInput(tag, JUST_PRESSED);

	public static function pressed(tag:String):Bool
		return checkInput(tag, PRESSED);

	public static function justReleased(tag:String):Bool
		return checkInput(tag, JUST_RELEASED);

	public static function anyJustPressed(tags:Array<String>):Bool
		return checkAnyInputs(tags, JUST_PRESSED);

	public static function anyPressed(tags:Array<String>):Bool
		return checkAnyInputs(tags, PRESSED);

	public static function anyJustReleased(tags:Array<String>):Bool
		return checkAnyInputs(tags, JUST_RELEASED);
	
	public static function checkInput(tag:String, state:FlxInputState):Bool 
	{
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (binds.exists(tag)) 
		{
			if (gamepad != null) 
			{
				for (i in 0...binds[tag].gamepad.length) 
				{
					var input = binds[tag].gamepad[i];
					if (input != FlxGamepadInputID.NONE && gamepad.checkStatus(input, state))
						return true;
				}
			} 
			else 
			{
				for (i in 0...binds[tag].key.length) 
				{
					var input = binds[tag].key[i];
					if (input != FlxKey.NONE && FlxG.keys.checkStatus(input, state))
						return true;
				}
			}
		} 
		else 
		{
			if (gamepad != null)
				if (FlxGamepadInputID.fromString(tag) != FlxGamepadInputID.NONE
					&& gamepad.checkStatus(FlxGamepadInputID.fromString(tag), state))
					return true;

			if (FlxKey.fromString(tag) != FlxKey.NONE && FlxG.keys.checkStatus(FlxKey.fromString(tag), state))
				return true;
		}

		return false;
	}

	public static function checkAnyInputs(tags:Array<String>, state:FlxInputState):Bool 
	{
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (tags == null || tags.length <= 0)
			return false;

		for (i in 0...tags.length) 
		{
			var tag = tags[i];
			if (binds.exists(tag)) 
			{
				if (gamepad != null) 
				{
					for (j in 0...binds[tag].gamepad.length) 
					{
						var input = binds[tag].gamepad[j];
						if (input != FlxGamepadInputID.NONE && gamepad.checkStatus(input, state))
							return true;
					}
				} 
				else 
				{
					for (j in 0...binds[tag].key.length) 
					{
						var input = binds[tag].key[j];
						if (input != FlxKey.NONE && FlxG.keys.checkStatus(input, state))
							return true;
					}
				}
			} 
			else 
			{
				if (gamepad != null)
					if (FlxGamepadInputID.fromString(tag) != FlxGamepadInputID.NONE
						&& gamepad.checkStatus(FlxGamepadInputID.fromString(tag), state))
						return true;

				if (FlxKey.fromString(tag) != FlxKey.NONE && FlxG.keys.checkStatus(FlxKey.fromString(tag), state))
					return true;
			}
		}

		return false;
	}
}