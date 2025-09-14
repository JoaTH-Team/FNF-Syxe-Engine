package;

import flixel.FlxG;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class InitState extends MusicBeatState
{
    override function create() {
        super.create();

        PolymodHandler.reload();
		SaveData.init();

        FlxG.game.focusLostFramerate = 60;

		// Setup transitions
		var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;
		
		// Set up the transition in
		FlxTransitionableState.defaultTransIn = new TransitionData();
		FlxTransitionableState.defaultTransIn.tileData = {asset: diamond, width: 32, height: 32};
		FlxTransitionableState.defaultTransIn.color = FlxColor.BLACK;
        FlxTransitionableState.defaultTransIn.duration = 0.6;
        
        // Set up the transition out
        FlxTransitionableState.defaultTransOut = new TransitionData();
        FlxTransitionableState.defaultTransOut.tileData = {asset: diamond, width: 32, height: 32};
        FlxTransitionableState.defaultTransOut.color = FlxColor.BLACK;
        FlxTransitionableState.defaultTransOut.duration = 0.6;
        
        // Apply transitions to current state
        transIn = FlxTransitionableState.defaultTransIn;
        transOut = FlxTransitionableState.defaultTransOut;

        // Use a small delay to ensure transitions are properly set up
        new FlxTimer().start(0.1, function(tmr:FlxTimer) {
            FlxG.switchState(TitleState.new);
        });
    }    
}