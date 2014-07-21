package fr.Interface{
	import flash.geom.Point;
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
	
	import fr.Interface.Evenements.VariateurEvent;
	
	public class Variateur extends MovieClip {
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";
		
		private var type:String;
		private var cursorColor:int;
		private var cursor:MovieClip;
		private var barreIntervalleColor:int;
		private var barreIntervalleSize:Number;
		private var barreIntervalle:MovieClip;
		private var value:Number;
		private var _intervalle:Object;
		private var zoneDrag:Rectangle;
		
		public function Variateur(type:String = Variateur.HORIZONTAL, taille:Number = 150, cursorColor:int = 0xffffff, barreIntervalleColor:int = 0x000000) {
			TweenPlugin.activate([TintPlugin]);
			TweenPlugin.activate([MotionBlurPlugin, BlurFilterPlugin]);
			this.type = type;
			this.barreIntervalleSize = taille;
			this.cursorColor = cursorColor;
			this.barreIntervalleColor = barreIntervalleColor;
			this._intervalle = { min:0, max:100 };
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			//Création du curseur
			var gCursor:Shape = new Shape();
			gCursor.graphics.beginFill(this.cursorColor);
			gCursor.graphics.drawCircle(0,0, 6.5);
			gCursor.graphics.endFill();
			var gCursorCenter:Shape = new Shape();
			gCursorCenter.graphics.beginFill(this.barreIntervalleColor);
			gCursorCenter.graphics.drawCircle(0,0, 3.5);
			gCursorCenter.graphics.endFill();
			//fin de création du curseur

			//création de la barre
			var gBarre:Shape = new Shape();
			gBarre.graphics.beginFill(this.barreIntervalleColor);
			if(this.type == Variateur.HORIZONTAL)
				gBarre.graphics.drawRoundRect(0, 0, this.barreIntervalleSize, 8, 4);
			else
				gBarre.graphics.drawRoundRect(0, 0, 8, this.barreIntervalleSize, 4);
			gBarre.graphics.endFill();
			//fin de création de la barre
			
			this.barreIntervalle = new MovieClip();
			this.barreIntervalle.addChild(gBarre);
			this.cursor = new MovieClip();
			this.cursor.addChild(gCursor);
			this.cursor.addChild(gCursorCenter);
			if (this.type == Variateur.HORIZONTAL){
				this.cursor.y += cursor.height / 3;
				this.zoneDrag = new Rectangle(0, this.cursor.y, barreIntervalleSize, 0);
			}else{
				this.cursor.x += cursor.width / 3;
				this.zoneDrag = new Rectangle(this.cursor.x, 0, 0, barreIntervalleSize);
			}
			
			this.addChild(this.barreIntervalle);
			this.addChild(this.cursor);
			this.barreIntervalle.buttonMode = true;
			this.cursor.buttonMode = true;
			
			this.cursor.addEventListener(MouseEvent.MOUSE_DOWN, onDragCursor);
			this.barreIntervalle.addEventListener(MouseEvent.CLICK, onMoveCursor);
		}
		
		
		private function onMoveCursor(e:MouseEvent):void 
		{
			var pointsCursor:Point = new Point(e.stageX, e.stageY);
			pointsCursor = globalToLocal(pointsCursor);
			this.addEventListener(Event.ENTER_FRAME, onCalculValue);
			if(type == Variateur.HORIZONTAL)
				TweenLite.to(this.cursor, .5, { x:pointsCursor.x, motionBlur: { strength:1.3, quality:3 }, onComplete:removeCalculValue} );
			else
				TweenLite.to(this.cursor, .5, { y:pointsCursor.y, motionBlur: { strength:1.3, quality:3 }, onComplete:removeCalculValue} );
			
		}
		
		private function removeCalculValue() {
			this.removeEventListener(Event.ENTER_FRAME, onCalculValue);
			this.dispatchEvent(new VariateurEvent(VariateurEvent.VALUE, this.value));
			this.dispatchEvent(new VariateurEvent(VariateurEvent.CHANGE, this.value));
		}
		

		
		private function onDragCursor(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onDropCursor);
			this.addEventListener(Event.ENTER_FRAME, onCalculValue);
			this.cursor.startDrag(false, zoneDrag);
			this.cursor.scaleX = cursor.scaleY = 1.5;
		}
		
		
		private function onDropCursor(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDropCursor);
			this.removeCalculValue();
			this.cursor.stopDrag();
			this.cursor.scaleX = cursor.scaleY = 1;
		}
		
		private function onCalculValue(e:Event=null):void 
		{
			var cursorPos:Number = (this.type == Variateur.HORIZONTAL) ? this.cursor.x : this.cursor.y;
			var coef:Number = cursorPos / this.barreIntervalleSize;
			this.value = (this._intervalle.max-this._intervalle.min)*coef+this._intervalle.min;
			this.dispatchEvent(new VariateurEvent(VariateurEvent.CHANGE, this.value));
		}
		
		public function set colorCursor(color:int) {
			this.cursorColor = color;
		}
		public function set colorBarreIntervalle(color:int) {
			this.barreIntervalleColor = color;
		}
		public function set sizeBarreIntervalle(size:Number) {
			this.barreIntervalleSize = size;
		}
		public function set mode(type:String) {
			this.type = type;
		}
		public function set intervalle(intervalle:Object) {
			this._intervalle = intervalle;
		}
		public function get valeur() {
			return this.value;
		}
		public function set valeur(valueC:Number) {
			if (valueC < this._intervalle.min || valueC > this._intervalle.max)
				throw new Error('Vous ne pouvez pas assigner une valeur qui dépasse l\'intervalle renseigné !');
			if (this.type == Variateur.HORIZONTAL)
				this.cursor.x = ((valueC - this._intervalle.min) / (this._intervalle.max - this._intervalle.min))*this.barreIntervalleSize;
			else
				this.cursor.y = ((valueC - this._intervalle.min) / (this._intervalle.max - this._intervalle.min))*this.barreIntervalleSize;
			this.value = valueC;
			this.dispatchEvent(new VariateurEvent(VariateurEvent.CHANGE, this.value));
			this.dispatchEvent(new VariateurEvent(VariateurEvent.VALUE, this.value));
		}
	}
	
}