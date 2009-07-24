package org.robotlegs.mvcs
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import org.robotlegs.core.ICommand;
	import org.robotlegs.core.ICommandFactory;
	import org.robotlegs.core.IEventBroadcaster;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorFactory;
	
	/**
	 * An <code>ICommand</code> implementation
	 */
	public class Command implements ICommand
	{
		[Inject(name='mvcsContextView')]
		public var contextView:DisplayObjectContainer;
		
		[Inject(name='mvcsCommandFactory')]
		public var commandFactory:ICommandFactory;
		
		[Inject(name='mvcsEventBroadcaster')]
		public var eventBroadcaster:IEventBroadcaster;
		
		[Inject(name='mvcsInjector')]
		public var injector:IInjector;
		
		[Inject(name='mvcsMediatorFactory')]
		public var mediatorFactory:IMediatorFactory;
		
		public function Command()
		{
		}
		
		/**
		 * A default execute method
		 * Override this method in your <code>Command</code>
		 */
		public function execute():void
		{
		}
		
		/**
		 * A helper method to dispatch Events on the default Event Broadcaster
		 * @param event The Event to dispatch
		 */
		protected function dispatch(event:Event):void
		{
			eventBroadcaster.dispatchEvent(event);
		}
	
	}
}