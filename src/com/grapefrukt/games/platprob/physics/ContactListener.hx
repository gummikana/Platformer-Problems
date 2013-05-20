package com.grapefrukt.games.platprob.physics;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2ContactImpulse;
import box2D.dynamics.B2ContactListener;
import box2D.dynamics.contacts.B2Contact;
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
	
	}
	
	override public function postSolve(contact:B2Contact, impulse:B2ContactImpulse):Void {
		
	}
	
}