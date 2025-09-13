package;

import flixel.addons.input.FlxControls;
import flixel.input.keyboard.FlxKey;

enum Action {
	GAME_LEFT;
	GAME_DOWN;
	GAME_UP;
	GAME_RIGHT;

	UI_LEFT;
	UI_DOWN;
	UI_UP;
	UI_RIGHT;
	ACCEPT;
	BACK;
}

class Controls extends FlxControls<Action>
{
    function getDefaultMappings():ActionMap<Action> {
        return [
			GAME_LEFT => [
				FlxKey.fromString(SaveData.settings.gameplayKey[0]),
				FlxKey.fromString(SaveData.settings.gameplayKey[4])
			],
			GAME_DOWN => [
				FlxKey.fromString(SaveData.settings.gameplayKey[1]),
				FlxKey.fromString(SaveData.settings.gameplayKey[5])
			],
			GAME_UP => [
				FlxKey.fromString(SaveData.settings.gameplayKey[2]),
				FlxKey.fromString(SaveData.settings.gameplayKey[6])
			],
			GAME_RIGHT => [
				FlxKey.fromString(SaveData.settings.gameplayKey[3]),
				FlxKey.fromString(SaveData.settings.gameplayKey[7])
			],

			UI_LEFT => [
				FlxKey.fromString(SaveData.settings.uiKey[0]),
				FlxKey.fromString(SaveData.settings.uiKey[4])
			],
			UI_DOWN => [
				FlxKey.fromString(SaveData.settings.uiKey[1]),
				FlxKey.fromString(SaveData.settings.uiKey[5])
			],
			UI_UP => [
				FlxKey.fromString(SaveData.settings.uiKey[2]),
				FlxKey.fromString(SaveData.settings.uiKey[6])
			],
			UI_RIGHT => [
				FlxKey.fromString(SaveData.settings.uiKey[3]),
				FlxKey.fromString(SaveData.settings.uiKey[7])
			],

			ACCEPT => [FlxKey.fromString(SaveData.settings.actionKey[0])],
			BACK => [FlxKey.fromString(SaveData.settings.actionKey[1])]
        ];
    }
}