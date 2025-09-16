package;

import flixel.FlxG;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.math.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class InitState extends MusicBeatState
{
    override function create() {
        super.create();

        PolymodHandler.reload();
		SaveData.init();

        FlxG.game.focusLostFramerate = 60;

		if (SaveData.settings.transitionType == "Default" || SaveData.settings.transitionType == "Single")
			crateTransition();

		// Use a small delay to ensure transitions are properly set up
		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			FlxG.switchState(TitleState.new);
		});
	}

	function crateTransition()
	{
		// Setup transitions
		var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;

		var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
			new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1), {asset: diamond, width: 32, height: 32},
			new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
		// Apply transitions to current state
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
	}

}