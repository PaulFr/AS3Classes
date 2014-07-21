package fr.Interface{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.TextField;
	
	import fr.Interface.Evenements.VariateurEvent;
	
	public class VariateurRVB extends MovieClip {
		private var variateurRouge:Variateur;
		private var variateurVert:Variateur;
		private var variateurBleu:Variateur;
		private var couleurDefaut:int;
		private var couleurBarre:int;
		private var couleur:int;
		private var type:String;
		private var _espacement:int;
		
		public function VariateurRVB(type:String = "horizontal", couleurDefaut:int = 0, couleurBarre:int = 0) {
			this.type = type;
			this.couleurDefaut = couleurDefaut;
			this.couleurBarre = couleurBarre;
			this._espacement = 0;
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			var intervalle:Object = { min:0, max:255 };
			//création du variateur rouge
			this.variateurRouge = new Variateur();
			this.variateurRouge.colorBarreIntervalle = this.couleurBarre;
			this.variateurRouge.colorCursor = 0xff0000;
			this.variateurRouge.mode = this.type;
			this.variateurRouge.intervalle = intervalle;
			//création du variateur vert
			this.variateurVert = new Variateur();
			this.variateurVert.colorBarreIntervalle = this.couleurBarre;
			this.variateurVert.colorCursor = 0x00ff00;
			this.variateurVert.mode = this.type;
			this.variateurVert.intervalle = intervalle;
			//création du variateur bleu
			this.variateurBleu = new Variateur();
			this.variateurBleu.colorBarreIntervalle = this.couleurBarre;
			this.variateurBleu.colorCursor = 0x0000ff;
			this.variateurBleu.mode = this.type;
			this.variateurBleu.intervalle = intervalle;
			//Ajout
			this.addChild(variateurRouge);
			this.addChild(variateurVert);
			this.addChild(variateurBleu);
			//Positionnement
			if (this.type == Variateur.HORIZONTAL) {
				variateurVert.y += variateurRouge.y + variateurRouge.height + 2 + this._espacement;
				variateurBleu.y += variateurVert.y + variateurVert.height + 2 + this._espacement;
			}else {
				variateurVert.x += variateurRouge.x + variateurRouge.width + 2 + this._espacement;
				variateurBleu.x += variateurVert.x + variateurVert.width + 2 + this._espacement;
			}
			//Ecouteurs
			this.variateurRouge.addEventListener(VariateurEvent.CHANGE, onChangeValue);
			this.variateurVert.addEventListener(VariateurEvent.CHANGE, onChangeValue);
			this.variateurBleu.addEventListener(VariateurEvent.CHANGE, onChangeValue);
			this.variateurRouge.addEventListener(VariateurEvent.VALUE, onChangeValue);
			this.variateurVert.addEventListener(VariateurEvent.VALUE, onChangeValue);
			this.variateurBleu.addEventListener(VariateurEvent.VALUE, onChangeValue);
			//Valeur par defaut
			this.variateurRouge.valeur = int(int("0x" + this.couleurDefaut.toString(16).substr(0, 2)).toString(10));
			this.variateurVert.valeur = int(int("0x" + this.couleurDefaut.toString(16).substr(2, 2)).toString(10));
			this.variateurBleu.valeur = int(int("0x" + this.couleurDefaut.toString(16).substr(4, 2)).toString(10));
		}
		
		private function onChangeValue(e:VariateurEvent):void 
		{
			this.couleur = this.variateurRouge.valeur << 16 | this.variateurVert.valeur << 8 | this.variateurBleu.valeur;
			this.dispatchEvent(new VariateurEvent(e.type, this.couleur));
		}
		
		public function set codecouleur(color:int) {
			this.couleurDefaut = this.couleur = color;
		}
		public function set espacement(espace:int) {
			this._espacement = espace;
		}
		public function get codecouleur() {
			return this.couleur;
		}
	}
}