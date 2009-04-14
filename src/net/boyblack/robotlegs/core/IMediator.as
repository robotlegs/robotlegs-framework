package net.boyblack.robotlegs.core
{
	
	public interface IMediator
	{
		function onRegister():void;
		function onRegisterComplete():void;
		
		function onRemove():void;
		function onRemoveComplete():void;
		
		function getViewComponent():Object;
		function setViewComponent( viewComponent:Object ):void;
		
		function findProperty( name:String, type:* ):*;
		function provideProperty( name:String, type:* ):*;
	}
}