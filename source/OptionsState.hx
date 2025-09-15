package;

class OptionsState extends MusicBeatState
{
    override function create() {
        super.create();
        
        var bg:FunkinSprite = new FunkinSprite(0, 0, Paths.image("menuDesat"));
        bg.color.getDarkened(1.25);
        add(bg);

        var optionsTitle:FunkinSprite = new FunkinSprite(0, 50);
        optionsTitle.frames = Paths.spritesheet("mainmenu/options", true, SPARROW);
        optionsTitle.addPrefix("idle", "options idle", 24, true);
        optionsTitle.playAnim("idle");
        optionsTitle.screenCenter(X);
        add(optionsTitle);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (controls.justPressed.BACK) {
            MusicBeatState.switchStateWithTransition(MainMenuState, RIGHT);
        }
    }
}