package;

#if android
import android.AndroidTools;
import android.stuff.Permissions;
#end
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import openfl.Lib;
import haxe.CallStack.StackItem;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;

/**
 * author: Saw (M.A. Jigsaw) / Stripped by Random.
 */
class CrashCheck
{

	// Thanks Forever Engine
	static public function check()
	{
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
	}

	static public function onCrash(e:UncaughtErrorEvent):Void
	{
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();
		dateNow = StringTools.replace(dateNow, " ", "_");
		dateNow = StringTools.replace(dateNow, ":", "'");
		var path:String = "log/" + "crash_" + dateNow + ".txt";
		var errMsg:String = "";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += e.error;

		if (!FileSystem.exists("log"))
		{
			FileSystem.createDirectory("log");
		}

		sys.io.File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));
		Sys.println("Making a simple alert ...");

		CrashCheck.applicationAlert("Uncaught Error, The Call Stack: ", errMsg);
		flash.system.System.exit(0);
	}

	public static function applicationAlert(title:String, description:String)
	{
		Application.current.window.alert(description, title);
	}
}
