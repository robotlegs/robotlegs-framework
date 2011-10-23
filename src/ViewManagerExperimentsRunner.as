package {
	
	import asunit.textui.TestRunner;
	
	public class ViewManagerExperimentsRunner extends TestRunner {

		public function ViewManagerExperimentsRunner() {
			// start(clazz:Class, methodName:String, showTrace:Boolean)
			// NOTE: sending a particular class and method name will
			// execute setUp(), the method and NOT tearDown.
			// This allows you to get visual confirmation while developing
			// visual entities
			start(AllTests, null, TestRunner.SHOW_TRACE);
		}
	}
}