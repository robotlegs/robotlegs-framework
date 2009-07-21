package org.robotlegs.mvcs
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;

	import org.robotlegs.core.IMediator;
	import org.robotlegs.core.IMediatorFactory;
	import org.robotlegs.core.IPropertyProvider;

	public class Mediator implements IMediator, IPropertyProvider
	{
		// Injection Points ///////////////////////////////////////////////////
		[Inject( name='mvcsContextView' )]
		public var contextView:DisplayObjectContainer;
		
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

		public function preRegister():void
		{
			onRegister();
		}

		public function onRegister():void
		{
		}

		public function preRemove():void
		{
			removeListeners();
			onRemove();
		}

		public function onRemove():void
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
			var parentProvider:IPropertyProvider;
			while ( ( parent = viewDo.parent as DisplayObjectContainer ) )
			{
				if ( ( parentMediator = mediatorFactory.retrieveMediator( parent ) ) )
				{
					if ( ( parentProvider = parentMediator as IPropertyProvider ) && ( val = parentProvider.provideProperty( name, type ) ) )
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

		protected function removeEventListenerFrom( dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false ):void
		{
			var params:Object;
			var i:int = listeners.length;
			while ( i-- )
			{
				params = listeners[ i ];
				if ( params.dispatcher == dispatcher && params.type == type && params.listener == listener && params.useCapture == useCapture )
				{
					dispatcher.removeEventListener( type, listener, useCapture );
					listeners.splice( i, 1 );
					return;
				}
			}
		}

		protected function dispatch( event:Event ):void
		{
			eventDispatcher.dispatchEvent( event );
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