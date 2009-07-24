package org.robotlegs.mvcs
{
	
	public class ContextError extends Error
	{
		public static const E_MAP_COM_IMPL:String = 'Command Class does not implement ICommand';
		public static const E_MAP_COM_OVR:String = 'Cannot overwrite map';
		
		public static const E_MAP_NOIMPL:String = 'Mediator Class does not implement IMediator';
		public static const E_MAP_EXISTS:String = 'Mediator Class has already been mapped to a View Class in this context';
		
		public function ContextError(message:String = "", id:int = 0)
		{
			super(message, id);
		}
	}
}