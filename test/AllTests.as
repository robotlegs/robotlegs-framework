package {
	/**
	 * This file has been automatically created using
	 * #!/usr/bin/ruby script/generate suite
	 * If you modify it and run this script, your
	 * modifications will be lost!
	 */

	import asunit.framework.TestSuite;
//	import org.robotlegs.v2.viewmanager.ContainerViewBindingTest;
	import org.robotlegs.v2.viewmanager.ContainerViewFinderTest;
//	import org.roburntlegs.experiments.ViewManagerTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
//			addTest(new org.robotlegs.v2.viewmanager.ContainerViewBindingTest());
			addTest(new org.robotlegs.v2.viewmanager.ContainerViewFinderTest());
//			addTest(new org.roburntlegs.experiments.ViewManagerTest());
		}
	}
}
