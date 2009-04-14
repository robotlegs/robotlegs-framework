package net.boyblack.robotlegs.mvcs
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;

	import net.boyblack.robotlegs.core.IMediator;
	import net.boyblack.robotlegs.core.IMediatorFactory;

	public class Mediator implements IMediator
	{
		// Injection Points ///////////////////////////////////////////////////
		[Inject( name='mvcsMediatorFactory' )]
		public var mediatorFactory:IMediatorFactory;

		[Inject( name='mvcsEventDispatcher' )]
		public var eventDispatcher:IEventDispatcher;

		// Protected Properties ///////////////////////////////////////////////
		protected var viewComponent:Object;
		protected var listeners:Array;

		// API ////////////////////////////////////////////////////////////////
		public function Mediator()
		{
			listeners = new Array();
		}

		public function onRegister():void
		{
			onRegisterComplete();
		}

		public function onRegisterComplete():void
		{
		}
		
		public function onRemove():void
		{
			removeListeners();
			onRemoveComplete();
		}

		public function onRemoveComplete():void
		{
		}
		
		public function getViewComponent():Object
		{
			return viewComponent;
		}

		public function setViewComponent( viewComponent:Object ):void
		{
			this.viewComponent = viewComponent;
		}

		public function findProperty( name:String, type:* ):*
		{
			var start:int = getTimer();
			var val:*;
			var viewDo:DisplayObject = getViewComponent() as DisplayObject;
			var parent:DisplayObjectContainer;
			var parentMediator:IMediator;
			while ( ( parent = viewDo.parent as DisplayObjectContainer ) )
			{
				if ( ( parentMediator = mediatorFactory.retrieveMediator( parent ) ) )
				{
					if ( ( val = parentMediator.provideProperty( name, type ) ) )
					{
						trace( '[ROBOTLEGS] Found Mediator property (' + name + ') of type (' + type + ') on Mediator (' + parentMediator + ') in ' + ( getTimer() - start ) + 'ms' );
						return val;
					}
				}
				viewDo = parent;
			}
			return null;
		}

		public function provideProperty( name:String, type:* ):*
		{
			return null;
		}

		// Protected Methods //////////////////////////////////////////////////
		protected function addEventListenerTo( dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true ):void
		{
			// TODO: make weak - currently the listeners array keeps strong references.. bad
			var params:Object = { dispatcher: dispatcher, type: type, listener: listener, useCapture: useCapture };
			listeners.push( params );
			dispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}

		protected function removeListeners():void
		{
			var params:Object;
			var dispatcher:IEventDispatcher;
			while ( params = listeners.pop() )
			{
				dispatcher = params.dispatcher;
				dispatcher.removeEventListener( params.type, params.listener, params.useCapture );
			}
		}

	}
}