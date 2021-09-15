package options;

import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import Discord.DiscordClient;
import flixel.util.FlxColor;
import openfl.display.FPS;
import openfl.Lib;
import lime.app.Application;
import lime.system.DisplayMode;
import flixel.system.FlxSound;

class GameplaySubState extends FlxSubState
{
 	var bg:FlxSprite;
 	var settingssuboptions:Array<String> = ['Rotate Keys', 'Saves Text', 'Instant Respawn', 'Exit'];
 	var curSelected:Int = 0;
 	var grpOptionsTexts:FlxTypedGroup<FlxText>;
 	var up:Bool = false;
	var right:Bool = false;
	var left:Bool = false;
	var down:Bool = false;
	var enter:Bool = false;
	var escape:Bool = false;
	var selector:FlxSprite;
	var select:FlxSound;
	var confirm:FlxSound;
	function exittotitle()
	{
		
		FlxG.switchState(new StartState());
	}
	public function new()
	{
		
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		super();
		DiscordClient.changePresence("On Settings Screen - Gameplay", "cog", "With Configs N Shit");
		FlxG.camera.zoom = 1;
		
	    bg = new FlxSprite(0, 0).loadGraphic('assets/images/ui/optionsbg.png');
		bg.screenCenter();
		bg.scrollFactor.set(0, 0);
		
		add(bg);
		
		grpOptionsTexts = new FlxTypedGroup<FlxText>();
		
		add(grpOptionsTexts);
		

		selector = new FlxSprite().makeGraphic(5, 5, FlxColor.RED);
		
		add(selector);
		

		for (i in 0...settingssuboptions.length)
		{
			
			var optionText:FlxText = new FlxText(20, 20 + (i * 50), 0, settingssuboptions[i], 32);
			optionText.ID = i;
			grpOptionsTexts.add(optionText);
		}
	}
	override public function update(elapsed:Float)
	{
		select = FlxG.sound.load('assets/sounds/normal/select.wav');
		confirm = FlxG.sound.load('assets/sounds/normal/selectconfirm.wav');
		grpOptionsTexts.update;
		up = FlxG.keys.anyJustPressed([UP, W]);
		left = FlxG.keys.anyJustPressed([LEFT, A]);
		right = FlxG.keys.anyJustPressed([RIGHT, D]);
		down = FlxG.keys.anyJustPressed([DOWN, S]);
		escape = FlxG.keys.anyJustPressed([ESCAPE, DELETE]);
		enter = FlxG.keys.anyJustPressed([HOME, ENTER, SPACE]);
		if (up)
		{
			select.play();
			curSelected -= 1;
		}

		if (down)
		{
			select.play();
			curSelected += 1;
		}
		if (enter)
		{
			confirm.play();
		}

		if (curSelected < 0)
			
			curSelected = 0;

		if (curSelected >= settingssuboptions.length)
			
			curSelected = 0;
		grpOptionsTexts.forEach(function(txt:FlxText)
		{
			
			txt.color = FlxColor.WHITE;
			if (txt.ID == curSelected)
			{
				txt.color = FlxColor.GREEN;
				FlxG.camera.follow(txt, NO_DEAD_ZONE);
			}
			switch (txt.ID)
			{
				case 0:
					txt.text = FlxG.save.data.rotkeys ? "Rotate Keybinds On Glue" : "Keybinds Stay Static";
				case 1:
					txt.text = FlxG.save.data.savetext ? "Display Remaining Saves" : "Hide Remaining Saves";
				case 2:
					txt.text = FlxG.save.data.respawn ? "Instant Respawn" : "Manual Respawn";
			}
		});
		super.update(elapsed);
		if (FlxG.save.data.FpsCap == 0)
		{
			FlxG.save.data.FpsCap = 60;
		}
		if (escape)
		{
			close();
		}
		switch (curSelected)
		{
			case 0:
			{
				
				if (enter)
				{
					FlxG.save.data.rotkeys = !FlxG.save.data.rotkeys;
				}
			}
			case 1:
			{
				
				if (enter)
				{
					FlxG.save.data.savetext = !FlxG.save.data.savetext;
				}
			}
			case 2:
			{
				
				if (enter)
				{
					FlxG.save.data.respawn = !FlxG.save.data.respawn;
				}
			}
			case 3:
			{
				if (enter)
				{
					close();
				}
			}
		}
	}
}