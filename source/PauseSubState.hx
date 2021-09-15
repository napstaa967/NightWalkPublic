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

class PauseSubState extends FlxSubState
{
 	var titleLogo:FlxSprite;
 	var nextButton:FlxButton;
 	var restartButton:FlxButton;
 	var exitButton:FlxButton;
 	var continueButton:FlxButton;
 	var bg:FlxSprite;
 	var lvl:String;
 	var defzoom:Float;
 	var currentlevel:FlxText;
	function exittotitle()
	{
		FlxG.sound.music.stop();
		Player.ispaused = false;
		FlxG.switchState(new StartState());
	}
	function unpause()
	{
		FlxG.sound.music.stop();
		Player.ispaused = false;
	    FlxG.camera.zoom = defzoom;
	    close();
	    DiscordClient.changePresence("On Level " + lvl, Player.playingchar, "Playing As " + Player.playingchar);
	}
	public function new(levelloadedon:String, defaultzoom:Float)
	{
		FlxG.sound.playMusic('assets/music/pausescreen.ogg', 1, true);
		super();
		lvl = levelloadedon;
		defzoom = defaultzoom;
		DiscordClient.changePresence("On Level " + levelloadedon + " - PAUSED", Player.playingchar, "Playing As " + Player.playingchar);
		FlxG.camera.zoom = 1;
		FlxG.camera.angle = 0;
	    bg = new FlxSprite(0, 0).loadGraphic('assets/images/ui/darken.png');
		bg.screenCenter();
		bg.scrollFactor.set(0,0);

		currentlevel = new FlxText(0, FlxG.camera.height - 40, 0, "Level " + lvl, 32);
		currentlevel.scrollFactor.set(0,0);

		exitButton = new FlxButton(0, 0, " ", exittotitle);
		exitButton.loadGraphic('assets/images/ui/exit.png');
		exitButton.screenCenter();
		exitButton.y += 200;
		continueButton = new FlxButton(0, 0, " ", unpause);
		continueButton.loadGraphic('assets/images/ui/resumebtn.png');
		continueButton.screenCenter();
		continueButton.y += 100;
		restartButton = new FlxButton(0, 0, " ", restartstuff);
		restartButton.loadGraphic('assets/images/ui/restart.png');
		restartButton.screenCenter();
		restartButton.y += 300;

		titleLogo = new FlxSprite(0, 0).loadGraphic('assets/images/ui/paused.png');
		titleLogo.screenCenter();
		titleLogo.y -= 100;
		titleLogo.scrollFactor.set(0,0);
		FlxG.mouse.visible = true;

		add(bg);
		add(currentlevel);
		add(titleLogo);
		add(exitButton);
		add(continueButton);
		add(restartButton);
	}
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
	function restartstuff()
	{
		LoadLevel.load(lvl);
	}
}