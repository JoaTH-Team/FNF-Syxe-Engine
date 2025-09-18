package scripts;

import crowplexus.iris.Iris;
import sys.io.File;

class HScript extends Iris
{
    public function new(file:String, parentInstance:Dynamic) {
        super(File.getContent(file));

        config.allowEnum = config.allowClass = config.autoPreset = true;
        config.autoRun = false;

        set("Paths", Paths);

        interp.parentInstance = parentInstance;
        parser.allowInterpolation = true;

        execute();
    }

    override function call(fun:String, ?args:Array<Dynamic>):IrisCall {
        if (fun == null || exists(fun) == false) return null;
        return super.call(fun, args);
    }
}