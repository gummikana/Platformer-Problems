package com.grapefrukt.utils;
import com.bit101.components.Accordion;
import com.bit101.components.CheckBox;
import com.bit101.components.HBox;
import com.bit101.components.HUISlider;
import com.bit101.components.Label;
import com.bit101.components.VBox;
import com.bit101.components.Window;
import com.grapefrukt.games.platprob.Settings;
import haxe.rtti.Meta;
import nme.display.DisplayObjectContainer;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.Lib;
import nme.ui.Keyboard;
import Type;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */

class Property {
	public function new(){}
	
	public var name:String;
	public var comment:String;
	public var type:ValueType;
	public var value:Dynamic;
	public var max:Float;
	public var min:Float;
	public var order:String = "";
	public var header:String = "";
}

class Toggler extends Sprite {

		private var _targetClass:Dynamic;
		private var _properties:Array<Property>;
		
		public function new(targetClass:Dynamic, visible:Bool = false) {
			super();
			_targetClass = targetClass;
			this.visible = visible;
			
			reset();
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}
		
		public function reset() {
			var metadata = Meta.getStatics(_targetClass);
			var fields = Type.getClassFields(_targetClass);
			
			_properties = [];
			var property:Property;
			
			for (field in fields) {
				if (field == "__meta__") continue;
				if (field == "init__") continue;
				
				property = new Property();
				
				property.name = field;
				property.value = Reflect.field(_targetClass, field);
				property.type = Type.typeof(property.value);
				property.header = getGroupName(field);
				
				if (property.type == ValueType.TFloat || property.type == ValueType.TInt) {
					property.min = property.value / 2;
					property.max = property.value * 2;
				}
				
				//for each (tag in variable.metadata.(@name == "comment")) property.comment = tag.arg.@value;
				//for each (tag in variable.metadata.(@name == "max")) property.max = tag.arg.@value;
				//for each (tag in variable.metadata.(@name == "min")) property.min = tag.arg.@value;
				//for each (tag in variable.metadata.(@name == "o")) property.order = tag.arg.@value;
				//for each (tag in variable.metadata.(@name == "header")) property.header = tag.arg.@value;
				
				var meta = Reflect.field(metadata, field);
				if (meta != null) {
					var range = Reflect.field(meta, "range");
					if (range != null) {
						property.min = range[0];
						property.max = range[1];
					}
				}
				
				_properties.push(property);
			}
			
			_properties.sort(_sort);
			
			while (numChildren > 0) removeChildAt(0);
			
			var settingWindow:Window = new Window(this, 10, 10);
			settingWindow.title = "JUICEATRON 7001 ZZ";
			settingWindow.width = 250;
			settingWindow.height = Settings.STAGE_H - 50;
			
			var accordion:Accordion = new Accordion(settingWindow);
			var window:Window = null;
			
			for (property in _properties) {
				if (window == null || (window.title != property.header && property.header != "")) {
					accordion.addWindowAt(property.header, accordion.numWindows);
					window = accordion.getWindowAt(accordion.numWindows - 1);
					var container:VBox = new VBox(window.content, 10, 10);
				}
				
				var row:HBox = new HBox(cast(window.content.getChildAt(0), DisplayObjectContainer));
				var label:Label = new Label(row, 0, 0, prettify(property.name, property.header));
				label.autoSize = false;
				label.width = 120;
				
				if (Type.enumEq(property.type, ValueType.TBool)) {
					var checkbox:CheckBox = new CheckBox(row, 0, 0, "");
					checkbox.selected = property.value;
					checkbox.addEventListener(Event.CHANGE, getToggleClosure(checkbox, property.name));
				} else if (Type.enumEq(property.type, ValueType.TFloat) || Type.enumEq(property.type, ValueType.TInt)) {
					var slider:HUISlider = new HUISlider(row, 0, 0, "");
					slider.width = 130;
					slider.minimum = property.min;
					slider.maximum = property.max;
					slider.value = property.value;
					if (Type.enumEq(property.type, ValueType.TInt)) slider.tick = 1;
					slider.addEventListener(Event.CHANGE, getSliderClosure(slider, property.name));
				}
			}
			
			accordion.height = Settings.STAGE_H - 50 - 20;
			accordion.width = 250;
		}
		
		public function setAll(value:Bool) {
			for (property in _properties) {
				if (property.name == "EFFECT_SCREEN_COLORS") continue;
				if (property.name == "EFFECT_PADDLE_SMILE") {
					if (value) {
						_targetClass[property.name] = 100;
					} else {
						_targetClass[property.name] = 0;
					}
					
				}
				if (property.type == "Boolean") _targetClass[property.name] = value;
			}
			reset();
		}
		
		private function prettify(name:String, header:String):String {
			name = StringTools.replace(name, header, "");
			name = StringTools.replace(name, "_", " ");
			return name;
		}
		
		private function getGroupName(name:String):String {
			return name.substr(0, name.indexOf("_"));
		}
		
		private function getToggleClosure(checkbox:CheckBox, field:String) {
			return function(e:Event) {
				Reflect.setField(_targetClass, field, checkbox.selected);
			}
		}
		
		private function getSliderClosure(slider:HUISlider, field:String) {
			return function(e:Event) {
				Reflect.setField(_targetClass, field, slider.value);
			}
		}
		
		private function handleAddedToStage(e:Event) {
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
		
		private function handleKeyDown(e:KeyboardEvent) {
			if (e.keyCode == Keyboard.TAB) visible = !visible;
		}
		
		private function _sort(p1:Property, p2:Property):Int {
			if (p1.order == "" && p2.order != "") return 1;
			if (p1.order != "" && p2.order == "") return -1;
			
			if (p1.order < p2.order) return -1;
			if (p1.order > p2.order) return 1;
			
			if (p1.name < p2.name) return -1;
			if (p1.name > p2.name) return 1;
			return 0;
		}
	
}