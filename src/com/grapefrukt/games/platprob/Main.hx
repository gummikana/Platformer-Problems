package com.grapefrukt.games.platprob;

import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.Event;
import nme.Lib;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */

class Main extends Sprite {
	var inited:Bool;

	/* ENTRY POINT */
	
	function resize(e) {
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() {
		if (inited) return;
		inited = true;
		
		Lib.current.stage.align = StageAlign.TOP;
		Lib.current.stage.scaleMode = StageScaleMode.SHOW_ALL;

		var g = new Game();
		addChild(g);
		g.init();
	}

	/* SETUP */

	public function new() {
		super();
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) {
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() {
		// static entry point
		
		Lib.current.addChild(new Main());
	}
}
