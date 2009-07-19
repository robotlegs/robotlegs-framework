package org.robotlegs.mvcs
{

	public class ContextError extends Error
	{
		public function ContextError( message:String = "", id:int = 0 )
		{
			super( message, id );
		}
	}
}