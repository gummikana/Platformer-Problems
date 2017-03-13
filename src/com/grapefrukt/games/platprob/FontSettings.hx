package com.grapefrukt.games.platprob;
import openfl.Assets;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

/**
 * ...
 * @author Martin Jonasson, m@grapefrukt.com
 */
class FontSettings {
	
	private static var DEFAULT_FONT:Font;

	public static function getDefaultTextField(size:Int = 72, color:Int = 0xffffff, width:Float = 100):TextField {
		var format:TextFormat = getDefaultTextFormat(size, color);
		
		var tf:TextField = new TextField();
		tf.width = width;
		tf.wordWrap = true;
		tf.embedFonts = true;
		tf.defaultTextFormat = format;
		tf.selectable = false;
		
		return tf;
	}
	
	public static function getDefaultTextFormat(size:Int = 72, color:Int = 0xffffff):TextFormat {
		if (DEFAULT_FONT == null) DEFAULT_FONT = Assets.getFont ("fonts/helvetica.ttf");
		return new TextFormat(DEFAULT_FONT.fontName, size, color);
	}
	
	#if flash
	static public function setAlign(tf:TextField, align:TextFormatAlign) {
		var f = tf.defaultTextFormat;
		f.align = align;
		tf.defaultTextFormat = f;
	}
	#else
	static public function setAlign(tf:TextField, align:String) {
		var f = tf.defaultTextFormat;
		f.align = align;
		tf.defaultTextFormat = f;
	}
	#end
	
}