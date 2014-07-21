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
	
	public class Ascenseur extends Sprite{
		private var ZoneTexte:TextField;
		private var GraphiqueDefilement:Shape;
		private var FondAscenseur:Shape;
		public static const MAJ:String = "miseAJour";
		public static const REDRAW:String = "redraw";
		private var BarreDefilement:MovieClip;
		private var ClipDefilement:Object;
		private var maxAscenseur:Boolean;
		private var arrayCouleurs:Array = new Array();
		private var scrollControlable = false;
		private var couleurFond:uint;
		private var couleurBarre:uint;
		private var couleurBarreOver:uint;

		public function Ascenseur(pZoneTexte:TextField, pCouleurFond:uint = 0xffffff, pCouleurBarre:uint = 0x000000, pCouleurBarreOver:uint = 0x000000, ajoutX:int = 0, ajoutY:int = 0) {
			TweenPlugin.activate([TintPlugin]);
			TweenPlugin.activate([MotionBlurPlugin, BlurFilterPlugin]);
			this.ZoneTexte = pZoneTexte;
			this.couleurFond = pCouleurFond;
			this.couleurBarre = pCouleurBarre;
			this.couleurBarreOver = pCouleurBarreOver;
			this.x = this.ZoneTexte.x + this.ZoneTexte.width + 8 + ajoutX;
			this.y = this.ZoneTexte.y + 2 + ajoutY;
			this.ZoneTexte.mouseWheelEnabled = false;
			this.ZoneTexte.parent.addChild(this);
			this.drawAscenseur();
			this.ZoneTexte.addEventListener(Ascenseur.MAJ, rafraichirAscenseur);
			this.ZoneTexte.addEventListener(Ascenseur.REDRAW, drawAscenseur);
			this.rafraichirAscenseur();
			this.placeMaxAscenseur();
			this.mouseChildren = true;
			this.ZoneTexte.addEventListener(Event.SCROLL, detectionSroll);
		}
		
		private function drawAscenseur(e:Event = null):void 
		{
			while (this.numChildren > 0) {
				this.removeChildAt(this.numChildren-1);
			}
			
			this.FondAscenseur = new Shape();
			this.FondAscenseur.graphics.beginFill(this.couleurFond);
			this.FondAscenseur.graphics.drawRoundRect(0, 0, 4, this.ZoneTexte.height - 2, 6);
			this.FondAscenseur.graphics.endFill();
			this.GraphiqueDefilement = new Shape();
			this.GraphiqueDefilement.graphics.beginFill(this.couleurBarre);
			this.GraphiqueDefilement.graphics.drawRoundRect(0, 0, 4, this.ZoneTexte.height - 2, 6);
			this.GraphiqueDefilement.graphics.endFill();
			this.addChild(FondAscenseur);
			this.BarreDefilement = new MovieClip();
			this.BarreDefilement.addChild(GraphiqueDefilement);
			this.addChild(BarreDefilement);
			this.BarreDefilement.addEventListener(MouseEvent.MOUSE_DOWN, debutDefilement);
			this.FondAscenseur.addEventListener(MouseEvent.CLICK, defileToPoint);
			this.ajouterEffetCouleurs(this.BarreDefilement, this.couleurBarre, this.couleurBarreOver);
			if (e != null) {
				this.rafraichirAscenseur();
				this.placeMaxAscenseur();
			}
		}
		
		private function defileToPoint(e:MouseEvent):void 
		{
			
		}
		
		private function detectionSroll(e:Event):void 
		{
			if (!scrollControlable) {
				this.defilerBarre();
			}
		}

		private function effetCouleur(e:MouseEvent=null, mc=null):void 
		{
			var cibleEffet = (mc != null) ? mc : e.target;
			if(!arrayCouleurs[cibleEffet]['LOCK']){
				var couleurTeinte:uint;
				if(cibleEffet.hasEventListener(MouseEvent.MOUSE_OVER)){
					cibleEffet.removeEventListener(MouseEvent.MOUSE_OVER, effetCouleur);
					cibleEffet.addEventListener(MouseEvent.MOUSE_OUT, effetCouleur);
					couleurTeinte = this.arrayCouleurs[cibleEffet]['OVER'];
				}else {
					cibleEffet.addEventListener(MouseEvent.MOUSE_OVER, effetCouleur);
					cibleEffet.removeEventListener(MouseEvent.MOUSE_OUT, effetCouleur);
					couleurTeinte = this.arrayCouleurs[cibleEffet]['OUT'];
				}
				
					TweenLite.to(cibleEffet, 1, { tint:couleurTeinte, ease:Back.easeOut } );
			}
		}
		
		private function ajouterEffetCouleurs(mc:Object, couleur1, couleur2=null):Array {
			this.arrayCouleurs[mc] = new Array();
			this.arrayCouleurs[mc]['OUT'] = couleur1;
			this.arrayCouleurs[mc]['OVER'] = couleur2;
			mc.addEventListener(MouseEvent.MOUSE_OVER, effetCouleur);
			return [couleur1, couleur2];
		}
		
		private function finDefilement(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, finDefilement);
			ClipDefilement.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, rafraichirAscenseur);
			if (arrayCouleurs[ClipDefilement]['LOCK']) {
				arrayCouleurs[ClipDefilement]['LOCK'] = false;
				effetCouleur(null, ClipDefilement);
			}
			this.scrollControlable = false;
		}
		
		private function debutDefilement(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, finDefilement);
			ClipDefilement = e.target;
			ClipDefilement.startDrag(false, new Rectangle(FondAscenseur.x, FondAscenseur.y, FondAscenseur.width - ClipDefilement.width, FondAscenseur.height - ClipDefilement.height+1));
			stage.addEventListener(MouseEvent.MOUSE_MOVE, rafraichirAscenseur);
			if (arrayCouleurs[ClipDefilement] && !arrayCouleurs[ClipDefilement]['LOCK']) {
				arrayCouleurs[e.target]['LOCK'] = true;
			}
			this.scrollControlable = true;
		}
		
		
		private function scrollSouris(e:MouseEvent):void 
		{
			if (this.ZoneTexte.maxScrollV != 1) {
				this.ZoneTexte.scrollV -= (e.delta < 0) ? -1 : 1;
			}
			e.stopImmediatePropagation();
		}
		
		private function defilerBarre():void {
			var defilageBarre = int(((this.ZoneTexte.scrollV - 1) / (this.ZoneTexte.maxScrollV - 1)) * (FondAscenseur.height-BarreDefilement.height));
			TweenLite.to(BarreDefilement, .5, { y:defilageBarre + 1, motionBlur: { strength:2.5, quality:3 }} );
		}
		
		private function placeMaxAscenseur():void {
			//TweenLite.to(BarreDefilement, 1, {y:int((FondAscenseur.height-BarreDefilement.height)+1)});
			BarreDefilement.y = int((FondAscenseur.height-BarreDefilement.height)+1);
			//TweenLite.to(ZoneTexte, 1, {scrollV:ZoneTexte.maxScrollV});
			this.ZoneTexte.scrollV = this.ZoneTexte.maxScrollV;
		}
		
		private function rafraichirAscenseur(e:Event=null):void 
		{
			if (e is MouseEvent) {
				var defilage = Math.ceil(this.ZoneTexte.maxScrollV * ((ClipDefilement.y-1) / (FondAscenseur.height-ClipDefilement.height)));
				this.ZoneTexte.scrollV = (defilage > 0) ? defilage : 1;
				return;
			}
			if (this.ZoneTexte.maxScrollV != 1) {
				if(!this.hasEventListener(MouseEvent.MOUSE_WHEEL)){
					this.addEventListener(MouseEvent.MOUSE_WHEEL, scrollSouris);
					this.ZoneTexte.addEventListener(MouseEvent.MOUSE_WHEEL, scrollSouris, false, 1);
				}
					maxAscenseur = int(BarreDefilement.y - 1) == int(FondAscenseur.height - BarreDefilement.height);
					this.visible = true;
					var nouvelleHauteur:int = int(((this.ZoneTexte.numLines - this.ZoneTexte.maxScrollV) / this.ZoneTexte.numLines) * this.ZoneTexte.height);
					if (nouvelleHauteur < 5) {
						nouvelleHauteur = 5;
					}
					this.BarreDefilement.height = nouvelleHauteur;
					if (maxAscenseur) {
						this.placeMaxAscenseur();
					}	
			}else {
				if(this.hasEventListener(MouseEvent.MOUSE_WHEEL)){
					this.removeEventListener(MouseEvent.MOUSE_WHEEL, scrollSouris);
					this.ZoneTexte.removeEventListener(MouseEvent.MOUSE_WHEEL, scrollSouris);
				}
					this.visible = false;
			}
		}
	}
}