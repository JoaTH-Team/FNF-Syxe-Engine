package;

import flixel.FlxG;

class TitleState extends MusicBeatState
{
	public function new()
	{
		super();

		PolymodHandler.reload();
	}

    override function create() {
        super.create();
	}

    override function update(elapsed:Float) {
        super.update(elapsed);
		if (controls.justPressed.ACCEPT)
		{
			FlxG.switchState(PlayState.new);
		} 
    }
}