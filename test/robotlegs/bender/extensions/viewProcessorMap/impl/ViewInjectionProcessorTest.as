//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.impl
{
	import flash.display.Sprite;
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;
	import org.swiftsuspenders.Injector;

	public class ViewInjectionProcessorTest
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:Injector;

		private var viewInjector:ViewInjectionProcessor;
		
		private var injectionValue:Sprite;
		
		private var view:ViewWithInjection;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			injector = new Injector();
			viewInjector = new ViewInjectionProcessor();
			injectionValue = mapSpriteForInjection();
			view = new ViewWithInjection();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/
		
		[Test]
		public function processFulfillsInjectionsWhenClassPassed():void
		{
			viewInjector.process(view, ViewWithInjection, injector);
			assertThat(view.injectedSprite, equalTo(injectionValue));
		}
		
		[Test]
		public function processFulfillsInjectionsWhenClassNotPassed():void
		{
			viewInjector.process(view, null, injector);
			assertThat(view.injectedSprite, equalTo(injectionValue));
		}
		
		[Test]
		public function processDoesNotRerunInjections():void
		{
			viewInjector.process(view, ViewWithInjection, injector);
			
			injector.unmap(Sprite);
			injector.map(Sprite).toValue(new Sprite());
			
			viewInjector.process(view, ViewWithInjection, injector);
			
			assertThat(view.injectedSprite, equalTo(injectionValue));
		}	
		
		protected function mapSpriteForInjection():Sprite
		{
			const injectionValue:Sprite = new Sprite();
			injector.map(Sprite).toValue(injectionValue);
			return injectionValue;
		}	
	}
}

import flash.display.Sprite;

class ViewWithInjection
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var injectedSprite:Sprite;
} 

