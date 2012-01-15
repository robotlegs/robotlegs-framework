//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.object.processor.impl
{
	import flash.utils.Dictionary;
	import org.hamcrest.Description;
	import org.hamcrest.Matcher;
	import robotlegs.bender.core.async.safelyCallBack;
	import robotlegs.bender.core.message.dispatcher.api.IMessageDispatcher;
	import robotlegs.bender.core.message.dispatcher.impl.MessageDispatcher;
	import robotlegs.bender.core.object.processor.api.IObjectProcessor;

	public class TypeCachedObjectProcessor implements IObjectProcessor
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _bindings:Array = [];

		private var _knownBindings:Dictionary = new Dictionary(true);

		private var _messageDispatcher:IMessageDispatcher;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function TypeCachedObjectProcessor(messageDispatcher:IMessageDispatcher = null)
		{
			_messageDispatcher = messageDispatcher || new MessageDispatcher();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addObjectHandler(matcher:Matcher, handler:Function):void
		{
			_bindings.push(new ObjectHandler(matcher, handler));
			flushCache();
		}

		public function addObject(object:Object, callback:Function = null):void
		{
			var matchingBindings:Array;

			// calling matches() primes the _knownBindings cache
			if (matches(object))
			{
				const type:Class = object["constructor"];
				matchingBindings = _knownBindings[type];
				for each (var binding:ObjectHandler in matchingBindings)
				{
					_messageDispatcher.addMessageHandler(object, binding.closure);
				}
			}

			_messageDispatcher.dispatchMessage(object, function(error:Object):void {
				// even with oneShot handlers we would have to clean up here as
				// a handler may have terminated the dispatch with an error
				// and we don't want to leave any handlers lying around
				for each (var matchingBinding:ObjectHandler in matchingBindings)
				{
					_messageDispatcher.removeMessageHandler(object, matchingBinding.closure);
				}
				callback && safelyCallBack(callback, error, object);
			});
		}

		public function matches(item:Object):Boolean
		{
			const type:Class = item["constructor"];

			// we've seen it before and nobody was interested
			if (_knownBindings[type] === false)
				return false;

			// we've seen it before and somebody was interested
			if (_knownBindings[type])
				return true;

			// ok, we obviously haven't seen it before
			_knownBindings[type] = false;
			for each (var binding:ObjectHandler in _bindings)
			{
				if (binding.matcher.matches(item))
				{
					_knownBindings[type] ||= [];
					_knownBindings[type].push(binding);
				}
			}
			return _knownBindings[type];
		}

		public function describeTo(description:Description):void
		{
			description.appendText("type cached object processor");
		}

		public function describeMismatch(item:Object, mismatchDescription:Description):void
		{
			mismatchDescription.appendText("was ").appendValue(item);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function flushCache():void
		{
			_knownBindings = new Dictionary(true);
		}
	}
}
