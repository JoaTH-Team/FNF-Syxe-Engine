package options;

import flixel.FlxG;

class OptionsControlsSubState extends MusicBeatSubState
{
	override function create()
	{
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE) {
            SaveData.saveSettings();
            this.close();
        }
	}
}