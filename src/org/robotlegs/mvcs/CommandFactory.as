package org.robotlegs.mvcs
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import org.robotlegs.core.ICommand;
	import org.robotlegs.core.ICommandFactory;
	import org.robotlegs.core.IEventBroadcaster;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.utils.createDelegate;

	public class CommandFactory implements ICommandFactory
	{
		// Error Constants ////////////////////////////////////////////////////
		private static const E_MAP_COM_IMPL:String = 'RobotLegs CommandFactory registerCommand Error: Command Class does not implement ICommand';
		private static const E_MAP_COM_OVR:String = 'RobotLegs CommandFactory registerCommand Error: Cannot overwrite map';

		// Protected Properties ///////////////////////////////////////////////
		protected var eventDispatcher:IEventDispatcher;
		protected var eventBroadcaster:IEventBroadcaster;
		protected var injector:IInjector;
		protected var reflector:IReflector;
		protected var typeToCallbackMap:Dictionary;

		// API ////////////////////////////////////////////////////////////////
		public function CommandFactory( eventDispatcher:IEventDispatcher, injector:IInjector, reflector:IReflector )
		{
			this.eventDispatcher = eventDispatcher;
			this.injector = injector;
			this.reflector = reflector;
			this.eventBroadcaster = new EventBroadcaster( eventDispatcher );
			this.typeToCallbackMap = new Dictionary( false );
		}

		public function mapCommand( type:String, commandClass:Class, oneshot:Boolean = false ):void
		{
			if ( reflector.classExtendsOrImplements( commandClass, ICommand ) == false )
			{
				throw new ContextError( E_MAP_COM_IMPL + ' - ' + commandClass );
			}
			var callbackMap:Dictionary = typeToCallbackMap[ type ];
			if ( callbackMap == null )
			{
				callbackMap = new Dictionary( false );
				typeToCallbackMap[ type ] = callbackMap;
			}
			if ( callbackMap[ commandClass ] != null )
			{
				throw new ContextError( E_MAP_COM_OVR + ' - type (' + type + ') and Command (' + commandClass + ')' );
			}
			var callback:Function = createDelegate( handleEvent, commandClass, oneshot );
			eventDispatcher.addEventListener( type, callback, false, 0, true );
			callbackMap[ commandClass ] = callback;
		}

		public function unmapCommand( type:String, commandClass:Class ):void
		{
			var callbackMap:Dictionary = typeToCallbackMap[ type ];
			if ( callbackMap != null )
			{
				var callback:Function = callbackMap[ commandClass ];
				if ( callback != null )
				{
					eventDispatcher.removeEventListener( type, callback, false );
					delete callbackMap[ commandClass ];
					// Use a logging interface
					trace( '[ROBOTLEGS] Command Class Unmapped: (' + commandClass + ') from event type (' + type + ') on (' + eventDispatcher + ')' );
				}
			}
		}

		public function hasCommand( type:String, commandClass:Class ):Boolean
		{
			var callbackMap:Dictionary = typeToCallbackMap[ type ];
			if ( callbackMap == null )
			{
				return false;
			}
			return callbackMap[ commandClass ] != null;
		}

		// Protected Methods //////////////////////////////////////////////////
		protected function handleEvent( event:Event, commandClass:Class, oneshot:Boolean ):void
		{
			var command:Object = new commandClass();
			// Use a logging interface
			trace( '[ROBOTLEGS] Command Constructed: (' + command + ') in response to (' + event + ') on (' + eventDispatcher + ')' );
			var eventClass:Class = reflector.getClass( event );
			injector.bindValue( eventClass, event );
			injector.injectInto( command );
			injector.unbind( eventClass );
			command.execute();
			if ( oneshot )
			{
				unmapCommand( event.type, commandClass );
			}
		}

	}
}