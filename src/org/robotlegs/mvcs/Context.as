package org.robotlegs.mvcs
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.core.ICommandFactory;
	import org.robotlegs.core.IContext;
	import org.robotlegs.core.IEventBroadcaster;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorFactory;
	import org.robotlegs.core.IReflector;
	
	public class Context implements IContext
	{
		protected var contextView:DisplayObjectContainer;
		protected var injector:IInjector;
		protected var reflector:IReflector;
		protected var commandFactory:ICommandFactory;
		protected var eventDispatcher:IEventDispatcher;
		protected var eventBroadcaster:IEventBroadcaster;
		protected var mediatorFactory:IMediatorFactory;
		
		/**
		 * Default MVCS Context Implementation
		 * @param contextView The root view node of the context. The context will listen for ADDED_TO_STAGE events on this node
		 * @param injector An Injector to use for this context
		 * @param reflector A Reflector to use for this context
		 * @param autoStartup Should this context automatically invoke it's <code>startup</code> method when it's <code>contextView</code> arrives on Stage?
		 *
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
		 */
		public function startup():void
		{
		}
		
		/**
		 * Return the <code>Context</code>'s IEventDispatcher
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
			initializeDispatcher();
			initializeFactories();
			initializeInjections();
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
			startup();
		}
		
		/**
		 * Initialize our EventDispatcher and EventBroadcaster
		 * The EventBroadcaster is a simple wrapper around the EventDispatcher
		 * @param eventDispatcher The <code>IEventDispatcher</code> to use for context communication
		 */
		protected function initializeDispatcher(eventDispatcher:IEventDispatcher = null):void
		{
			this.eventDispatcher = eventDispatcher ? eventDispatcher : new EventDispatcher();
			this.eventBroadcaster = new EventBroadcaster(this.eventDispatcher);
		}
		
		/**
		 * Initialize the context's Command and Mediator Factories
		 * @param commandFactory The <code>ICommandFactory</code>
		 * @param mediatorFactory The <code>IMediatorFactory</code>
		 */
		protected function initializeFactories(commandFactory:ICommandFactory = null, mediatorFactory:IMediatorFactory = null):void
		{
			this.commandFactory = commandFactory ? commandFactory : new CommandFactory(this.eventDispatcher, injector, reflector);
			this.mediatorFactory = mediatorFactory ? mediatorFactory : new MediatorFactory(this.contextView, injector, reflector);
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