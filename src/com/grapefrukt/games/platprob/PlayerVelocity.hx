package com.grapefrukt.games.platprob;
import box2D.common.math.B2Math;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2World;
import box2D.dynamics.contacts.B2Contact;
import com.grapefrukt.games.platprob.physics.PhysUtils;
import nme.Lib;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class PlayerVelocity {
	
	public var body(default, null):B2Body;
	public var isOnGround(default, null):Bool;
	public var inAirCounter:Int;
	public var keyPressed:Int;
	
	// stats
	public var jumpTime:Int;
	public var jumpTimeStart:Int;
	public var jumpHeight:Float;
	public var jumpHighest:Float;
	public var jumpHeightStart:Float;
	public var contacts:Array< B2Contact >;

	
	public function new(world:B2World) {
		contacts = [];
		/*body = PhysUtils.createPill(
			world,
			8.5 / Settings.PHYSICS_SCALE ,
			10 / Settings.PHYSICS_SCALE,
			( Settings.PLAYER_WIDTH * 0.5 ) / Settings.PHYSICS_SCALE,
			Settings.PLAYER_HEIGHT / Settings.PHYSICS_SCALE,
			Settings.VPLAYER_FRICTION,
			Settings.VPLAYER_RESTITUTION,
			Settings.VPLAYER_DENSITY );
			*/
		body = PhysUtils.createDiamondInMeters(
			world,
			8.5,
			10,
			Settings.PLAYER_WIDTH * 0.5,
			Settings.PLAYER_HEIGHT,
			Settings.VPLAYER_FRICTION,
			Settings.VPLAYER_RESTITUTION,
			Settings.VPLAYER_DENSITY );
			
		// body.setFixedRotation( true );
		body.setUserData( this );
		body.m_specialGravity = new B2Vec2(0, 0);
	
		isOnGround = false;
		inAirCounter = 0;
		jumpTimeStart = 0;
		jumpHeightStart = 0;
		keyPressed = 0;
	}
	
	public function update(timeDelta:Float) {
		for ( i in 0...contacts.length ) {
			trace( "Contact: " + i );
			onContact( contacts[ i ] );			
		}
		
		updateBody( body );
		
		if ( Settings.PLATFORMING_USE_IN_AIR_COUNTER == false ) {
			isOnGround = false;
		} else {
			inAirCounter++;
			if ( inAirCounter >= Settings.PLATFORMING_AIR_COUNTER_MAX ) isOnGround = false;
		}
		
		if ( jumpHeightStart != 0 && body.getPosition().y < jumpHighest ) jumpHighest = body.getPosition().y;
		
		if ( Settings.PLAYER_BALANCE_ROTATION )
		{
			var angle:Float = body.getAngle();
			if ( angle != 0 )
			{
				var ang_vel:Float = body.getAngularVelocity();
				ang_vel += -angle * Settings.PLAYER_BALANCE_STRENGTH;
				body.setAngularVelocity( ang_vel );
			}
		}
		
		keyPressed++;
		if ( Settings.PLAYER_GROUND_SLOWDOWN )
		{
			// if ( keyPressed > 1 && keyPressed < Settings.PLAYER_GROUND_SLOWDOWN_LENGTH ) {  wheel.setAngularDamping( 0.75 + keyPressed / Settings.PLAYER_GROUND_SLOWDOWN_LENGTH ); }
			// if ( keyPressed == Settings.PLAYER_GROUND_SLOWDOWN_LENGTH ) { wheel.setFixedRotation( true ); wheel.setAngularVelocity( 0 ); }
		}
		
		/*if( Settings.PLAYER_CLAMP_VELOCITY )
		{
			
			var velocity = body.getLinearVelocity();
			if ( Math.abs( velocity.x ) > Settings.PLAYER_MAX_HORIZONTAL_VELOCITY ) { velocity.x = B2Math.clamp( velocity.x, -Settings.PLAYER_MAX_HORIZONTAL_VELOCITY, Settings.PLAYER_MAX_HORIZONTAL_VELOCITY ); }
			body.setLinearVelocity( velocity );
			
		}*/
		
		// trace( body.getLinearVelocity().x );
			
	}
	
	public function updateBody( pbody:B2Body )
	{
		/*if ( body_new_pos != null ) 
		{
			pbody.setPosition( body_new_pos );
			body_new_pos = null;
		}*/
		pbody.m_platformingVelocity.y += ( Settings.VPLAYER_GRAVITY * Settings.PHYSICS_STEP_DURATION );
		if ( pbody.m_platformingVelocity.y > Settings.VPLAYER_TERMINAL_VELOCITY ) pbody.m_platformingVelocity.y = Settings.VPLAYER_TERMINAL_VELOCITY;			
		
		// pbody.m_linearVelocity.x = pbody.m_platformingVelocity.x * 0.1;
		// pbody.m_linearVelocity.y = pbody.m_platformingVelocity.y * 0.1;
		// pbody.m_platformingVelocity.x *= 0.95;
		
		/*trace( pbody.m_platformingVelocity.x );
		trace( pbody.m_platformingVelocity.y );
		
		trace( pbody.m_linearVelocity.x );
		trace( pbody.m_linearVelocity.y );*/
	}
	
	public function jump() {
		body.m_platformingVelocity.y = Settings.VPLAYER_JUMP_VELOCITY;
		
		jumpTimeStart = Lib.getTimer();
		jumpHeightStart = body.getPosition().y;
		jumpHighest = jumpHeightStart;
	}
	
	public function stopJump() {
		if (body.m_platformingVelocity.y > 0) return;
		body.m_platformingVelocity.y = 0;
	}
	
	
	
	public function applyHorizontalMove( direction:Float ) {
		if ( isOnGround ){
			// body.applyForce( new B2Vec2( direction * Settings.PLATFORMING_HORIZONTAL_VELOCITY_ON_GROUND), body.getWorldCenter() );
			// trace( "On ground" );
		}
		else {
			// body.applyForce( new B2Vec2( direction * Settings.PLATFORMING_HORIZONTAL_VELOCITY_IN_AIR), body.getWorldCenter() );
			// trace( "on air" );
		}
		
		keyPressed = 0;
		
		body.m_platformingVelocity.x += direction * Settings.VPLAYER_HORIZONTAL_VELOCITY;
	}
	
	public function touchGround() {
		if ( isOnGround == false && jumpTimeStart != 0 ) {
			jumpTime = Lib.getTimer() - jumpTimeStart;
			jumpTimeStart = 0;
			jumpHeight = jumpHighest - jumpHeightStart;
			jumpHeightStart = 0;
			
			Lib.trace( "" );
			Lib.trace( jumpTime + "ms" );
			Lib.trace( Math.round(-jumpHeight / Settings.PLAYER_HEIGHT * 10) / 10 +"x");
		}
		isOnGround = true;
		inAirCounter = 0;
		// trace( "on ground" );
	}
	
	public function floatCompare( a:Float, b:Float, delta:Float ):Bool {
		return ( Math.abs( a - b ) < delta );
	}
	
	var body_new_pos:B2Vec2;

	public function addContact( contact:B2Contact ):Void {
		contacts.push( contact );
		onContact( contact );
	}
	
	public function endContact( contact:B2Contact ):Void {
		contacts.remove( contact );
	}
	
	public function onContact( contact:B2Contact):Void {
		
		// trace( contact.getManifold().m_localPlaneNormal.x + ", " + contact.getManifold().m_localPlaneNormal.y );
		
		var normal = contact.getManifold().m_localPlaneNormal;
		
		body_new_pos = body.getPosition().copy();
		body_new_pos.x += normal.x * Math.abs( body.m_platformingVelocity.x ) * Settings.PHYSICS_STEP_DURATION * 1;
		body_new_pos.y += normal.y * Math.abs( body.m_platformingVelocity.y ) * Settings.PHYSICS_STEP_DURATION * 1;
		
		if ( normal.x < 0 ) 
		{
			if(  body.m_platformingVelocity.x > 0 ) {
				trace( "Right side" );
				body.m_platformingVelocity.x -= 5.1;
			} else {
				trace( "Fake right" );
			}
		}
		else if ( normal.x > 0 ) {
			if (  body.m_platformingVelocity.x < 0 ) {
				trace( "Left side" );
				body.m_platformingVelocity.x = 5.1;
			} else {
				trace( "Fake left" );
			}
		}

		if ( normal.y < -0.5 ) {
			// also on ground
			if ( body.m_platformingVelocity.y >= 0 ) { 
				body.m_platformingVelocity.y = 0.5; 
				}
			touchGround();
		}
		else if ( normal.y > 0.5 && body.m_platformingVelocity.y < 0 ) {
			body.m_platformingVelocity.y = 0.0; 
		}
		
		// contact.
		
		/*for (i in 0...contact.getManifold().m_pointCount )
		{
			var localPoint = contact.getManifold().m_points[ i ].m_localPoint;
			{
				if ( body.m_platformingVelocity.x > 0 ) body.m_platformingVelocity.x = 0;
			}
			else if ( floatCompare( localPoint.x, -Settings.PLAYER_WIDTH * 0.5, 0.01 ) ) 			{
				if ( body.m_platformingVelocity.x < 0 ) body.m_platformingVelocity.x = 0;
			}
			
			if( floatCompare( localPoint.y, Settings.PLAYER_HEIGHT * 0.5, 0.01 ) ) 			{
				// also on ground
				if ( body.m_platformingVelocity.y >= 0 ) {
					body.m_platformingVelocity.y = 0.1;
					}
				touchGround();
			}
			else if ( floatCompare( localPoint.y, -Settings.PLAYER_HEIGHT * 0.5, 0.01 ) ) 			{
				if ( body.m_platformingVelocity.y < 0 ) body.m_platformingVelocity.y = 0;
			}
			
			// trace( contact.getManifold().m_points[ i ].m_localPoint.x );
			// trace( contact.getManifold().m_points[ i ].m_localPoint.y );
		}*/
	}
	
}