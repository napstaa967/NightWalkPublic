package;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;

class FloppyDisk extends FlxSprite
{
	public static var firstitem:Bool = false;
	public static var alreadygrabbed:Bool = false;
	override function kill()
	{
		trace("called");
		alive = false;
		exists = false;
		finishKill();
	}

	function finishKill()
	{
		alreadygrabbed = false;
		if (Player.saves < 0)
			Player.saves = 0;
		trace(Player.saves);
		if (Player.saves == 1)
		{
			firstitem = true;
		}
		trace(Player.saves);
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			alreadygrabbed = false;
			tmr.destroy();
		});
	}
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		loadGraphic("assets/images/ui/floppy.png", false, 8, 8);
	}
}