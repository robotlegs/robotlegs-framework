package net.boyblack.robotlegs.core
{
	import flash.events.IEventDispatcher;

	public interface ICommandFactory
	{
		function mapCommand( type:String, commandClass:Class, oneshot:Boolean = false ):void;
		function unmapCommand( type:String, commandClass:Class ):void;
		function hasCommand( type:String, commandClass:Class ):Boolean;
	}
}