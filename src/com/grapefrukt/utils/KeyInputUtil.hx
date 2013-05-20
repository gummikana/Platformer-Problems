package com.grapefrukt.utils;
import nme.display.Stage;
import nme.events.KeyboardEvent;
import nme.ui.Keyboard;

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

	private var inputs:IntHash<InputTuple>;
	private var keymap:IntHash<Input>;
	
	public function new(stage:Stage) {
		stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKey);
		stage.addEventListener(KeyboardEvent.KEY_UP, handleKey);
		inputs = new IntHash<InputTuple>();
		keymap = new IntHash<Input>();
	}
	
	public function map(key:Int, input:Input) {
		keymap.set(key, input);
	}
	
	private function handleKey(e:KeyboardEvent):Void {
		if (!keymap.exists(e.keyCode)) return;
		inputs.set(Type.enumIndex(keymap.get(e.keyCode)), { enabled : e.type == KeyboardEvent.KEY_DOWN, isNew : true } );
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