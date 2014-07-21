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
	import fr.Interface.Evenements.CheckCaseEvent;
	
	public class CheckCase extends Sprite{
		private const largeur:int = 10, hauteur:int = 10;
		private var fondCheckBox:Shape;
		private var encoche:Shape;
		private var etatBox:Boolean = false;
		
		public function CheckCase(posX:int = 0,posY:int = 0,couleurCase:int = 0xffffff, couleurCoche:int = 0x0000ff) {
			this.x = posX;
			this.y = posY;
			this.fondCheckBox = new Shape();
			this.fondCheckBox.graphics.beginFill(couleurCase);
			this.fondCheckBox.graphics.drawRoundRect(0, 0, largeur, hauteur, 2);
			this.fondCheckBox.graphics.endFill();
			this.addChild(fondCheckBox);
			this.encoche = new Shape();
			this.encoche.graphics.lineStyle(2, couleurCoche);
			this.encoche.graphics.moveTo(0, 0);
			this.encoche.graphics.lineTo(3, 4);
			this.encoche.graphics.lineTo(7, -7);
			this.encoche.x = ((this.fondCheckBox.width - this.encoche.width) / 2)+1.5;
			this.encoche.y = this.fondCheckBox.y + (this.fondCheckBox.height/2);
			this.addChild(encoche);
			this.encoche.visible = false;
			this.buttonMode = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function get checked ():Boolean {
			return this.etatBox;
		}
		
		public function set checked (statut:Boolean):void {
			changeEtat(statut);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			changeEtat(!this.encoche.visible);
		}
		
		private function changeEtat(statut:Boolean):void {
			if (statut) {
				this.encoche.visible = true;
				this.dispatchEvent(new CheckCaseEvent(CheckCaseEvent.COCHE, this));
				this.etatBox = true;
			}else {
				this.encoche.visible = false;
				this.dispatchEvent(new CheckCaseEvent(CheckCaseEvent.DECOCHE, this));
				this.etatBox = false;
			}
		}
	}
	
}