package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.system.FlxSound;

class Characters extends Player
{
	public static var tex:FlxAtlasFrames;
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		tex = FlxAtlasFrames.fromSparrow('assets/images/characters/char' + Player.playingchar + '.png', 'assets/images/characters/char' + Player.playingchar + '.xml');
	}
	function updateMovement()
	{
		if (!ispaused)
		{
			//MESSY AS SHIT I KNOW IM SORRY FORGIVE ME
			clicksound = FlxG.sound.load('assets/sounds/click.wav');
			if (angle == 0)
			{
				velocity.set(iceslip, Fallshit);
				if (FlxG.camera.angle == -180)
				{
					up = FlxG.keys.anyPressed([DOWN, S, SPACE]);
					left = FlxG.keys.anyPressed([RIGHT, D]);
					right = FlxG.keys.anyPressed([LEFT, A]);
					down = FlxG.keys.anyPressed([UP, W]);
				}
				if (FlxG.camera.angle == 0)
				{
					up = FlxG.keys.anyPressed([UP, W, SPACE]);
					left = FlxG.keys.anyPressed([LEFT, A]);
					right = FlxG.keys.anyPressed([RIGHT, D]);
					down = FlxG.keys.anyPressed([DOWN, S]);
				}
				if (left && right)
			 		left = right = false;
			 	if (down && up)
			 		down = up = false;
			 	if (right || left || up || down)
				{
					if (down)
						Fallshit = 200;
					if (left)
						SPEED = -100;
						facing = FlxObject.LEFT;
					if (right)
						SPEED = 100;
						facing = FlxObject.RIGHT;
					if (up && jumps == 0)
					{
						clicksound.play();
						trace(jumps);
						trace(Fallshit);
						Fallshit = -105;
						jumps++;
						SPEED = 0;
						if (left)
							SPEED = -100;
						if (right)
							SPEED = 100;
						new FlxTimer().start(0.1, function(tmr:FlxTimer)
						{
							if (ispaused)
							{
								tmr.active = false;
							}
							if (!ispaused)
							{
								tmr.active = true;
							}
							if (angle != 0)
								tmr.destroy();
							if (Fallshit != 100)
							{
								tmr.reset();
								if (Fallshit < 0)
									Fallshit += 10;
								if (Fallshit > 0)
									Fallshit += 100;
								if (Fallshit > 100)
									Fallshit = 100;
								trace(Fallshit);
							}
							else
							{
								tmr.destroy();
							}
						});
					}
					if (ispaused)
					{
						velocity.set(0, 0);
					}
					if (!ispaused)
						velocity.set(SPEED, Fallshit);
					if (velocity.x != 0) 
					{
						if (touching == FlxObject.FLOOR /*|| touching == ExtendedCollision.WALL1  || touching == ExtendedCollision.WALL2 || touching == ExtendedCollision.WALL3 || touching == ExtendedCollision.WALL4*/)
						{
							animation.play("walk");
							if (left)
								flipX = true;
							if (right)
								flipX = false;
						}
						if (touching != FlxObject.FLOOR /*|| touching != ExtendedCollision.WALL1  || touching != ExtendedCollision.WALL2 || touching != ExtendedCollision.WALL3 || touching != ExtendedCollision.WALL4*/)
						{
							animation.play("jump");
							if (left)
								flipX = true;
							if (right)
								flipX = false;
						}
					}
					else
					{
						animation.play("idle");
					}
				}
			}
			if (angle == -90)
			{
				velocity.set(Fallshit, iceslip);
				if (FlxG.camera.angle == 0)
				{
					up = FlxG.keys.anyPressed([RIGHT, D, SPACE]);
					right = FlxG.keys.anyPressed([DOWN, S]);
					left = FlxG.keys.anyPressed([UP, W]);
					down = FlxG.keys.anyPressed([LEFT, A]);
				}
				if (FlxG.camera.angle == -180)
				{
					up = FlxG.keys.anyPressed([LEFT, A, SPACE]);
					right = FlxG.keys.anyPressed([UP, W]);
					left = FlxG.keys.anyPressed([DOWN, S]);
					down = FlxG.keys.anyPressed([RIGHT, D]);
				}
				if (left && right)
			 		left = right = false;
			 	if (down && up)
			 		down = up = false;
			 	if (right || left || up || down)
				{
					if (down)
						Fallshit = 200;
					if (left)
						SPEED = -100;
						facing = FlxObject.LEFT;
					if (right)
						SPEED = 100;
						facing = FlxObject.RIGHT;
					if (up)
					{
						justunsticked = true;
					}
					if (up && jumps == 0)
					{
						clicksound.play();
						trace(jumps);
						trace(Fallshit);
						Fallshit = -105;
						jumps++;
						SPEED = 0;
						if (left)
							SPEED = -100;
						if (right)
							SPEED = 100;
						new FlxTimer().start(0.1, function(tmr:FlxTimer)
						{
							if (ispaused)
							{
								tmr.active = false;
							}
							if (!ispaused)
							{
								tmr.active = true;
							}
							if (angle != -90)
								tmr.destroy();
							if (Fallshit != 100)
							{
								tmr.reset();
								if (Fallshit < 0)
									Fallshit += 10;
								if (Fallshit > 0)
									Fallshit += 100;
								if (Fallshit > 100)
									Fallshit = 100;
								trace(Fallshit);
							}
							else
							{
								tmr.destroy();
							}
						});
					}
					if (ispaused)
					{
						velocity.set(0, 0);
					}
					if (!ispaused)
						velocity.set(Fallshit, SPEED);
					if (velocity.y != 0) 
					{
						if (touching == FlxObject.RIGHT)
						{
							animation.play("walk");
							if (left)
								flipX = false;
							if (right)
								flipX = true;
						}
						else
						{
							animation.play("jump");
							if (left)
								flipX = false;
							if (right)
								flipX = true;
						}
					}
					else
					{
						animation.play("idle");
					}
				}
			}
			if (angle == -180)
			{
				velocity.set(iceslip, Fallshit);
				if (FlxG.camera.angle == 0)
				{
					up = FlxG.keys.anyPressed([DOWN, S, SPACE]);
					left = FlxG.keys.anyPressed([LEFT, A]);
					right = FlxG.keys.anyPressed([RIGHT, D]);
					down = FlxG.keys.anyPressed([UP, W]);
				}
				if (FlxG.camera.angle == -180)
				{
					up = FlxG.keys.anyPressed([UP, W, SPACE]);
					left = FlxG.keys.anyPressed([RIGHT, D]);
					right = FlxG.keys.anyPressed([LEFT, A]);
					down = FlxG.keys.anyPressed([DOWN, S]);
				}
				if (left && right)
			 		left = right = false;
			 	if (down && up)
			 		down = up = false;
			 	if (right || left || up || down)
				{
					if (down)
						Fallshit = -200;
					if (left)
						SPEED = -100;
						facing = FlxObject.LEFT;
					if (right)
						SPEED = 100;
						facing = FlxObject.RIGHT;
					if (up && jumps == 0)
					{
						clicksound.play();
						trace(jumps);
						trace(Fallshit);
						Fallshit = 105;
						jumps++;
						SPEED = 0;
						if (left)
							SPEED = -100;
						if (right)
							SPEED = 100;
						new FlxTimer().start(0.1, function(tmr:FlxTimer)
						{
							if (ispaused)
							{
								tmr.active = false;
							}
							if (!ispaused)
							{
								tmr.active = true;
							}
							if (angle != -180)
								tmr.destroy();
							if (Fallshit != -100)
							{
								tmr.reset();
								if (Fallshit > 0)
									Fallshit -= 10;
								if (Fallshit < 0)
									Fallshit -= 100;
								if (Fallshit < -100)
									Fallshit = -100;
								trace(Fallshit);
							}
							else
							{
								tmr.destroy();
							}
						});
					}
					if (ispaused)
					{
						velocity.set(0, 0);
					}
					if (!ispaused)
						velocity.set(SPEED, Fallshit);
					if (velocity.x != 0) 
					{
						if (touching == FlxObject.CEILING)
						{
							animation.play("walk");
							if (left)
								flipX = false;
							if (right)
								flipX = true;
						}
					}
					else
					{
						animation.play("idle");
					}
				}
			}
		}
	}
	override function update(elapsed:Float)
 	{
 		escape = FlxG.keys.anyJustPressed([ESCAPE, DELETE]);
		if (escape)
		{
			ispaused = !ispaused;
		}
 		if (!ispaused)
 		{
	 		trace(touching);
	 		//velocity.rotate(FlxPoint.weak(0, 0), 0);
			//angle = 0;
			if ((((angle == 0 && touching == FlxObject.FLOOR) || (angle == -180 && touching == FlxObject.CEILING)) && velocity.x == 0) || (((angle == -90 && touching == FlxObject.RIGHT) || (angle == 90 && touching == FlxObject.LEFT)) && velocity.y == 0))
			{
				animation.play("idle");
			}
			if (touching == FlxObject.NONE)
			{
				animation.play("jump");
				angle = 0;
			}
		 	updateMovement();
		 	up = FlxG.keys.anyPressed([UP, W, SPACE]);
			left = FlxG.keys.anyPressed([LEFT, A]);
			right = FlxG.keys.anyPressed([RIGHT, D]);
			down = FlxG.keys.anyPressed([DOWN, S]);
			if (touching == FlxObject.NONE)
			{
				iceslip = 0;
				if (justunsticked == true)
				{
					justunsticked = false;
					angle = 0;
					Fallshit = -105;
					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
					if (ispaused)
						{
							tmr.active = false;
						}
						if (!ispaused)
						{
							tmr.active = true;
						}
						if (angle != 0)
								tmr.destroy();
						if (Fallshit != 100)
						{
							tmr.reset();
							if (Fallshit < 0)
								Fallshit += 10;
							if (Fallshit > 0)
								Fallshit += 100;
							if (Fallshit > 100)
								Fallshit = 100;
							trace(Fallshit);
						}
						else
						{
							tmr.destroy();
						}
					});
				}
			}
	 		if (up || down && !left && !right && SPEED != 0)
	 			SPEED = 0;
	 		if (angle == 0 || angle == -90)
	 		{
				if (Fallshit > 100)
				{
					Fallshit = 100;
				}
	 		}
	 		if (angle == 90 || angle == 180)
	 		{
				if (Fallshit < -100)
				{
					Fallshit = -100;
				}
	 		}
			if (iceslip < 3)
			{
				iceslip += 0.5;
				if (iceslip > 2.9)
				{
					iceslip = 0;
				}
			}
			if (iceslip > 3)
			{
				iceslip -= 0.5;
				if (iceslip < 2.9)
				{
					iceslip = 0;
				}
			}
			if (iceslip < 1.1 && iceslip > -1.1)
				iceslip = 0;
			if (iceslip == 3)
				iceslip = 0;
			if (Fallshit == 0)
			{
				if (angle == -90)
					Fallshit = 100;
				if (angle == -180)
					Fallshit = -100;
			}
			//trace(justunsticked);
		 	super.update(elapsed);
		}
		if (ispaused)
		{
		}
	}
}