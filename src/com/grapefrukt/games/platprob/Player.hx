package com.grapefrukt.games.platprob;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2World;
import com.grapefrukt.games.platprob.physics.PhysUtils;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Player {
	
	public var body(default, null):B2Body;
	
	public function new(world:B2World) {
		body = PhysUtils.createBox(world, Settings.STAGE_W / 2, Settings.STAGE_H / 4, 50, 100, true, 1);
		body.setFixedRotation( true );
	}
	
}