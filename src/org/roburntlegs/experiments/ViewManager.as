package org.roburntlegs.experiments 
{
	
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.events.Event;
	
	public class ViewManager 
	{
		
		protected var _listenersByTargetAndEventType:Dictionary = new Dictionary(false);
		
		public function ViewManager() 
		{
		} 
		
		public function addInterestIn(target:IEventDispatcher, eventType:String, interestedFunc:Function):void
		{                                                      
			_listenersByTargetAndEventType[target] ||= new Dictionary();
			
			if(!_listenersByTargetAndEventType[target][eventType])
			{
				_listenersByTargetAndEventType[target][eventType] = new Vector.<Function>();
				target.addEventListener(eventType, runCallbacks);
			} 
			
			_listenersByTargetAndEventType[target][eventType].push(interestedFunc);
		}
		
		protected function runCallbacks(e:Event):void
		{
			const relevantCallbacks:Vector.<Function> = _listenersByTargetAndEventType[e.target][e.type];
			
			const iLength:uint = relevantCallbacks.length;
			for (var i:int = 0; i < iLength; i++)
			{
				relevantCallbacks[i]();
			}
		}
		
	}
}