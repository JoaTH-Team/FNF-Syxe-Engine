package;

import flixel.FlxG;
import flixel.addons.sound.FlxRhythmConductor;

using flixel.addons.sound.FlxRhythmConductorUtil;

class FunkinSound {
    public static function playSound(embeddedSound:flixel.system.FlxAssets.FlxSoundAsset, volume:Float = 1.0, looped:Bool = false) {
		return FlxG.sound.play(Paths.sound(embeddedSound), volume, looped);
    }

	public static function playMusic(?resetConductor:Bool = true, embeddedSound:flixel.system.FlxAssets.FlxSoundAsset, volume:Float = 1.0, looped:Bool = false)
	{
        if (resetConductor) FlxRhythmConductor.reset();
        FlxG.sound.playMusic(Paths.music(embeddedSound), volume, looped);
        FlxRhythmConductor.instance.loadMetaFromFilePath(Paths.file('music/$embeddedSound.musicMeta'));
    }
}