package net.boyblack.robotlegs.mvcs
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	import net.boyblack.robotlegs.core.ICommand;
	import net.boyblack.robotlegs.core.ICommandFactory;
	import net.boyblack.robotlegs.core.IEventBroadcaster;
	import net.boyblack.robotlegs.core.IMediatorFactory;
	import net.expantra.smartypants.Injector;

	public class Command implements ICommand
	{
		[Inject( name='mvcsContextView' )]
		public var contextView:DisplayObjectContainer;

		[Inject( name='mvcsCommandFactory' )]
		public var commandFactory:ICommandFactory;

		[Inject( name='mvcsEventBroadcaster' )]
		public var eventBroadcaster:IEventBroadcaster;

		[Inject( name='mvcsInjector' )]
		public var injector:Injector;

		[Inject( name='mvcsMediatorFactory' )]
		public var mediatorFactory:IMediatorFactory;

		public function Command()
		{
		}

		public function execute():void
		{
		}

		protected function dispatchEvent( event:Event ):void
		{
			eventBroadcaster.dispatchEvent( event );
		}

	}
}