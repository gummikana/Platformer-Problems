package com.grapefrukt.games.platprob;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2World;
import com.grapefrukt.games.platprob.physics.PhysUtils;
import nme.Lib;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class Player {
	
	public var body(default, null):B2Body;
	public var isOnGround(default, null):Bool;
	
	// stats
	public var jumpTime:Int;
	public var jumpTimeStart:Int;
	public var jumpHeight:Float;
	public var jumpHighest:Float;
	public var jumpHeightStart:Float;
	
	public function new(world:B2World) {
		body = PhysUtils.createBox(world, Settings.STAGE_W / 2, Settings.STAGE_H / 4, 50, 100, true, 1);
		body.setFixedRotation( true );
		body.setUserData(this);
		
		isOnGround = false;
		jumpTimeStart = 0;
		jumpHeightStart = 0;
	}
	
	public function update() {
		isOnGround = false;
		if ( jumpHeightStart != 0 && body.getPosition().y < jumpHighest ) jumpHighest = body.getPosition().y;
	}
	
	public function jump() {
		body.applyForce( new B2Vec2( 0, Settings.PLATFORMING_JUMP_VELOCITY ), new B2Vec2( 0, 0 ) );
		
		jumpTimeStart = Lib.getTimer();
		jumpHeightStart = body.getPosition().y;
		jumpHighest = jumpHeightStart;
	}
	
	public function touchGround() {
		if ( isOnGround == false && jumpTimeStart != 0 ) {
			jumpTime = Lib.getTimer() - jumpTimeStart;
			jumpTimeStart = 0;
			jumpHeight = jumpHighest - jumpHeightStart;
			jumpHeightStart = 0;
			
			Lib.trace( jumpTime );
			Lib.trace( jumpHeight );
		}
		isOnGround = true;
	}
	
}