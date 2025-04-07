package backend;

import openfl.system.System;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxAssets;
import openfl.Assets;
import openfl.media.Sound;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

@:keep
@:access(openfl.display.BitmapData)
class Paths
{
	static var currentLevel:String;

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	inline public static final DEFAULT_FOLDER:String = 'assets';

	public static var SOUND_EXT:Array<String> = ['.ogg', '.wav'];

	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	public static var currentTrackedSounds:Map<String, Sound> = [];
	public static var localTrackedAssets:Array<String> = [];

	static public function getPath(folder:Null<String>, file:String)
	{
		if (folder == null)
			folder = DEFAULT_FOLDER;
		return folder + '/' + file;
	}

	static public function file(file:String, folder:String = DEFAULT_FOLDER)
	{
		if (#if sys FileSystem.exists(folder) && #end (folder != null && folder != DEFAULT_FOLDER))
			return getPath(folder, file);
		return getPath(null, file);
	}

	inline static public function data(key:String)
		return file('data/$key');

	inline static public function video(key:String)
		return file('videos/$key.mp4');

	static public function sound(key:String, ?cache:Bool = true):Sound
		return returnSound('sounds/$key', cache);

	inline static public function music(key:String, ?cache:Bool = true):Sound
		return returnSound('music/$key', cache);

	inline static public function image(key:String, ?cache:Bool = true):FlxGraphic
		return returnGraphic('images/$key', cache);

	inline static public function font(key:String)
		return file('fonts/$key');

	inline static public function inst(key:String, ?cache:Bool = true):Sound
	{
		return returnSound('songs/$key/Inst', cache);
	}

	inline static public function voices(key:String, ?cache:Bool = true):Sound
	{
		return returnSound('songs/$key/Voices', cache);
	}

	inline static public function songs(key:String, ?cache:Bool = true):Sound
	{
		return returnSound('songs/$key', cache);
	}

	inline static public function getSparrowAtlas(key:String)
		return FlxAtlasFrames.fromSparrow(image(key), file('images/$key.xml'));

	inline static public function getPackerAtlas(key:String)
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key), file('images/$key.txt'));

	public static function returnGraphic(key:String, ?cache:Bool = true):FlxGraphic
	{
		var path:String = file('$key.png');
		if (Assets.exists(path, IMAGE))
		{
			if (!currentTrackedAssets.exists(path))
			{
				var graphic:FlxGraphic = FlxGraphic.fromBitmapData(Assets.getBitmapData(path), false, path, cache);
				graphic.persist = true;
				currentTrackedAssets.set(path, graphic);
			}

			localTrackedAssets.push(path);
			return currentTrackedAssets.get(path);
		}

		trace('oops! graphic $key returned null');
		return null;
	}

	public static function returnSound(key:String, ?cache:Bool = true, ?beepOnNull:Bool = true):Sound
	{
		for (i in SOUND_EXT)
		{
			if (Assets.exists(file(key + i), SOUND))
			{
				var path:String = file(key + i);
				if (!currentTrackedSounds.exists(path))
					currentTrackedSounds.set(path, Assets.getSound(path, cache));

				localTrackedAssets.push(path);
				return currentTrackedSounds.get(path);
			}
			else if (beepOnNull)
			{
				trace('oops! sound $key returned null');
				return FlxAssets.getSoundAddExtension('flixel/sounds/beep');
			}
		}

		trace('oops! sound $key returned null');
		return null;
	}

	inline static public function getAsepriteAtlas(key:String):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromAseprite(image(key), file('images/$key.json'));
	}

	// TODO: Make this function even better
	inline static public function cleanMemory():Void
	{
		FlxG.bitmap.clearCache();
		System.gc();
	}
}
