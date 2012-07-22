package robotlegs.bender.framework.api
{
	public class MappingConfigError extends Error
	{
	
		public function MappingConfigError(message:String, trigger:*, action:*)
		{
			super(message);
		
			_trigger = trigger;
			_action = action;
		}
	
		private var _trigger:Object;

		public function get trigger():Object
		{
			return _trigger;
		}
	
		private var _action:Object;

		public function get action():Object
		{
			return _action;
		}
	}
}
