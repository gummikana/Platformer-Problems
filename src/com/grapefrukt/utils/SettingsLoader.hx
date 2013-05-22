package com.grapefrukt.utils;
import nme.errors.Error;
import nme.events.ErrorEvent;
import nme.events.Event;
import nme.events.EventDispatcher;
import nme.events.IOErrorEvent;
import nme.events.SecurityErrorEvent;
import nme.net.URLLoader;
import nme.net.URLRequest;
import nme.Assets;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */

class SettingsLoader extends EventDispatcher {
		
	private var _loader		:URLLoader;
	private var _data		:String;
	private var _url		:String;
	private var _target		:Dynamic;
	
	public function new(url:String, target:Dynamic) {
		super();
		_target = target;
		_loader = new URLLoader();
		_loader.addEventListener(Event.COMPLETE, handleLoadComplete);
		_loader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
		_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
		reload(url);
	}
	
	public function reload(url:String = ""):Void {
		if (url != "") _url = url;
		
		#if (bakeassets)
			parse(Assets.getText(_url));
		#else
			_loader.load(new URLRequest(_url));
		#end
	}
	
	private function handleSecurityError(e:SecurityErrorEvent):Void {
		dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "security error loading settings: " + e.text));
	}
	
	private function handleIOError(e:IOErrorEvent):Void {
		dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "io error loading settings: " + e.text));
	}

	private function handleLoadComplete(e:Event):Void {
		_data = _loader.data;
		parse(_data);
		
		dispatchEvent(new Event(Event.COMPLETE));
	}
	
	public function export() {
		var name = _url.substr(_url.lastIndexOf("/") + 1);
		var fields = Type.getClassFields(_target);
		
		fields.sort(_sort);
		
		var newData = "";
		
		var widest = 0;
		for (field in fields) if (field.length > widest) widest = field.length;
		
		var group = "";
		
		for (field in fields) {
			if (field == "__meta__") continue;
			if (field == "init__") continue;
			
			var newgroup = getGroupName(field);
			
			if (group != "" && newgroup != group) newData += "\n";
			group = newgroup;
			
			newData += StringTools.rpad(field, " ", widest + 3) + Reflect.field(_target, field) + "\n";
		}
		
		newData = newData.substr(0, newData.length - 1);
		
		#if flash
			var f = new flash.net.FileReference();
			f.save(newData, name);
		#end
	}
	
	private function getGroupName(name:String):String {
		return name.substr(0, name.indexOf("_"));
	}
	
	private function _sort(s1:String, s2:String):Int {
		if (s1 < s2) return -1;
		if (s1 > s2) return 1;
		return 0;
	}

	private function parse(data:String){
		var r = ~/^(?<!#)(\w+)\s+(.*?)\s*(#.*)?$/m;
		
		while (r.match(data)) {
			setValue(r.matched(1), r.matched(2));
			data = r.matchedRight();
		}
	}
	
	private function setValue(name:String, value:Dynamic):Void {
		if (Std.string(value) == "true") {
			Reflect.setField(_target, name, true);
		} else if(Std.string(value) == "false") {
			Reflect.setField(_target, name, false);
		} else {
			Reflect.setField(_target, name, value);
			if (value != Reflect.field(_target, name)) throw new Error("Failed setting value!");
		}
	}

}