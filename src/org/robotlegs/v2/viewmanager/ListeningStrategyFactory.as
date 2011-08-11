package org.robotlegs.v2.viewmanager 
{	
	public class ListeningStrategyFactory implements IListeningStrategyFactory
	{
		 public function createStrategyLike(strategy:IListeningStrategy):IListeningStrategy
		 {
		 	return new strategy['constructor'](strategy.targets);
		 }
	}
}