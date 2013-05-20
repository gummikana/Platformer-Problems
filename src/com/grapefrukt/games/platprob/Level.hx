package com.grapefrukt.games.platprob;
import box2D.dynamics.B2World;
import com.grapefrukt.games.platprob.physics.PhysUtils;
import nme.Assets;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Level {

	public static function load(world:B2World, file:String) {
		var data = Assets.getBitmapData("images/" + file + ".png");
		
		for (y in 0 ... data.height) {
			for (x in 0 ... data.width) {
				var pixel = data.getPixel32(x, y);
				var color = (pixel) & 0xffffff;
				var alpha = ((pixel >> 24) & 0xff);
				
				if (alpha == 255) {
					PhysUtils.createBox(world,
						(x - data.width / 2) * Settings.PLAYER_WIDTH / Settings.PHYSICS_SCALE,
						(y - data.height / 2) * Settings.PLAYER_WIDTH / Settings.PHYSICS_SCALE,
						Settings.PLAYER_WIDTH / Settings.PHYSICS_SCALE,
						Settings.PLAYER_WIDTH / Settings.PHYSICS_SCALE,
						false,
						Settings.BOUNDS_FRICTION,
						Settings.BOUNDS_RESTITUTION,
						0,
						color
					);
				}
			}
		}
	}
}