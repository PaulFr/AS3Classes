package fr.Interface
{
	import com.vizsage.as3mathlib.math.alg.Point;
	import com.vizsage.as3mathlib.math.alg.Vector;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.*;
	import flash.events.MouseEvent;
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.utils.Timer;
	
	/**
	 * @author Paul
	 */
	
	public class InfoBulle extends MovieClip 
	{
		private var texte:String;
		private var targets:Vector.<DisplayObject>;
		private var textField:TextField;
		private var graphicInfoBulle:Shape;
		private var infoBulle:MovieClip;
		private var miseEnFormeTexte:TextFormat;
		private var currentTarget:DisplayObject;
		private var timerArrive:Timer;
		private var timerActive:Timer;
		private var currentInformations:MouseEvent;
		
		public function InfoBulle(texte:String = "Une infobulle.", target:DisplayObject = null, dureeArrive:uint = 0, dureeActive:uint = 0) {
			targets = new Vector.<DisplayObject>();
			timerArrive = new Timer(dureeArrive);
			timerArrive.addEventListener(TimerEvent.TIMER, onTimerArrive);
			if (dureeActive > 0){
				timerActive = new Timer(dureeActive);
				timerActive.addEventListener(TimerEvent.TIMER, onTimerActive);
			}
			
			if (target != null) {
				this.addOn(target);
			}
			
			this.texte = texte;
			
			this.textField = new TextField();
			this.textField.text = this.texte;
			this.textField.width = 130;
			this.textField.selectable = false;
			this.textField.wordWrap = true;
			this.textField.autoSize = TextFieldAutoSize.CENTER;
			this.textField.textColor = 0xffffff;
			
			this.infoBulle = new MovieClip();
			infoBulle.alpha = 0;
		}
		
		private function creerGraphiqueInfoBulle():void
		{
			this.miseEnFormeTexte = new TextFormat();
			this.miseEnFormeTexte.font = "Calibri";
			textField.setTextFormat(this.miseEnFormeTexte);
			
			this.graphicInfoBulle = null;
			this.graphicInfoBulle = new Shape();
			this.graphicInfoBulle.graphics.beginFill(0x000000, 0.5);
			this.graphicInfoBulle.graphics.drawRoundRect(0,0, this.textField.textWidth+10, this.textField.textHeight+10, 5);
			this.graphicInfoBulle.graphics.endFill();	
		}
		
		public function addOn(target:DisplayObject):InfoBulle {
			if (target.stage != null) {
				target.addEventListener(MouseEvent.MOUSE_OVER, this.gestionInfoBulle);
				target.addEventListener(Event.REMOVED_FROM_STAGE, this.onElementDestroyed);
			}else {
				target.addEventListener(Event.ADDED_TO_STAGE, this.onElementAdded);
			}
			
			targets.push(target);
			return this;
		}
		
		private function onElementAdded(e:Event):void 
		{
			e.target.removeEventListener(Event.ADDED_TO_STAGE, this.onElementAdded);
			e.target.addEventListener(MouseEvent.MOUSE_OVER, this.gestionInfoBulle);
			e.target.addEventListener(Event.REMOVED_FROM_STAGE, this.onElementDestroyed);
		}
		
		private function onElementDestroyed(e:Event):void 
		{
			e.target.removeEventListener(Event.REMOVED_FROM_STAGE, this.onElementDestroyed);
			if (e.target == this.currentTarget) {
				this.removeInfoBulle();
			}
			e.target.removeEventListener(MouseEvent.MOUSE_OVER, this.gestionInfoBulle);
			targets.splice(targets.indexOf(e.target), 1);
		}
		
		private function onTimerArrive(e:TimerEvent):void 
		{
			this.timerArrive.reset();
			var obj:Object = {target:this.currentInformations.target, stageX:this.currentInformations.target.stage.mouseX, stageY:this.currentInformations.target.stage.mouseY};
			if(obj.target.hitTestPoint(obj.stageX, obj.stageY)){
				this.addInfoBulle(DisplayObject(obj.target), obj.stageX, obj.stageY);
				this.positionneBulle(obj);
				if (this.timerActive != null)
					this.timerActive.start();
			}
		}
		
		private function onTimerActive(e:TimerEvent):void 
		{
			this.timerActive.reset();
			//this.removeInfoBulle();
			this.currentInformations.target.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
		}
		
		private function gestionInfoBulle(e:MouseEvent):void 
		{
			if (e.type == MouseEvent.MOUSE_OVER) 
			{
				this.currentInformations = e;
				this.timerArrive.start();
			}
			else if (e.type == MouseEvent.MOUSE_MOVE) 
			{
				
				this.positionneBulle(e);
				e.updateAfterEvent();
				
			}
			else if (e.type == MouseEvent.MOUSE_OUT)
			{
				TweenLite.to(infoBulle, 0.2, { alpha:0, onComplete:this.removeInfoBulle } );
				if (this.timerActive != null)
					this.timerActive.reset();
			}
		}
		
		private function positionneBulle(e:Object):void
		{
			if (e.stageX + this.graphicInfoBulle.width > e.target.stage.stageWidth)
				{
					this.infoBulle.x = e.stageX - this.graphicInfoBulle.width;
				}
				else
				{
					this.infoBulle.x = e.stageX;
				}
				
				if (e.stageY + this.graphicInfoBulle.height + 20 > e.target.stage.stageHeight)
				{
					this.infoBulle.y = e.stageY - this.graphicInfoBulle.height - 10;
				}
				else
				{
					this.infoBulle.y = e.stageY + 20;
				}
		}
		
		private function removeInfoBulle():void
		{
			try{
				currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, this.gestionInfoBulle);
				currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, this.gestionInfoBulle);
				this.infoBulle.removeChild(this.graphicInfoBulle);
				this.infoBulle.removeChild(this.textField);
				currentTarget.stage.removeChild(infoBulle);
				this.currentTarget = null;
			}catch (e) {
				
			}
		}
		
		private function addInfoBulle(target:DisplayObject, x:Number, y:Number):void
		{
			target.addEventListener(MouseEvent.MOUSE_MOVE, this.gestionInfoBulle);
			target.addEventListener(MouseEvent.MOUSE_OUT, this.gestionInfoBulle);
			this.creerGraphiqueInfoBulle();
			this.infoBulle.addChild(this.graphicInfoBulle);
			this.infoBulle.addChild(this.textField);
			this.textField.x = 2.5;
			this.textField.y = 2.5;
			target.stage.addChild(infoBulle);
			infoBulle.x = x;
			infoBulle.y = y + 20;
			TweenLite.to(infoBulle, 0.5, {alpha:1});
			this.currentTarget = target;
		}
		
		public function set text(texte:String) {
			if (this.currentTarget != null) {
				this.removeInfoBulle();
			}
			this.texte = texte;
			this.textField.text = this.texte;
			this.creerGraphiqueInfoBulle();
		}
		public function get text():String {
			return this.texte;
		}
		public override function toString():String {
			var targetsInfos:Array = new Array();
			for (var i:int = 0; i < this.targets.length; i++ ) {
				targetsInfos.push(this.targets[i]+'('+this.targets[i].name+')');
			}
			return "[InfoBulle Texte=\""+this.texte+"\" Targets=\""+targetsInfos.join(',')+"\" currentTarget=\""+this.currentTarget+"\"]";
		}
	}
	
}