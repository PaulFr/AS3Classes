package fr.Interface{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.text.TextField;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class Input extends Sprite {
		protected var widthI:int = 0;
		protected var heightI:int = 0;
		protected var fondInput:Shape;
		protected var saisieI:TextField;
		private var formatSaisie:TextFormat;
		
		public function Input(taillePolice:int = 14, widthI:int = 66, heightI:int = 20, couleurInput:int = 0xffffff, arrondisInput:int = 15) {
			this.widthI = widthI;
			this.heightI = heightI;
			this.fondInput = new Shape();
			this.fondInput.graphics.beginFill(couleurInput);
			this.fondInput.graphics.drawRoundRect(0, 0, this.widthI, this.heightI, arrondisInput);
			this.fondInput.graphics.endFill();
			this.addChild(fondInput);
			this.formatSaisie = new TextFormat();
			//var cFont = new Calibri_Font();
			//formatSaisie.font = cFont.fontName;
			this.formatSaisie.size = taillePolice;
			this.saisieI = new TextField();
			this.saisieI.defaultTextFormat = formatSaisie;
			this.saisieI.type = TextFieldType.INPUT;
			saisieI.text = "ee";
			this.saisieI.width = this.fondInput.width - 5;
			this.saisieI.autoSize = TextFieldAutoSize.LEFT;
			this.addChild(this.saisieI);
		}
	}
}