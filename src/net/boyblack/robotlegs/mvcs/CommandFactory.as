package net.boyblack.robotlegs.mvcs
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import net.boyblack.robotlegs.core.ICommand;
	import net.boyblack.robotlegs.core.ICommandFactory;
	import net.boyblack.robotlegs.core.IEventBroadcaster;
	import net.boyblack.robotlegs.utils.createDelegate;
	import net.expantra.smartypants.Injector;
	import net.expantra.smartypants.utils.Reflection;

	public class CommandFactory implements ICommandFactory
	{
		// Error Constants ////////////////////////////////////////////////////
		private static const E_MAP_COM_IMPL:String = 'RobotLegs CommandFactory registerCommand Error: Command Class does not implement ICommand';
		private static const E_MAP_COM_OVR:String = 'RobotLegs CommandFactory registerCommand Error: Cannot overwrite map';

		// Protected Properties ///////////////////////////////////////////////
		protected var eventDispatcher:IEventDispatcher;
		protected var eventBroadcaster:IEventBroadcaster;
		protected var injector:Injector;
		protected var typeToCallbackMap:Dictionary;

		// API ////////////////////////////////////////////////////////////////
		public function CommandFactory( injector:Injector, eventDispatcher:IEventDispatcher )
		{
			this.injector = injector;
			this.eventDispatcher = eventDispatcher;
			this.eventBroadcaster = new EventBroadcaster( eventDispatcher );
			this.typeToCallbackMap = new Dictionary( false );
		}

		public function mapCommand( type:String, commandClass:Class, oneshot:Boolean = false ):void
		{
			if ( Reflection.classExtendsOrImplements( commandClass, ICommand ) == false )
			{
				throw new Error( E_MAP_COM_IMPL + ' - ' + commandClass );
			}
			var callbackMap:Dictionary = typeToCallbackMap[ type ];
			if ( callbackMap == null )
			{
				callbackMap = new Dictionary( false );
				typeToCallbackMap[ type ] = callbackMap;
			}
			if ( callbackMap[ commandClass ] != null )
			{
				throw new Error( E_MAP_COM_OVR + ' - type (' + type + ') and Command (' + commandClass + ')' );
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
					callbackMap[ commandClass ] = null;
					trace( '[ROBOTLEGS] Command Class (' + commandClass + ') no longer mapped to event type (' + type + ') on (' + eventDispatcher + ')' );
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
			trace( '[ROBOTLEGS] Command (' + command + ') constructed in response to event (' + event + ') on (' + eventDispatcher + ')' );
			var eventClass:Class = Class( getDefinitionByName( getQualifiedClassName( event ) ) );
			injector.newRule().whenAskedFor( eventClass ).useValue( event );
			injector.injectInto( command );
			injector.newRule().whenAskedFor( eventClass ).defaultBehaviour();
			command.execute();
			if ( oneshot )
			{
				unmapCommand( event.type, commandClass );
			}
		}

	}
}