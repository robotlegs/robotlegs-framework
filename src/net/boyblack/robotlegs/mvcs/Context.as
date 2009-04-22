package net.boyblack.robotlegs.mvcs
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import net.boyblack.robotlegs.core.ICommandFactory;
	import net.boyblack.robotlegs.core.IContext;
	import net.boyblack.robotlegs.core.IEventBroadcaster;
	import net.boyblack.robotlegs.core.IInjector;
	import net.boyblack.robotlegs.core.IMediatorFactory;
	import net.boyblack.robotlegs.core.IReflector;

	public class Context implements IContext
	{
		// Protected Properties ///////////////////////////////////////////////
		protected var contextView:DisplayObjectContainer;
		protected var injector:IInjector;
		protected var reflector:IReflector;
		protected var commandFactory:ICommandFactory;
		protected var eventDispatcher:IEventDispatcher;
		protected var eventBroadcaster:IEventBroadcaster;
		protected var mediatorFactory:IMediatorFactory;

		public function Context( contextView:DisplayObjectContainer, injector:IInjector, reflector:IReflector, autoStartup:Boolean = true )
		{
			this.contextView = contextView;
			this.injector = injector;
			this.reflector = reflector;
			initialize( autoStartup );
		}

		public function startup():void
		{
		}

		protected function initialize( autoStartup:Boolean = true ):void
		{
			initializeDispatcher();
			initializeFactories();
			initializeInjections();
			if ( autoStartup )
			{
				contextView.stage ? startup() : contextView.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true );
			}
		}

		protected function onAddedToStage( e:Event ):void
		{
			contextView.removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage )
			startup();
		}

		protected function initializeDispatcher( eventDispatcher:IEventDispatcher = null ):void
		{
			this.eventDispatcher = eventDispatcher ? eventDispatcher : new EventDispatcher();
			this.eventBroadcaster = new EventBroadcaster( this.eventDispatcher );
		}

		protected function initializeFactories( commandFactory:ICommandFactory = null, mediatorFactory:IMediatorFactory = null ):void
		{
			this.commandFactory = commandFactory ? commandFactory : new CommandFactory( this.eventDispatcher, injector, reflector );
			this.mediatorFactory = mediatorFactory ? mediatorFactory : new MediatorFactory( this.contextView, injector, reflector );
		}

		protected function initializeInjections():void
		{
			injector.bindValue( DisplayObjectContainer, contextView, 'mvcsContextView' );
			injector.bindValue( IInjector, injector, 'mvcsInjector' );
			injector.bindValue( IEventDispatcher, eventDispatcher, 'mvcsEventDispatcher' );
			injector.bindValue( IEventBroadcaster, eventBroadcaster, 'mvcsEventBroadcaster' );
			injector.bindValue( ICommandFactory, commandFactory, 'mvcsCommandFactory' );
			injector.bindValue( IMediatorFactory, mediatorFactory, 'mvcsMediatorFactory' );
		}

	}
}