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
import flixel.system.FlxSound;

class DeathSubState extends FlxSubState
{
 	var titleLogo:FlxSprite;
 	var nextButton:FlxButton;
 	var exitButton:FlxButton;
 	var bg:FlxSprite;
 	var deathreason:FlxText;

 	var lvl:String;
 	var defzoom:Float;
 	var deathsound:FlxSound;
 	var soundstr:String;
	function exittotitle()
	{
		FlxG.sound.music.stop();
		Player.ispaused = false;
		FlxG.switchState(new StartState());
	}
	function resetlevel()
	{
		FlxG.sound.music.stop();
		switch(lvl)
		{
			case "1":
				FlxG.switchState(new Level1State());
			case "2":
				FlxG.switchState(new Level2State());
			case "3":
				FlxG.switchState(new Level3State());
			case "4":
				FlxG.switchState(new Level4State());
			case "5":
				FlxG.switchState(new Level5State());
			case "6":
				FlxG.switchState(new Level6State());
			case "7":
				FlxG.switchState(new Level7State());
			case "8":
				FlxG.switchState(new Level8State());
			case "9":
				FlxG.switchState(new Level9State());
			case "10":
				FlxG.switchState(new Level10State());
		}
	    close();
	    DiscordClient.changePresence("On Level " + lvl, Player.playingchar, "Playing As " + Player.playingchar);
	}
	public function new(levelloadedon:String, deathreasonthing:String = "You fell off the world", deathsoundpath:String = "assets/sounds/normal/deathvoid.wav")
	{
		soundstr = deathsoundpath;
		trace("$deathsoundpath");
		deathsound = FlxG.sound.load(deathsoundpath);
		deathsound.play();
		lvl = levelloadedon;
		DiscordClient.changePresence("On Level " + levelloadedon + " - DIED", Player.playingchar+"-dead", "Playing As " + Player.playingchar);
		FlxG.sound.playMusic('assets/music/deathscreen.ogg', 1, true);
		super();
		DiscordClient.changePresence("On Level " + levelloadedon + " - PAUSED", Player.playingchar, "Playing As " + Player.playingchar);
		FlxG.camera.zoom = 1;
		FlxG.camera.angle = 0;
		bg = new FlxSprite(0, 0).loadGraphic('assets/images/ui/bg.png');
		bg.screenCenter();

		deathreason = new FlxText(FlxG.camera.x, FlxG.camera.y, 0, deathreasonthing, 32);

		exitButton = new FlxButton(0, 0, " ", exittotitle);
		exitButton.loadGraphic('assets/images/ui/exit.png');
		exitButton.screenCenter();
		exitButton.y += 200;

		nextButton = new FlxButton(0, 0, " ", resetlevel);
		nextButton.loadGraphic('assets/images/ui/respawnbtn.png');
		nextButton.screenCenter();
		nextButton.y += 100;

		titleLogo = new FlxSprite(0, 0).loadGraphic('assets/images/ui/dead.png');
		titleLogo.screenCenter();
		titleLogo.y -= 100;
		FlxG.mouse.visible = true;

		if (!FlxG.save.data.respawn)
		{
			add(bg);
			add(titleLogo);
			add(exitButton);
			add(nextButton);
			add(deathreason);
		}
		if (FlxG.save.data.respawn)
		{
			FlxG.sound.music.stop();
			resetlevel();
		}
		FlxG.camera.follow(bg, NO_DEAD_ZONE, 1);
	}
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}