/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package org.robotlegs.mvcs
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.impl.NullLogger;
	import org.robotlegs.core.ICommand;
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.core.IEventBroadcaster;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.utils.createDelegate;
	
	/**
	 * Default MVCS <code>ICommandMap</code> implementation
	 */
	public class CommandMap implements ICommandMap
	{
		/**
		 * The <code>IEventDispatcher</code> to listen to
		 */
		protected var eventDispatcher:IEventDispatcher;
		
		/**
		 * The <code>IEventBroadcaster</code> to dispatch Events with
		 */
		protected var eventBroadcaster:IEventBroadcaster;
		
		/**
		 * The <code>IInjector</code> to inject with
		 */
		protected var injector:IInjector;
		
		/**
		 * The <code>ILogger</code> to log with
		 */
		protected var logger:ILogger;
		
		/**
		 * The <code>IReflector</code> to reflect with
		 */
		protected var reflector:IReflector;
		
		/**
		 * Internal
		 */
		protected var typeToCallbackMap:Dictionary;
		
		/**
		 * Creates a new <code>CommandMap</code> object
		 *
		 * @param eventDispatcher The <code>IEventDispatcher</code> to listen to
		 * @param injector An <code>IInjector</code> to use for this context
		 * @param reflector An <code>IReflector</code> to use for this context
		 */
		public function CommandMap(eventDispatcher:IEventDispatcher, injector:IInjector, reflector:IReflector, logger:ILogger = null)
		{
			this.eventDispatcher = eventDispatcher;
			this.eventBroadcaster = new EventBroadcaster(eventDispatcher);
			this.injector = injector;
			this.reflector = reflector;
			this.logger = logger ? logger : new NullLogger();
			this.typeToCallbackMap = new Dictionary(false);
		}
		
		/**
		 * @inheritDoc
		 */
		public function mapEvent(type:String, commandClass:Class, oneshot:Boolean = false):void
		{
			var message:String;
			if (reflector.classExtendsOrImplements(commandClass, ICommand) == false)
			{
				message = ContextError.E_MAP_COM_IMPL + ' - ' + commandClass;
				logger.error(message);
				throw new ContextError(message);
			}
			var callbackMap:Dictionary = typeToCallbackMap[type];
			if (callbackMap == null)
			{
				callbackMap = new Dictionary(false);
				typeToCallbackMap[type] = callbackMap;
			}
			if (callbackMap[commandClass] != null)
			{
				message = ContextError.E_MAP_COM_OVR + ' - type (' + type + ') and Command (' + commandClass + ')';
				logger.error(message);
				throw new ContextError(message);
			}
			var callback:Function = createDelegate(handleEvent, commandClass, oneshot);
			eventDispatcher.addEventListener(type, callback, false, 0, true);
			callbackMap[commandClass] = callback;
		}
		
		/**
		 * @inheritDoc
		 */
		public function unmapEvent(type:String, commandClass:Class):void
		{
			var callbackMap:Dictionary = typeToCallbackMap[type];
			if (callbackMap == null)
			{
				logger.warn('Type (' + type + ') was not mapped to commandClass (' + commandClass + ')');
				return;
			}
			var callback:Function = callbackMap[commandClass];
			if (callback == null)
			{
				logger.warn('Type (' + type + ') was not mapped to commandClass (' + commandClass + ')');
				return;
			}
			eventDispatcher.removeEventListener(type, callback, false);
			delete callbackMap[commandClass];
			logger.info('Command Class Unmapped: (' + commandClass + ') from event type (' + type + ')');
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasEventCommand(type:String, commandClass:Class):Boolean
		{
			var callbackMap:Dictionary = typeToCallbackMap[type];
			if (callbackMap == null)
			{
				return false;
			}
			return callbackMap[commandClass] != null;
		}
		
		/**
		 * Event Handler
		 * 
		 * @param event The <code>Event</code>
		 * @param commandClass The <code>ICommand<code> Class to construct and execute
		 * @param oneshot Should this command mapping be removed after execution?
		 */
		protected function handleEvent(event:Event, commandClass:Class, oneshot:Boolean):void
		{
			var command:Object = new commandClass();
			logger.info('Command Constructed: (' + commandClass + ') in response to (' + event + ')');
			var eventClass:Class = reflector.getClass(event);
			injector.bindValue(eventClass, event);
			injector.injectInto(command);
			injector.unbind(eventClass);
			command.execute();
			if (oneshot)
			{
				unmapEvent(event.type, commandClass);
			}
		}
	
	}
}