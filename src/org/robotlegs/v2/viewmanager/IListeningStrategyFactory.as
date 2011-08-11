package org.robotlegs.v2.viewmanager 
{
		
	public interface IListeningStrategyFactory 
	{
		
		function createStrategyLike(strategy:IListeningStrategy):IListeningStrategy;
		
	}
}
