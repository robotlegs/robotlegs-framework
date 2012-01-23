//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.objectProcessor.impl
{
	import flash.display.Sprite;
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.core.messaging.MessageDispatcher;

	public class TypeCachedObjectProcessorTest extends ObjectProcessorTest
	{

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		override public function before():void
		{
			dispatcher = new MessageDispatcher();
			objectProcessor = new TypeCachedObjectProcessor(dispatcher);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function cached_type_should_not_be_matched_again():void
		{
			var matchCount:int = 0;
			objectProcessor.addObjectHandler(new CallbackMatcher(true, function():void {
				matchCount++;
			}), new Function());
			objectProcessor.matches(Sprite);
			objectProcessor.matches(Sprite);
			assertThat(matchCount, equalTo(1));
		}

		[Test]
		public function cached_type_should_still_invoke_matching_handlers():void
		{
			var callCount:int = 0;
			objectProcessor.addObjectHandler(instanceOf(Sprite), function():void {
				callCount++;
			});
			objectProcessor.addObject(new Sprite());
			objectProcessor.addObject(new Sprite());
			assertThat(callCount, equalTo(2));
		}

		[Test]
		public function cached_type_should_query_matcher_after_new_matcher_added():void
		{
			var matchCount:int = 0;
			objectProcessor.addObjectHandler(new CallbackMatcher(true, function():void {
				matchCount++;
			}), new Function());
			objectProcessor.matches(Sprite);
			objectProcessor.matches(Sprite);
			objectProcessor.addObjectHandler(instanceOf(Sprite), new Function());
			objectProcessor.matches(Sprite);
			objectProcessor.matches(Sprite);
			assertThat(matchCount, equalTo(2));
		}
	}
}

import org.hamcrest.BaseMatcher;
import robotlegs.bender.core.async.safelyCallBack;

class CallbackMatcher extends BaseMatcher
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _match:Boolean;

	private var _callback:Function;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	public function CallbackMatcher(match:Boolean, callback:Function)
	{
		_match = match;
		_callback = callback;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	override public function matches(item:Object):Boolean
	{
		safelyCallBack(_callback);
		return _match;
	}
}
