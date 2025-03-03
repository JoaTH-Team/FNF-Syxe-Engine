#if MOD_ALLOW
package backend;

import polymod.Polymod;
import polymod.backends.PolymodAssets.PolymodAssetType;
import polymod.format.ParseRules;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class PolyHandler
{
	static final MOD_DIR:String = 'mods';
	static final CORE_DIR:String = 'assets';
	static final API_VERSION:String = '1.0.0';

	public static var trackedMods:Array<ModMetadata> = [];

	private static final extensions:Map<String, PolymodAssetType> = [
		'ogg' => AUDIO_GENERIC,
		'wav' => AUDIO_GENERIC,
		'png' => IMAGE,
		'xml' => TEXT,
		'json' => TEXT,
		'txt' => TEXT,
		'hxs' => TEXT,
		'lua' => TEXT, // omg lua support???
		'ttf' => FONT,
		'otf' => FONT
	];

	public static function reload():Void
	{
		trace('Reloading Polymod...');
		#if sys
		if (!FileSystem.exists('./mods/'))
			FileSystem.createDirectory('./mods/');
		if (!FileSystem.exists('mods/mods-goes-here.txt'))
			File.saveContent('mods/mods-goes-here.txt', '');
		#end
		loadMods(getMods());
	}

	public static function loadMods(folders:Array<String>)
	{
		var loadedModlist:Array<ModMetadata> = Polymod.init({
			modRoot: MOD_DIR,
			dirs: folders,
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

		if (loadedModlist == null)
			return;

		trace('Loading Successful, ${loadedModlist.length} / ${folders.length} new mods.');

		for (mod in loadedModlist)
			trace('Name: ${mod.title}, [${mod.id}]');
	}

	public static function getMods():Array<String>
	{
		trackedMods = [];

		var daList:Array<String> = [];

		trace('Searching for Mods...');

		for (i in Polymod.scan({modRoot: MOD_DIR, apiVersionRule: API_VERSION, errorCallback: onError}))
		{
			if (i != null) 
			{
				trackedMods.push(i);
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
		output.addType("txt", TextFileFormat.LINES);
		output.addType("json", TextFileFormat.JSON); // so json files can be merged too
		output.addType("hxs", TextFileFormat.PLAINTEXT);
		output.addType("lua", TextFileFormat.PLAINTEXT);
		return output != null ? output : null;
	}

	static function onError(error:PolymodError):Void
	{
		switch (error.code)
		{
			case MOD_LOAD_PREPARE:
				trace(error.message);
			case MOD_LOAD_DONE:
				trace(error.message);
			case MISSING_ICON:
				trace(error.message);
			default:
				switch (error.severity)
				{
					case NOTICE:
						trace(error.message);
					case WARNING:
						trace(error.message);
					case ERROR:
						trace(error.message);
				}
		}
	}
}
#end