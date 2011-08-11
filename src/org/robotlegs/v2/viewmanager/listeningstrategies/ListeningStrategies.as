package org.robotlegs.v2.viewmanager.listeningstrategies 
{
	import org.robotlegs.v2.viewmanager.IListeningStrategy;
	
	public class ListeningStrategies 
	{
		
		public static const STAGE:IListeningStrategy = new StageViewListeningStrategy(null);
		
		public static const FEWEST_LISTENERS:IListeningStrategy = new FewestListenersViewListeningStrategy(null);
		
		public static const FEWEST_EVENTS:IListeningStrategy = new FewestEventsViewListeningStrategy(null);
		
		public static const AUTO:IListeningStrategy = FEWEST_LISTENERS;
	}
}