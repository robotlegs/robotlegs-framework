package <%= package_name %> {
	
	import flash.events.Event;
	
	public class <%= class_name %> extends Event {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		public static const SOME_EVENT:String = "someEvent"
		
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------

		/**
		 *	@constructor
		 */
		public function <%= class_name %>(type:String, bubbles:Boolean=true, cancelable:Boolean=false ){
			super(type, bubbles, cancelable);		
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------

		override public function clone() : Event {
			return new <%= class_name %>(type, bubbles, cancelable);
		}
		
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
	}
}
