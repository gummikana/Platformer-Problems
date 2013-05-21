package com.grapefrukt.games.platprob.physics;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2ContactImpulse;
import box2D.dynamics.B2ContactListener;
import box2D.dynamics.contacts.B2Contact;
import com.grapefrukt.games.platprob.Player;
import com.grapefrukt.games.platprob.PlayerVelocity;
import nme.Lib;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */

class ContactListener extends B2ContactListener {
	
	public function new() {
		super();
	}
	
	override public function beginContact (contact:B2Contact):Void {
		if (!contact.isTouching()) return;
		
		var player:Player = null;
		if(Type.getClass(contact.getFixtureB().getBody().getUserData()) == Player) {
			player = cast(contact.getFixtureB().getBody().getUserData(), Player);
		} else if( Type.getClass(contact.getFixtureA().getBody().getUserData()) == Player ) {
			player = cast(contact.getFixtureA().getBody().getUserData(), Player);
		}
		
		if( player != null )
			player.touchGround();
			
		var player_velocity:PlayerVelocity = null;
		if (Type.getClass(contact.getFixtureB().getBody().getUserData()) == PlayerVelocity) {
			player_velocity = cast(contact.getFixtureB().getBody().getUserData(), PlayerVelocity);
		} else if (Type.getClass(contact.getFixtureA().getBody().getUserData()) == PlayerVelocity) {
			player_velocity = cast(contact.getFixtureA().getBody().getUserData(), PlayerVelocity);
		} 
		
		if ( player_velocity != null ) {
			player_velocity.onContact( contact );
		}
	}
	
	override public function postSolve(contact:B2Contact, impulse:B2ContactImpulse):Void {
		
	}
	
}