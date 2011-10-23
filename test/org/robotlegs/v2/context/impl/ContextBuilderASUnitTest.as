package org.robotlegs.v2.context.impl {

	import asunit.framework.TestCase;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.impl.Context;
	import org.robotlegs.v2.core.impl.ContextBuilder;

	public class ContextBuilderASUnitTest extends TestCase {
		private var builder:ContextBuilder;
		
		public function ContextBuilderASUnitTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			builder = new ContextBuilder();
		}

		override protected function tearDown():void {
			super.tearDown();
			builder = null;
		}

		public function test_context_should_have_the_parent_that_we_set_before_build():void
		{
			const parent:IContext = new Context();
			builder.withParent(parent);
			const context:IContext = builder.build();
			assertEquals(parent, context.parent);
		}
	}
}