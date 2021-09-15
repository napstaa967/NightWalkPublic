package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
class LoadLevel extends FlxSprite
{
	public static function load(input:String)
	{
		switch input
		{
			case "1":
			{
				FlxG.switchState(new Level1State());
			}
			case "2":
			{
				FlxG.switchState(new Level2State());
			}
			case "3":
			{
				FlxG.switchState(new Level3State());
			}
			case "4":
			{
				FlxG.switchState(new Level4State());
			}
			case "5":
			{
				FlxG.switchState(new Level5State());
			}
			case "6":
			{
				FlxG.switchState(new Level6State());
			}
			case "7":
			{
				FlxG.switchState(new Level7State());
			}
			case "8":
			{
				FlxG.switchState(new Level8State());
			}
			case "9":
			{
				FlxG.switchState(new Level9State());
			}
			case "10":
			{
				FlxG.switchState(new Level10State());
			}
		}
	}
}