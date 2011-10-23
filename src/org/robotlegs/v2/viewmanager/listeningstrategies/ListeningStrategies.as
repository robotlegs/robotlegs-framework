//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.viewmanager.listeningstrategies
{
	import org.robotlegs.v2.viewmanager.IListeningStrategy;

	public class ListeningStrategies
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const AUTO:IListeningStrategy = FEWEST_LISTENERS;

		public static const FEWEST_EVENTS:IListeningStrategy = new FewestEventsViewListeningStrategy(null);

		public static const FEWEST_LISTENERS:IListeningStrategy = new FewestListenersViewListeningStrategy(null);

		public static const STAGE:IListeningStrategy = new StageViewListeningStrategy(null);
	}
}
