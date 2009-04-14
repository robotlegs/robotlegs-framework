package net.boyblack.robotlegs.mvcs
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import net.boyblack.robotlegs.core.ICommandFactory;
	import net.boyblack.robotlegs.core.IContext;
	import net.boyblack.robotlegs.core.IEventBroadcaster;
	import net.boyblack.robotlegs.core.IMediatorFactory;
	import net.expantra.smartypants.Injector;
	import net.expantra.smartypants.SmartyPants;

	public class Context implements IContext
	{
		// Protected Properties ///////////////////////////////////////////////
		protected var contextView:DisplayObjectContainer;
		protected var eventDispatcher:IEventDispatcher;
		protected var eventBroadcaster:IEventBroadcaster;
		protected var injector:Injector;
		protected var mediatorFactory:IMediatorFactory;
		protected var commandFactory:ICommandFactory;

		public function Context( contextView:DisplayObjectContainer, autoStartup:Boolean = true )
		{
			initialize( contextView, autoStartup );
		}

		public function startup():void
		{
		}

		protected function initialize( contextView:DisplayObjectContainer, autoStartup:Boolean = true ):void
		{
			initializeContext( contextView );
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

		protected function initializeContext( contextView:DisplayObjectContainer, injector:Injector = null, eventDispatcher:IEventDispatcher = null, commandFactory:ICommandFactory = null, mediatorFactory:IMediatorFactory = null ):void
		{
			this.contextView = contextView;
			this.injector = injector ? injector : SmartyPants.getOrCreateInjectorFor( this );
			this.eventDispatcher = eventDispatcher ? eventDispatcher : new EventDispatcher();
			this.eventBroadcaster = new EventBroadcaster( this.eventDispatcher );
			this.commandFactory = commandFactory ? commandFactory : new CommandFactory( this.injector, this.eventDispatcher );
			this.mediatorFactory = mediatorFactory ? mediatorFactory : new MediatorFactory( this.injector, this.contextView );

			this.injector.newRule().whenAskedFor( Injector ).named( 'mvcsInjector' ).useValue( this.injector );
			this.injector.newRule().whenAskedFor( DisplayObjectContainer ).named( 'mvcsContextView' ).useValue( this.contextView );
			this.injector.newRule().whenAskedFor( IEventDispatcher ).named( 'mvcsEventDispatcher' ).useValue( this.eventDispatcher );
			this.injector.newRule().whenAskedFor( IEventBroadcaster ).named( 'mvcsEventBroadcaster' ).useValue( this.eventBroadcaster );
			this.injector.newRule().whenAskedFor( ICommandFactory ).named( 'mvcsCommandFactory' ).useValue( this.commandFactory );
			this.injector.newRule().whenAskedFor( IMediatorFactory ).named( 'mvcsMediatorFactory' ).useValue( this.mediatorFactory );
		}

	}
}