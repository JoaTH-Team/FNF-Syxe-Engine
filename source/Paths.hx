package;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.media.Sound;
import sys.FileSystem;
import sys.io.File;

using haxe.io.Path;

typedef FileAssets = #if sys FileSystem; #else Assets; #end
typedef GarbageCollect = #if cpp cpp.vm.Gc; #elseif hl hl.Gc; #elseif neko neko.vm.Gc; #end

/**
 * Enum representing different types of sprite sheets.
 */
enum SpriteSheetType
{
	ASEPRITE;
	PACKER;
	SPARROW;
	TEXTURE_PATCHER_JSON;
	TEXTURE_PATCHER_XML;
}

/**
 * Provides utility functions for handling asset paths and loading assets in a game.
 */
@:keep
@:access(openfl.display.BitmapData)
class Paths
{
	inline public static final DEFAULT_FOLDER:String = 'assets';

	public static final getText:String->String = #if sys File.getContent #else Assets.getText #end;

	public static var SOUND_EXT:Array<String> = ['.ogg', '.wav'];

	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	public static var currentTrackedSounds:Map<String, Sound> = [];
	public static var localTrackedAssets:Array<String> = [];

	private static var trackedBitmaps:Map<String, BitmapData> = new Map();

	@:noCompletion private inline static function _gc(major:Bool):Void
	{
		#if (cpp || neko)
		GarbageCollect.run(major);
		#elseif hl
		GarbageCollect.major();
		#end
	}

	@:noCompletion public inline static function compress():Void
	{
		#if cpp
		GarbageCollect.compact();
		#elseif hl
		GarbageCollect.major();
		#elseif neko
		GarbageCollect.run(true);
		#end
	}

	public inline static function gc(major:Bool = false, repeat:Int = 1):Void
	{
		while (repeat-- > 0)
			_gc(major);
	}

	public static function clearUnusedMemory():Void
	{
		for (key in currentTrackedAssets.keys())
		{
			if (!localTrackedAssets.contains(key))
			{
				destroyGraphic(currentTrackedAssets.get(key));
				currentTrackedAssets.remove(key);
			}
		}
		compress();
		gc(true);
	}

	@:access(flixel.system.frontEnds.BitmapFrontEnd._cache)
	public static function clearStoredMemory():Void
	{
		for (key in FlxG.bitmap._cache.keys())
			if (!currentTrackedAssets.exists(key))
				destroyGraphic(FlxG.bitmap.get(key));

		for (key => asset in currentTrackedSounds)
			if (!localTrackedAssets.contains(key) && asset != null)
			{
				Assets.cache.clear(key);
				currentTrackedSounds.remove(key);
			}

		localTrackedAssets = [];
		Assets.cache.clear('songs');
		gc(true);
		compress();
	}

	inline static function destroyGraphic(graphic:FlxGraphic):Void
	{
		if (graphic != null && graphic.bitmap != null && graphic.bitmap.__texture != null)
			graphic.bitmap.__texture.dispose();
		FlxG.bitmap.remove(graphic);
	}

	public static function setBitmap(id:String, ?bitmap:BitmapData):BitmapData
	{
		if (!trackedBitmaps.exists(id) && bitmap != null)
			trackedBitmaps.set(id, bitmap);
		pushTracked(id);
		return trackedBitmaps.get(id);
	}

	public static function disposeBitmap(id:String):Void
	{
		var obj:Null<BitmapData> = trackedBitmaps.get(id);
		if (obj != null)
		{
			obj.dispose();
			obj.disposeImage();
			trackedBitmaps.remove(id);
		}
	}

	public static function pushTracked(file:String):Void
	{
		if (!localTrackedAssets.contains(file))
			localTrackedAssets.push(file);
	}

	inline static public function exists(asset:String):Bool
		return FileAssets.exists(asset);

	static public function getPath(folder:Null<String>, file:String):String
		return (folder == null ? DEFAULT_FOLDER : folder) + '/' + file;

	static public function file(file:String, folder:String = DEFAULT_FOLDER):String
		return #if sys FileSystem.exists(folder) && #end (folder != null && folder != DEFAULT_FOLDER) ? getPath(folder, file) : getPath(null, file);

	inline public static function getTextArray(path:String):Array<String>
		return exists(path) ? [for (i in getText(path).trim().split('\n')) i.trim()] : [];

	static public function getTextFromFile(key:String):String
		return exists(file(key)) ? getText(file(key)) : null;

	inline static public function txt(key:String):String
		return file('$key.txt');

	inline static public function json(key:String):String
		return file('$key.json');

	inline static public function xml(key:String):String
		return file('$key.xml');

	inline static public function lua(key:String):String
		return file('$key.lua');

	inline static public function script(key:String):String
	{
		var extension:String = '.hxs';
		extension = (exists(file(key + '.hxs'))) ? '.hxs' : extension;
		return file(key + extension);
	}

	static public function validScriptType(n:String):Bool
		return n.endsWith('.hxs');

	inline static public function frag(key:String):String
		return file('shaders/$key.frag');

	inline static public function vert(key:String):String
		return file('shaders/$key.vert');

	static public function sound(key:String, ?cache:Bool = true):Sound
		return returnSound('sounds/$key', cache);

	inline static public function music(key:String, ?cache:Bool = true):Sound
		return returnSound('music/$key', cache);

	inline static public function song(key:String, ?cache:Bool = true):Sound
		return returnSound('songs/$key/music', cache);

	inline static public function formatToSongPath(path:String):String
		return path.toLowerCase().replace(' ', '-');

	inline static public function font(key:String):String
	{
		var path:String = file('fonts/$key');
		for (i in ['ttf', 'otf'])
			if (path.extension() == '' && exists(path.withExtension(i)))
				path = path.withExtension(i);
		return path;
	}

	inline static public function image(key:String, ?cache:Bool = true):FlxGraphic
		return returnGraphic('images/$key', cache);

	public static inline function spritesheet(key:String, ?cache:Bool = true, ?type:SpriteSheetType):FlxAtlasFrames
	{
		type = type ?? SPARROW;
		return switch (type)
		{
			case ASEPRITE: FlxAtlasFrames.fromAseprite(image(key, cache), json('images/$key'));
			case PACKER: FlxAtlasFrames.fromSpriteSheetPacker(image(key, cache), txt('images/$key'));
			case SPARROW: FlxAtlasFrames.fromSparrow(image(key, cache), xml('images/$key'));
			case TEXTURE_PATCHER_JSON: FlxAtlasFrames.fromTexturePackerJson(image(key, cache), json('images/$key'));
			case TEXTURE_PATCHER_XML: FlxAtlasFrames.fromTexturePackerXml(image(key, cache), xml('images/$key'));
			default: FlxAtlasFrames.fromSparrow(image('errorSparrow', cache), xml('images/errorSparrow'));
		}
	}

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
			pushTracked(path);
			return currentTrackedAssets.get(path);
		}

		trace('oops! graphic $key returned null');
		return null;
	}

	public static function returnSound(key:String, ?cache:Bool = true, ?beepOnNull:Bool = true):Sound
	{
		for (i in SOUND_EXT)
		{
			var path:String = file(key + i);
			if (Assets.exists(file(key + i), SOUND))
			{
				if (!currentTrackedSounds.exists(path))
					currentTrackedSounds.set(path, Assets.getSound(path, cache));
				pushTracked(path);
				return currentTrackedSounds.get(path);
			}
		}

		trace('oops! sound $key returned null');
		return (beepOnNull) ? flixel.system.FlxAssets.getSoundAddExtension('flixel/sounds/beep') : null;
	}
}