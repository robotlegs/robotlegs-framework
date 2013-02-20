//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.enhancedLogging
{
	import flash.display.Sprite;
	import org.hamcrest.Matcher;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.collection.emptyArray;
	import org.hamcrest.collection.hasItem;
	import org.hamcrest.object.instanceOf;
	import org.swiftsuspenders.InjectionEvent;
	import org.swiftsuspenders.mapping.MappingEvent;
	import robotlegs.bender.extensions.enhancedLogging.support.SupportLogTarget;
	import robotlegs.bender.framework.impl.Context;
	import robotlegs.bender.framework.api.LogLevel;

	public class InjectorActivityLoggingExtensionTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var context:Context;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			context = new Context();
			context.logLevel = LogLevel.DEBUG;
			context.install(InjectorActivityLoggingExtension);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function POST_INSTANTIATE_is_logged():void
		{
			const expected:Matcher = array(InjectionEvent.POST_INSTANTIATE, instanceOf(Sprite), Sprite);
			assertThat(getLog(), hasItem(expected));
		}

		[Test]
		public function PRE_CONSTRUCT_is_logged():void
		{
			const expected:Matcher = array(InjectionEvent.PRE_CONSTRUCT, instanceOf(Sprite), Sprite);
			assertThat(getLog(), hasItem(expected));
		}

		[Test]
		public function POST_CONSTRUCT_is_logged():void
		{
			const expected:Matcher = array(InjectionEvent.POST_CONSTRUCT, instanceOf(Sprite), Sprite);
			assertThat(getLog(), hasItem(expected));
		}

		[Test]
		public function PRE_MAPPING_CREATE_is_logged():void
		{
			const expected:Matcher = array(MappingEvent.PRE_MAPPING_CREATE, Sprite, "");
			assertThat(getLog(), hasItem(expected));
		}

		[Test]
		public function no_logging_after_context_is_destroyed():void
		{
			context.initialize();
			context.destroy();
			assertThat(getLog(), emptyArray());
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function getLog():Array
		{
			const log:Array = [];
			const target:SupportLogTarget = new SupportLogTarget(function(params:Array):void {
				log.push(params);
			});
			context.addLogTarget(target);
			context.injector.map(Sprite);
			context.injector.getInstance(Sprite);
			return log;
		}
	}
}
