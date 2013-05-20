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
				var pixel = data.getPixel(x, y);
				if (pixel == 0) {
					PhysUtils.createBox(world, x * (Settings.STAGE_W / data.width), y * (Settings.STAGE_H / data.height), (Settings.STAGE_W / data.width), (Settings.STAGE_H / data.height), false, Settings.BOUNDS_FRICTION, Settings.BOUNDS_RESTITUTION, 0);
				}
			}
		}
	}
}