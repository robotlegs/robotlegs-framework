package {
	/**
	 * This file has been automatically created using
	 * #!/usr/bin/ruby script/generate suite
	 * If you modify it and run this script, your
	 * modifications will be lost!
	 */

	import asunit.framework.TestSuite;<% test_case_classes.each do |test_case|  %>
	import <%= test_case %>;<% end  %>

	public class AllTests extends TestSuite {

		public function AllTests() {<% test_case_classes.each do |test_case|  %>
			addTest(new <%= test_case %>());<% end  %>
		}
	}
}
