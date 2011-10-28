package <%= package_name %> {
	                                 
	import <%= package_name %>.<%= class_name %>;
	
	public class <%= support_class_name %> extends <%= class_name %> {
		
		// Testable constants
		//public static const MY_CONST:String = 'myConstant';
		
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------
		
		public function <%= support_class_name %>() {			
			// pass constants to the super constructor for properties
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden API
		//
		//--------------------------------------------------------------------------
		
		
	}
}
