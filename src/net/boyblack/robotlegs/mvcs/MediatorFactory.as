package net.boyblack.robotlegs.mvcs
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;

	import net.boyblack.robotlegs.core.IInjector;
	import net.boyblack.robotlegs.core.IMediator;
	import net.boyblack.robotlegs.core.IMediatorFactory;
	import net.boyblack.robotlegs.core.IReflector;
	import net.boyblack.robotlegs.utils.DelayedFunctionQueue;

	public class MediatorFactory implements IMediatorFactory
	{
		// Error Constants ////////////////////////////////////////////////////
		private static const E_MAP_NOIMPL:String = 'RobotLegs Error: Mediator Class does not implement IMediator';
		private static const E_MAP_EXISTS:String = 'RobotLegs Error: Mediator Class has already been mapped to a View Class';

		// Protected Properties ///////////////////////////////////////////////
		protected var contextView:DisplayObject;
		protected var injector:IInjector;
		protected var reflectionUtil:IReflector;
		protected var useCapture:Boolean;

		protected var mediatorByView:Dictionary;
		protected var mappingConfigByView:Dictionary;
		protected var mappingConfigByViewClass:Dictionary;

		// API ////////////////////////////////////////////////////////////////
		public function MediatorFactory( contextView:DisplayObject, injector:IInjector, reflectionUtil:IReflector, useCapture:Boolean = true )
		{
			this.contextView = contextView;
			this.injector = injector;
			this.reflectionUtil = reflectionUtil;
			this.useCapture = useCapture;

			this.mediatorByView = new Dictionary( true );
			this.mappingConfigByView = new Dictionary( true );
			this.mappingConfigByViewClass = new Dictionary( false );

			initializeListeners();
		}

		public function mapMediator( viewClass:Class, mediatorClass:Class, autoRegister:Boolean = true, autoRemove:Boolean = true ):void
		{
			if ( mappingConfigByViewClass[ viewClass ] != null )
			{
				throw new ContextError( E_MAP_EXISTS + ' - ' + mediatorClass );
			}
			if ( reflectionUtil.classExtendsOrImplements( mediatorClass, IMediator ) == false )
			{
				throw new ContextError( E_MAP_NOIMPL + ' - ' + mediatorClass );
			}
			var config:MapppingConfig = new MapppingConfig();
			config.mediatorClass = mediatorClass;
			config.autoRegister = autoRegister;
			config.autoRemove = autoRemove;
			mappingConfigByViewClass[ viewClass ] = config;
		}

		public function createMediator( viewComponent:Object ):IMediator
		{
			var mediator:IMediator = mediatorByView[ viewComponent ];
			if ( mediator == null )
			{
				var viewClass:Class = reflectionUtil.getClass( viewComponent );
				var mappingConfig:MapppingConfig = mappingConfigByViewClass[ viewClass ];
				if ( mappingConfig )
				{
					var mediatorClass:Class = mappingConfig.mediatorClass;
					mediator = new mediatorClass();
					trace( '[ROBOTLEGS] Mediator Constructed: (' + mediator + ') with View Component (' + viewComponent + ')' );
					injector.bindValue( viewClass, viewComponent );
					injector.injectInto( mediator );
					injector.unbind( viewClass );
					registerMediator( mediator, viewComponent );
				}
			}
			return mediator;
		}

		public function registerMediator( mediator:IMediator, viewComponent:Object ):void
		{
			injector.bindValue( reflectionUtil.getClass( mediator ), mediator );
			mediatorByView[ viewComponent ] = mediator;
			mappingConfigByView[ viewComponent ] = mappingConfigByViewClass[ reflectionUtil.getClass( viewComponent ) ];
			mediator.setViewComponent( viewComponent );
			mediator.onRegister();
			trace( '[ROBOTLEGS] Mediator Registered: (' + mediator + ') with View Component (' + viewComponent + ')' );
		}

		public function removeMediator( mediator:IMediator ):IMediator
		{
			if ( mediator )
			{
				var viewComponent:Object = mediator.getViewComponent();
				delete mediatorByView[ viewComponent ];
				delete mappingConfigByView[ viewComponent ];
				mediator.onRemove();
				mediator.setViewComponent( null );
				// injector.unbind( reflectionUtil.getClass( viewComponent ) );
				injector.unbind( reflectionUtil.getClass( mediator ) );
				// injector.injectInto( mediator );
				trace( '[ROBOTLEGS] Mediator Removed: (' + mediator + ') with View Component (' + viewComponent + ')' );
			}
			return mediator;
		}

		public function removeMediatorByView( viewComponent:Object ):IMediator
		{
			return removeMediator( retrieveMediator( viewComponent ) );
		}

		public function retrieveMediator( viewComponent:Object ):IMediator
		{
			return mediatorByView[ viewComponent ];
		}

		public function hasMediator( viewComponent:Object ):Boolean
		{
			return mediatorByView[ viewComponent ] != null;
		}

		public function destroy():void
		{
			removeListeners();
			injector = null;
			mediatorByView = null;
			mappingConfigByView = null;
			mappingConfigByViewClass = null;
			contextView = null;
		}

		// Protected Methods //////////////////////////////////////////////////
		protected function initializeListeners():void
		{
			contextView.addEventListener( Event.ADDED_TO_STAGE, onViewAdded, useCapture, 0, true );
			contextView.addEventListener( Event.REMOVED_FROM_STAGE, onViewRemoved, useCapture, 0, true );
		}

		protected function removeListeners():void
		{
			contextView.removeEventListener( Event.ADDED_TO_STAGE, onViewAdded, useCapture );
			contextView.removeEventListener( Event.REMOVED_FROM_STAGE, onViewRemoved, useCapture );
		}

		protected function onViewAdded( e:Event ):void
		{
			var config:MapppingConfig = mappingConfigByViewClass[ reflectionUtil.getClass( e.target ) ];
			if ( config && config.autoRegister )
			{
				createMediator( e.target );
			}
		}

		protected function onViewRemoved( e:Event ):void
		{
			var config:MapppingConfig = mappingConfigByView[ e.target ];
			if ( config && config.autoRemove )
			{
				trace( '[ROBOTLEGS] MediatorFactory might have mistakenly lost an ' + e.target + ', double checking...' );
				DelayedFunctionQueue.add( possiblyRemoveMediator, e.target );
			}
		}

		// Private Methods ////////////////////////////////////////////////////
		private function possiblyRemoveMediator( viewComponent:DisplayObject ):void
		{
			if ( viewComponent.stage == null )
			{
				removeMediatorByView( viewComponent );
			}
			else
			{
				trace( '[ROBOTLEGS] False alarm for ' + viewComponent );
			}
		}

	}

}

class MapppingConfig
{
	public var mediatorClass:Class;
	public var autoRegister:Boolean;
	public var autoRemove:Boolean;
}
