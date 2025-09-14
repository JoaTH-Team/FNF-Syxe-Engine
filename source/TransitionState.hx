package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class TransitionState extends MusicBeatState
{
    public static var transitionInProgress:Bool = false;
    public static var nextState:Class<FlxState>;
    
    override function create()
    {
        super.create();
        
        if (transitionInProgress)
        {
            camera.alpha = 0;
            camera.zoom = 2;
            camera.y = FlxG.height * 2;
            FlxTween.tween(camera, {y: 0, zoom: 1, alpha: 1}, 1, {
                ease: FlxEase.circOut,
                onComplete: function(tween:FlxTween)
                {
                    transitionInProgress = false;
                }
            });
        }
    }
    
    public static function switchStateWithTransition(targetState:Class<FlxState>)
    {
        transitionInProgress = true;
        nextState = targetState;
        
        FlxTween.tween(FlxG.camera, {y: FlxG.height * 2, zoom: 2, alpha: 0}, 2, {
            ease: FlxEase.circIn,
            onComplete: function(tween:FlxTween)
            {
                FlxG.switchState(() -> Type.createInstance(nextState, []));
            }
        });
    }
    
    public static function goBackWithTransition(targetState:Class<FlxState>)
    {
        switchStateWithTransition(targetState);
    }
}