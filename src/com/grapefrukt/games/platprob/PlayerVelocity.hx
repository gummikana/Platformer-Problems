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
class PlayerVelocity extends IPlayer {
	
	public var world(default, null):B2World;
	// public var body(default, null):B2Body;
	// public var isOnGround(default, null):Bool;
	public var inAirCounter:Int;
	public var keyPressed:Int;
	
	// stats
	public var jumpTime:Int;
	public var jumpTimeStart:Int;
	public var jumpHeight:Float;
	public var jumpHighest:Float;
	public var jumpHeightStart:Float;
	public var contacts:Array< B2Contact >;

	
	public function new(in_world:B2World) {
		super();
		contacts = [];
		world = in_world;
		
		body = PhysUtils.createDiamondInMeters(
			world,
			8.5,
			10,
			Settings.PLAYER_WIDTH * 0.5,
			Settings.PLAYER_HEIGHT,
			Settings.VPLAYER_FRICTION,
			Settings.VPLAYER_RESTITUTION,
			Settings.VPLAYER_DENSITY );
			
		body.setUserData( this );
		body.m_specialGravity = new B2Vec2(0, 0);
	
		isOnGround = false;
		inAirCounter = 0;
		jumpTimeStart = 0;
		jumpHeightStart = 0;
		keyPressed = 0;
	}
	
	override public function update(timeDelta:Float) :Void {
		for ( i in 0...contacts.length ) {
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
		if ( Settings.VPLAYER_RAYCAST == false && Settings.VPLAYER_RESPOND_TO_CONTACTS == false ) touchGround();
		
		// gravity
		pbody.m_platformingVelocity.y += ( Settings.VPLAYER_GRAVITY * Settings.PHYSICS_STEP_DURATION );
		
		// terminal velocity
		if ( pbody.m_platformingVelocity.y > Settings.VPLAYER_TERMINAL_VELOCITY ) pbody.m_platformingVelocity.y = Settings.VPLAYER_TERMINAL_VELOCITY;			
		
		// horizontal max speed
		pbody.m_platformingVelocity.x = B2Math.clamp( pbody.m_platformingVelocity.x, -Settings.VPLAYER_MAX_HORIZONTAL_SPEED, Settings.VPLAYER_MAX_HORIZONTAL_SPEED );
		
		// no keys pressed, slow down
		if ( keyPressed != 0 ) pbody.m_platformingVelocity.x *= Settings.VPLAYER_SLOWDOWN_MULTIPLIER;
		
		var direction = 1.0;
		if ( pbody.m_platformingVelocity.y < 0 ) direction = -1.0;
		
		// raycasting
		if ( Settings.VPLAYER_RAYCAST && direction != 0 ) 
		{
			var pos1 = body.getPosition().copy();
			pos1.x -= 0.49 * Settings.PLAYER_WIDTH;
			
			var pos2 = pos1.copy();
			pos2.y += direction * 0.55 * Settings.PLAYER_HEIGHT;
			
			var fixtures = world.rayCastAll( pos1, pos2 );
			
			for ( i in 0...fixtures.length )
			{
				if ( fixtures[ i ] != pbody.getFixtureList() ) {
					if ( direction > 0 ) touchGround();
					pbody.m_platformingVelocity.y = 0;
					return;
				}
			}
		}

		if( Settings.VPLAYER_RAYCAST && direction != 0 ) 
		{
			var pos1 = body.getPosition().copy();
			pos1.x += 0.49 * Settings.PLAYER_WIDTH;
			
			var pos2 = pos1.copy();
			pos2.y += direction * 0.55 * Settings.PLAYER_HEIGHT;
			
			var fixtures = world.rayCastAll( pos1, pos2 );
			
			for ( i in 0...fixtures.length )
			{
				if ( fixtures[ i ] != pbody.getFixtureList() ) {
					if ( direction > 0 ) touchGround();
					pbody.m_platformingVelocity.y = 0;
					return;
				}
			}

		}
		
		// pbody.m_linearVelocity.x = pbody.m_platformingVelocity.x * 0.1;
		// pbody.m_linearVelocity.y = pbody.m_platformingVelocity.y * 0.1;
		// pbody.m_platformingVelocity.x *= 0.95;
		
		/*trace( pbody.m_platformingVelocity.x );
		trace( pbody.m_platformingVelocity.y );
		
		trace( pbody.m_linearVelocity.x );
		trace( pbody.m_linearVelocity.y );*/
	}
	
	override public function jump() {
		body.m_platformingVelocity.y = Settings.VPLAYER_JUMP_VELOCITY;
		
		jumpTimeStart = Lib.getTimer();
		jumpHeightStart = body.getPosition().y;
		jumpHighest = jumpHeightStart;
	}
	
	override public function stopJump() {
		if (body.m_platformingVelocity.y > 0) return;
		body.m_platformingVelocity.y = 0;
	}
		
	override public function applyHorizontalMove( direction:Float ) {
		if ( isOnGround ){
			// body.applyForce( new B2Vec2( direction * Settings.PLATFORMING_HORIZONTAL_VELOCITY_ON_GROUND), body.getWorldCenter() );
			// trace( "On ground" );
		}
		else {
			// body.applyForce( new B2Vec2( direction * Settings.PLATFORMING_HORIZONTAL_VELOCITY_IN_AIR), body.getWorldCenter() );
			// trace( "on air" );
		}
		
		keyPressed = 0;
		
		// raycasting if we can move in that direction
		if ( Settings.VPLAYER_RAYCAST && direction != 0 ) 
		{
			var pos1 = body.getPosition().copy();
			pos1.y += 0.5;
			
			var pos2 = pos1.copy();
			pos2.x += direction * 0.6;
			
			var fixtures = world.rayCastAll( pos1, pos2 );
			
			for ( i in 0...fixtures.length )
			{
				if ( fixtures[ i ] != body.getFixtureList() ) {
					// trace( "collided on right side" );
					return;
				}
			}
		}
		
		// if going in the opposite way, slow down first
		if ( ( -direction * body.m_platformingVelocity.x ) >= Settings.VPLAYER_HORIZONTAL_VELOCITY ) 
			body.m_platformingVelocity.x *= Settings.VPLAYER_SLOWDOWN_MULTIPLIER;
		else
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
	
	public function addContact( contact:B2Contact ):Void {
		contacts.push( contact );
		// onContact( contact );
	}
	
	public function endContact( contact:B2Contact ):Void {
		contacts.remove( contact );
	}
	
	
	public function onContact( contact:B2Contact):Void {
		
		if ( Settings.VPLAYER_RESPOND_TO_CONTACTS == false ) return;
		
		var normal = contact.getManifold().m_localPlaneNormal;
		
		if ( normal.x < -0.5 ) 
		{
			if (  body.m_platformingVelocity.x >= 0 ) {
				body.m_platformingVelocity.x = 0;
			} else {
			}
		}
		else if ( normal.x > 0.5 ) {
			if (  body.m_platformingVelocity.x < 0 ) {
				
				body.m_platformingVelocity.x = 0;
			} else {
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
		
	}
	
}