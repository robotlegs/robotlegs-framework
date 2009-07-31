package org.robotlegs.mvcs
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.impl.NullLogger;
	import org.robotlegs.core.ICommandFactory;
	import org.robotlegs.core.IContext;
	import org.robotlegs.core.IEventBroadcaster;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorFactory;
	import org.robotlegs.core.IReflector;
	
	public class Context implements IContext
	{
		protected var contextView:DisplayObjectContainer;
		protected var logger:ILogger;
		protected var injector:IInjector;
		protected var reflector:IReflector;
		protected var commandFactory:ICommandFactory;
		protected var eventDispatcher:IEventDispatcher;
		protected var eventBroadcaster:IEventBroadcaster;
		protected var mediatorFactory:IMediatorFactory;
		
		/**
		 * Default Context Implementation
		 * @param contextView The root view node of the context. The context will listen for ADDED_TO_STAGE events on this node
		 * @param injector An Injector to use for this context
		 * @param reflector A Reflector to use for this context
		 * @param autoStartup Should this context automatically invoke it's <code>startup</code> method when it's <code>contextView</code> arrives on Stage?
		 */
		public function Context(contextView:DisplayObjectContainer, injector:IInjector, reflector:IReflector, autoStartup:Boolean = true)
		{
			this.contextView = contextView;
			this.injector = injector;
			this.reflector = reflector;
			initialize(autoStartup);
		}
		
		/**
		 * The Startup Hook
		 * Override this in your implementation
		 * Call <code>super.startup()</code> if you want to log the occasion.
		 */
		public function startup():void
		{
			logger.info('Context Starting Up - ' + this);
			eventBroadcaster.dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
		}
		
		/**
		 * Return this <code>Context</code>'s IEventDispatcher
		 * @return The <code>Context</code>'s IEventDispatcher
		 */
		public function getEventDispatcher():IEventDispatcher
		{
			return eventDispatcher;
		}
		
		/**
		 * Initialize this context
		 * @param autoStartup Should this context automatically invoke it's <code>startup</code> method when it's <code>contextView</code> arrives on Stage?
		 */
		protected function initialize(autoStartup:Boolean = true):void
		{
			logger = createLogger();
			eventDispatcher = createEventDispatcher();
			eventBroadcaster = createEventBroadcaster();
			commandFactory = createCommandFactory();
			mediatorFactory = createMediatorFactory();
			initializeInjections();
			logger.info('Context Initialized - ' + this);
			if (autoStartup)
			{
				contextView.stage ? startup() : contextView.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			}
		}
		
		/**
		 * ADDED_TO_STAGE event handler
		 * Only used if <code>autoStart</code> is true but the <code>contextView</code> was not on Stage during the context's construction
		 * @param e The Event
		 */
		protected function onAddedToStage(e:Event):void
		{
			contextView.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
			logger.info('contextView has been added to the stage');
			startup();
		}
		
		protected function createLogger():ILogger
		{
			return new NullLogger();
		}
		
		protected function createEventDispatcher():IEventDispatcher
		{
			return new EventDispatcher();
		}
		
		protected function createEventBroadcaster():IEventBroadcaster
		{
			return new EventBroadcaster(eventDispatcher);
		}
		
		protected function createCommandFactory():ICommandFactory
		{
			return new CommandFactory(eventDispatcher, injector, reflector, logger);
		}
		
		protected function createMediatorFactory():IMediatorFactory
		{
			return new MediatorFactory(contextView, injector, reflector, logger);
		}
		
		/**
		 * Bind some commonly needed contextual dependencies
		 * These are named to avoid collisions
		 */
		protected function initializeInjections():void
		{
			injector.bindValue(DisplayObjectContainer, contextView, 'mvcsContextView');
			injector.bindValue(IInjector, injector, 'mvcsInjector');
			injector.bindValue(IEventDispatcher, eventDispatcher, 'mvcsEventDispatcher');
			injector.bindValue(IEventBroadcaster, eventBroadcaster, 'mvcsEventBroadcaster');
			injector.bindValue(ICommandFactory, commandFactory, 'mvcsCommandFactory');
			injector.bindValue(IMediatorFactory, mediatorFactory, 'mvcsMediatorFactory');
		}
	
	}
}