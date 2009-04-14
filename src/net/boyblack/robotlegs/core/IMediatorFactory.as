package net.boyblack.robotlegs.core
{

	public interface IMediatorFactory
	{
		function mapMediator( viewClass:Class, mediatorClass:Class ):void;
		function createMediator( viewComponent:Object ):IMediator;
		function registerMediator( mediator:IMediator, viewComponent:Object ):void;
		function removeMediator( mediator:IMediator ):IMediator;
		function removeMediatorByView( viewComponent:Object ):IMediator;
		function retrieveMediator( viewComponent:Object ):IMediator;
		function hasMediator( viewComponent:Object ):Boolean;
	}
}