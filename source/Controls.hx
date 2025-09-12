package;

import flixel.addons.input.FlxControls;
import flixel.input.keyboard.FlxKey;

enum Action {
    UI_UP;
    UI_DOWN;
    UI_LEFT;
    UI_RIGHT;
}

class Controls extends FlxControls<Action>
{
    function getDefaultMappings():ActionMap<Action> {
        return [
            UI_LEFT => [FlxKey.fromString(SaveData.settings.keyboard[0])],
            UI_DOWN => [FlxKey.fromString(SaveData.settings.keyboard[1])],
            UI_UP => [FlxKey.fromString(SaveData.settings.keyboard[2])],
            UI_RIGHT => [FlxKey.fromString(SaveData.settings.keyboard[3])]
        ];
    }
}