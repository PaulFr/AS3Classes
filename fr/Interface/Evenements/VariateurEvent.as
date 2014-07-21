package fr.Interface.Evenements {
	import flash.events.*;
	
	public class VariateurEvent extends Event {
		public static const VALUE:String = "value";
		public static const CHANGE:String = "change";
		public var value:Number;
		
		public function VariateurEvent(event:String, value:Number) {
			super(event);
			this.value = value;
		}
	}
}