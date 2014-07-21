package fr.Interface.Evenements{
	import flash.events.*;
	import fr.Interface.CheckCase;

	public class CheckCaseEvent extends Event {
		public static const COCHE:String = "Coche";
		public static const DECOCHE:String = "Decoche";
		public var checkcase:CheckCase;
		
		public function CheckCaseEvent(EventType:String, instanceCB:CheckCase) {
			super(EventType);
			this.checkcase = instanceCB;
		}
	}
}