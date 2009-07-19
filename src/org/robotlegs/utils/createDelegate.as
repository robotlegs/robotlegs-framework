package org.robotlegs.utils
{

	public function createDelegate( handler:Function, ... extraArgs ):Function
	{
		return function( ... args ):void
		{
			handler.apply( null, args.concat( extraArgs ) );
		}
	}
}
