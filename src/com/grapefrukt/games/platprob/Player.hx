package com.grapefrukt.games.platprob;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2World;
import com.grapefrukt.games.platprob.physics.PhysUtils;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Player {
	
	public var body(default, null):B2Body;
	public var isOnGround(default, null):Bool;
	
	public function new(world:B2World) {
		body = PhysUtils.createBox(world, Settings.STAGE_W / 2, Settings.STAGE_H / 4, 50, 100, true, 1);
		body.setFixedRotation( true );
		body.setUserData(this);
		
		isOnGround = false;
	}
	
	public function update() {
		isOnGround = false;
	}
	
	public function jump() {
		body.applyForce( new B2Vec2( 0, -10000 ), new B2Vec2( 0, 0 ) );
	}
	
	public function touchGround() {
		isOnGround = true;
	}
	
}