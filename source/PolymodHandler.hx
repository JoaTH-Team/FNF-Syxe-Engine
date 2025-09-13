package;

import flixel.FlxG;
import flixel.util.FlxStringUtil;
import polymod.Polymod;
import polymod.backends.PolymodAssets.PolymodAssetType;
import polymod.format.ParseRules;
import polymod.fs.PolymodFileSystem;
import sys.FileSystem;
import sys.io.File;

class PolymodHandler
{
	static final MOD_DIR:String = 'mods';
	static final GLOBAL_MOD_ID:String = 'global';
	static final CORE_DIR:String = 'assets';

	static final API_VERSION:String = '1.0.0';
	static final API_VERSION_MATCH:String = '*.*.*';

	static var fs(default, null):IFileSystem;

	private static final extensions:Map<String, PolymodAssetType> = [
		'ogg' => AUDIO_GENERIC,
		'wav' => AUDIO_GENERIC,
		'png' => IMAGE,
		'xml' => TEXT,
		'json' => TEXT,
		'txt' => TEXT,
		'hxs' => TEXT,
		'frag' => TEXT,
		'vert' => TEXT,
		'ttf' => FONT,
		'otf' => FONT
	];

	public static var trackedMods:Array<ModMetadata> = [];

	public static function reload():Void
	{
		trace('Reloading Polymod...');

		if (!FileSystem.exists('./mods/'))
			FileSystem.createDirectory('./mods/');
		if (!FileSystem.exists('mods/mods-go-here.txt'))
			File.saveContent('mods/mods-go-here.txt', '');

		fs = PolymodFileSystem.makeFileSystem(null, {modRoot: MOD_DIR});

		Polymod.init({
			modRoot: MOD_DIR,
			dirs: getMods(),
			customFilesystem: fs,
			framework: OPENFL,
			apiVersionRule: API_VERSION,
			errorCallback: onError,
			frameworkParams: {
				coreAssetRedirect: CORE_DIR
			},
			parseRules: getParseRules(),
			extensionMap: extensions,
			ignoredFiles: Polymod.getDefaultIgnoreList()
		});
	}

	public static function getMods():Array<String>
	{
		trackedMods = [];

		if (FlxG.save.data.disabledMods == null)
		{
			FlxG.save.data.disabledMods = [];
			FlxG.save.flush();
		}

		var daList:Array<String> = [];
		var globalDirPath:String = '$MOD_DIR/$GLOBAL_MOD_ID';
		if (fs.exists(globalDirPath) && fs.isDirectory(globalDirPath))
			daList.push(GLOBAL_MOD_ID);

		trace('Searching for Mods...');

		for (i in Polymod.scan({modRoot: MOD_DIR, apiVersionRule: API_VERSION_MATCH, errorCallback: onError}))
		{
			if (i.id == GLOBAL_MOD_ID)
				continue;

			if (i != null)
			{
				trackedMods.push(i);
				if (!FlxG.save.data.disabledMods.contains(i.id))
					daList.push(i.id);
			}
		}

		if (daList != null && daList.length > 0)
			trace('Found ${daList.length} new mods.');

		return daList != null && daList.length > 0 ? daList : [];
	}

	public static function getModIDs():Array<String>
	{
		return (trackedMods.length > 0) ? [for (i in trackedMods) i.id] : [];
	}

	public static function getParseRules():ParseRules
	{
		final output:ParseRules = ParseRules.getDefault();
		output.addType('txt', TextFileFormat.LINES);
		output.addType('json', TextFileFormat.JSON);
		output.addType('hxs', TextFileFormat.PLAINTEXT);
		output.addType('frag', TextFileFormat.PLAINTEXT);
		output.addType('vert', TextFileFormat.PLAINTEXT);
		return output != null ? output : null;
	}

	static function onError(error:PolymodError):Void
	{
		var code:String = FlxStringUtil.toTitleCase(Std.string(error.code).split('_').join(' '));

		switch (error.severity)
		{
			case NOTICE:
				FlxG.log.notice('($code) ${error.message}');
			case WARNING:
				FlxG.log.warn('($code) ${error.message}');
			case ERROR:
				FlxG.log.error('($code) ${error.message}');
		}
	}
}