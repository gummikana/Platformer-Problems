package com.grapefrukt.utils;
import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */

 enum Input {
	LEFT;
	RIGHT;
	JUMP;
}

typedef InputTuple = {
	enabled : Bool,
	isNew : Bool
}

class KeyInputUtil {

	private var inputs:Map<Int, InputTuple>;
	private var keymap:Map<Int, Input>;
	
	public function new(stage:Stage) {
		stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKey);
		stage.addEventListener(KeyboardEvent.KEY_UP, handleKey);
		inputs = new Map<Int, InputTuple>();
		keymap = new Map<Int, Input>();
	}
	
	public function map(key:Int, input:Input) {
		keymap.set(key, input);
	}
	
	private function handleKey(e:KeyboardEvent):Void {
		if (!keymap.exists(e.keyCode)) return;
		
		var state = e.type == KeyboardEvent.KEY_DOWN;
		var input = Type.enumIndex(keymap.get(e.keyCode));
		if (inputs.exists(input) && inputs.get(input).enabled == state) return;
		
		inputs.set(input, { enabled : state, isNew : true } );
	}
	
	public function isDown(key:Input, useNewFlag:Bool = false):Bool {
		var input = inputs.get(Type.enumIndex(key));
		if (input == null) return false;
		
		if (useNewFlag) {
			if (!input.isNew) return false;
			input.isNew = false;
		}
		
		return input.enabled;
	}
	
	public function hasInput():Bool {
		for (input in inputs) if (input.enabled) return true;
		return false;
	}
	
}