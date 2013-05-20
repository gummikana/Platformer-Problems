package com.grapefrukt.games.platprob.physics;
import box2D.dynamics.B2ContactFilter;
import box2D.dynamics.B2Fixture;


/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */

class ContactFilter extends B2ContactFilter {

	public function new() {
		super();
	}
	
	override public function shouldCollide(fixtureA:B2Fixture, fixtureB:B2Fixture):Bool {
		return super.shouldCollide(fixtureA, fixtureB);
	}
	
}