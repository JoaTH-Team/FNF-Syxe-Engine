package backend.scripts;

import flixel.FlxObject;
import flixel.util.FlxAxes;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;
import states.PlayState;
import flixel.text.FlxText;
import flixel.FlxCamera;
import backend.game.FunkSprite;
import flixel.FlxG;
import crowplexus.iris.IrisConfig.RawIrisConfig;
import sys.io.File;
import crowplexus.iris.Iris;

using StringTools;

class HScript extends Iris
{
    public function new(fileScript:String)
    {
        final config:RawIrisConfig = {
            name: fileScript.split("/").pop(),
            autoRun: false,
            autoPreset: true
        }
        super(File.getContent(fileScript), config);

        function initClasses() {
            set("FlxG", FlxG);
            set("FlxSprite", FunkSprite);
            set("FlxCamera", FlxCamera);
            set("FlxText", FlxText);
            set("Paths", Paths);
        }
        initClasses();

        function initVariableFunction() {
            for (field in Reflect.fields(PlayState.instance))
                set(field, Reflect.field(PlayState.instance, field));

			var objects:Array<Dynamic> = [
				getFlxKey(),
				getFlxColor(),
				getFlxCameraFollowStyle(),
				getFlxTextAlign(),
				getFlxTextBorderStyle(),
				getFlxAxes()
			];

			for (obj in objects)
                for (field in Reflect.fields(obj))
                    set(field, Reflect.field(obj, field));
            set("game", PlayState.instance);
			set("add", function (variable:FlxObject) {
				return FlxG.state.add(variable);
			}, true);
            set("remove", function (variable:FlxObject) {
                return FlxG.state.remove(variable);
            }, true);
        }
        initVariableFunction();

        execute();
        trace("Script executed: " + fileScript);
    }

	override function call(fun:String, ?args:Array<Dynamic>):IrisCall {
		if (!exists(fun)) return null;
		return super.call(fun, args);
	}

    public function getFlxColor() {
		return {
			// colors
			"BLACK": FlxColor.BLACK,
			"BLUE": FlxColor.BLUE,
			"BROWN": FlxColor.BROWN,
			"CYAN": FlxColor.CYAN,
			"GRAY": FlxColor.GRAY,
			"GREEN": FlxColor.GREEN,
			"LIME": FlxColor.LIME,
			"MAGENTA": FlxColor.MAGENTA,
			"ORANGE": FlxColor.ORANGE,
			"PINK": FlxColor.PINK,
			"PURPLE": FlxColor.PURPLE,
			"RED": FlxColor.RED,
			"TRANSPARENT": FlxColor.TRANSPARENT,
			"WHITE": FlxColor.WHITE,
			"YELLOW": FlxColor.YELLOW,

			// functions
			"add": FlxColor.add,
			"fromCMYK": FlxColor.fromCMYK,
			"fromHSB": FlxColor.fromHSB,
			"fromHSL": FlxColor.fromHSL,
			"fromInt": FlxColor.fromInt,
			"fromRGB": FlxColor.fromRGB,
			"fromRGBFloat": FlxColor.fromRGBFloat,
			"fromString": FlxColor.fromString,
			"interpolate": FlxColor.interpolate,
			"to24Bit": function(color:Int) {
				return color & 0xffffff;
			}
		};
	}

	public static function getFlxKey() {
		return {
			'ANY': -2,
			'NONE': -1,
			'A': 65,
			'B': 66,
			'C': 67,
			'D': 68,
			'E': 69,
			'F': 70,
			'G': 71,
			'H': 72,
			'I': 73,
			'J': 74,
			'K': 75,
			'L': 76,
			'M': 77,
			'N': 78,
			'O': 79,
			'P': 80,
			'Q': 81,
			'R': 82,
			'S': 83,
			'T': 84,
			'U': 85,
			'V': 86,
			'W': 87,
			'X': 88,
			'Y': 89,
			'Z': 90,
			'ZERO': 48,
			'ONE': 49,
			'TWO': 50,
			'THREE': 51,
			'FOUR': 52,
			'FIVE': 53,
			'SIX': 54,
			'SEVEN': 55,
			'EIGHT': 56,
			'NINE': 57,
			'PAGEUP': 33,
			'PAGEDOWN': 34,
			'HOME': 36,
			'END': 35,
			'INSERT': 45,
			'ESCAPE': 27,
			'MINUS': 189,
			'PLUS': 187,
			'DELETE': 46,
			'BACKSPACE': 8,
			'LBRACKET': 219,
			'RBRACKET': 221,
			'BACKSLASH': 220,
			'CAPSLOCK': 20,
			'SEMICOLON': 186,
			'QUOTE': 222,
			'ENTER': 13,
			'SHIFT': 16,
			'COMMA': 188,
			'PERIOD': 190,
			'SLASH': 191,
			'GRAVEACCENT': 192,
			'CONTROL': 17,
			'ALT': 18,
			'SPACE': 32,
			'UP': 38,
			'DOWN': 40,
			'LEFT': 37,
			'RIGHT': 39,
			'TAB': 9,
			'PRINTSCREEN': 301,
			'F1': 112,
			'F2': 113,
			'F3': 114,
			'F4': 115,
			'F5': 116,
			'F6': 117,
			'F7': 118,
			'F8': 119,
			'F9': 120,
			'F10': 121,
			'F11': 122,
			'F12': 123,
			'NUMPADZERO': 96,
			'NUMPADONE': 97,
			'NUMPADTWO': 98,
			'NUMPADTHREE': 99,
			'NUMPADFOUR': 100,
			'NUMPADFIVE': 101,
			'NUMPADSIX': 102,
			'NUMPADSEVEN': 103,
			'NUMPADEIGHT': 104,
			'NUMPADNINE': 105,
			'NUMPADMINUS': 109,
			'NUMPADPLUS': 107,
			'NUMPADPERIOD': 110,
			'NUMPADMULTIPLY': 106,

			'fromStringMap': FlxKey.fromStringMap,
			'toStringMap': FlxKey.toStringMap,
			'fromString': FlxKey.fromString,
			'toString': function(key:Int) {
				return FlxKey.toStringMap.get(key);
			}
		};
	}

	public function getFlxCameraFollowStyle() {
		return {
			"LOCKON": FlxCameraFollowStyle.LOCKON,
			"PLATFORMER": FlxCameraFollowStyle.PLATFORMER,
			"TOPDOWN": FlxCameraFollowStyle.TOPDOWN,
			"TOPDOWN_TIGHT": FlxCameraFollowStyle.TOPDOWN_TIGHT,
			"SCREEN_BY_SCREEN": FlxCameraFollowStyle.SCREEN_BY_SCREEN,
			"NO_DEAD_ZONE": FlxCameraFollowStyle.NO_DEAD_ZONE
		};
	}

	public function getFlxTextAlign() {
		return {
			"LEFT": FlxTextAlign.LEFT,
			"CENTER": FlxTextAlign.CENTER,
			"RIGHT": FlxTextAlign.RIGHT,
			"JUSTIFY": FlxTextAlign.JUSTIFY
		};
	}

	public function getFlxTextBorderStyle() {
		return {
			"NONE": FlxTextBorderStyle.NONE,
			"SHADOW": FlxTextBorderStyle.SHADOW,
			"OUTLINE": FlxTextBorderStyle.OUTLINE,
			"OUTLINE_FAST": FlxTextBorderStyle.OUTLINE_FAST
		};
	}

	public function getFlxAxes() {
		return {
			"X": FlxAxes.X,
			"Y": FlxAxes.Y,
			"XY": FlxAxes.XY
		};
	}
}