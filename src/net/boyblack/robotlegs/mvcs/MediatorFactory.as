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
		private static const E_CONF_MED_IMPL:String = 'RobotLegs MediatorFactory Config Error: Mediator Class does not implement IMediator';

		// Protected Properties ///////////////////////////////////////////////
		protected var injector:IInjector;
		protected var reflectionUtil:IReflector;
		protected var mediatorByView:Dictionary;
		protected var mediatorClassByViewClass:Dictionary;
		protected var contextView:DisplayObject;
		protected var useCapture:Boolean;

		// API ////////////////////////////////////////////////////////////////
		public function MediatorFactory( contextView:DisplayObject, injector:IInjector, reflectionUtil:IReflector, useCapture:Boolean = true )
		{
			this.contextView = contextView;
			this.injector = injector;
			this.reflectionUtil = reflectionUtil;
			this.useCapture = useCapture;
			this.mediatorByView = new Dictionary( true );
			this.mediatorClassByViewClass = new Dictionary( false );
			initializeListeners();
		}

		public function mapMediator( viewClass:Class, mediatorClass:Class ):void
		{
			if ( reflectionUtil.classExtendsOrImplements( mediatorClass, IMediator ) == false )
			{
				throw new Error( E_CONF_MED_IMPL + ' - ' + mediatorClass );
			}
			mediatorClassByViewClass[ viewClass ] = mediatorClass;
		}

		public function createMediator( viewComponent:Object ):IMediator
		{
			var mediator:IMediator = mediatorByView[ viewComponent ];
			if ( mediator == null )
			{
				var viewClass:Class = reflectionUtil.getClass( viewComponent );
				var mediatorClass:Class = mediatorClassByViewClass[ viewClass ];
				if ( mediatorClass )
				{
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
				mediator.onRemove();
				mediator.setViewComponent( null );
				injector.unbind( reflectionUtil.getClass( viewComponent ) );
				injector.unbind( reflectionUtil.getClass( mediator ) );
				injector.injectInto( mediator );
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
			mediatorClassByViewClass = null;
			contextView = null;
		}

		// Protected Methods //////////////////////////////////////////////////
		protected function initializeListeners():void
		{
			contextView.addEventListener( Event.ADDED_TO_STAGE, onAdded, useCapture, 0, true );
			contextView.addEventListener( Event.REMOVED_FROM_STAGE, onRemoved, useCapture, 0, true );
		}

		protected function removeListeners():void
		{
			contextView.removeEventListener( Event.ADDED_TO_STAGE, onAdded, useCapture );
			contextView.removeEventListener( Event.REMOVED_FROM_STAGE, onRemoved, useCapture );
		}

		protected function onAdded( e:Event ):void
		{
			if ( mediatorByView[ e.target ] == null )
			{
				createMediator( e.target );
			}
		}

		protected function onRemoved( e:Event ):void
		{
			if ( mediatorByView[ e.target ] != null )
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