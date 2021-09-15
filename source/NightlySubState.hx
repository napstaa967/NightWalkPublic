package;

import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import Discord.DiscordClient;

class NightlySubState extends FlxSubState
{
 	var bg:FlxSprite;
 	var text:FlxText;
 	var escape:Bool = false;
	function exittotitle()
	{
		FlxG.sound.music.stop();
		close();
	}
	public function new()
	{
		StartState.firstlanunch = false;
		FlxG.sound.playMusic('assets/music/nightly.ogg', 1, true);
		super();
		DiscordClient.changePresence("On Nightly Build Screen", Player.playingchar, "Playing As " + Player.playingchar);
	    bg = new FlxSprite(0, 0).loadGraphic('assets/images/ui/darken.png');
		bg.screenCenter();
		bg.scrollFactor.set(0,0);

		text = new FlxText(0, 0, 0, "Hey!, you're using a Nightly Build, this means you\ncan and will experience unstability\nsubmit all bugs to the game developer\n\nHappy Testing!\n\npress esc to close", 32);
		text.scrollFactor.set(0,0);
		text.screenCenter();
		add(bg);
		add(text);
	}
	override public function update(elapsed:Float)
	{
		escape = FlxG.keys.anyPressed([ESCAPE, DELETE, ENTER]);
		if(escape)
		{
			trace("a");
			FlxG.sound.music.stop();
			FlxG.sound.playMusic('assets/music/titlescreen.ogg', 1, true);	
			close();
		}
		super.update(elapsed);
	}
}