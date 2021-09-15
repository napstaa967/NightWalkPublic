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

class GeneralSubState extends FlxSubState
{
 	var bg:FlxSprite;
 	var settingssuboptions:Array<String> = ['Refresh Rate', 'FPS Counter', 'Rotate Camera', 'Reset Configurations', 'Exit'];
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
	var resetdatastate:Int = 0;
	function exittotitle()
	{
		
		FlxG.switchState(new StartState());
	}
	public function new()
	{
		
		FlxG.camera.fade(FlxColor.BLACK, 0.33, true);
		super();
		DiscordClient.changePresence("On Settings Screen - General", "cog", "With Configs N Shit");
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
			if (txt.ID == 0)
			{
				txt.text = 'Refresh Rate: ' + (cast (Lib.current.getChildAt(0), Main)).getFPSCap();
			}
			if (txt.ID == 1)
			{
				txt.text = FlxG.save.data.fpscounter ? "FPS Counter Enabled" : "FPS Counter Disabled";
			}
			if (txt.ID == 2)
			{
				txt.text = FlxG.save.data.rotcam ? "Rotate Camera" : "Static Camera";
			}
			if (txt.ID == 3)
			{
				switch (resetdatastate)
				{
					case 0:
						txt.text = "Reset Data";
					case 1:
						txt.text = "Confirm Data Reset";
				}
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
				
				if (left)
				{
					FlxG.save.data.FpsCap -= 10;
					if (FlxG.save.data.FpsCap < 30)
						FlxG.save.data.FpsCap = 30;
					(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.FpsCap);
					trace(FlxG.save.data.FpsCap);
				}
				if (right)
				{
					FlxG.save.data.FpsCap += 10;
					if (FlxG.save.data.FpsCap > 240)
						FlxG.save.data.FpsCap = 240;
					(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.FpsCap);
					trace(FlxG.save.data.FpsCap);
				}
			}
			case 1:
			{
				if (enter)
				{
					FlxG.save.data.fpscounter = !FlxG.save.data.fpscounter;
					(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fpscounter);
				}
			}
			case 2:
			{
				if (enter)
				{
					FlxG.save.data.rotcam = !FlxG.save.data.rotcam;
				}
			}
			case 3:
			{
				if (enter)
				{
					resetdatastate++;
					if (resetdatastate > 1)
					{
						resetdatastate = 0;
					}
					if (resetdatastate == 1)
					{
						FlxG.save.data.lastlevel = "1";
						FlxG.save.data.FpsCap = 60;
						FlxG.save.data.fpscounter = false;
						FlxG.save.data.rotkeys = false;
						FlxG.save.data.rotcam = false;
						FlxG.save.data.lastx = 0;
						FlxG.save.data.lasty = 0;
					}
				}
			}
			case 4:
			{
				if (enter)
				{
					close();
				}
			}
		}
	}
}