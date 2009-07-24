package org.robotlegs.mvcs
{
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	public class FlexMediator extends Mediator
	{
		private var uiComponent:UIComponent;
		
		/**
		 * Default MVCS Flex <code>IMediator</code> implementation
		 */
		public function FlexMediator()
		{
			super();
		}
		
		override public function preRegister():void
		{
			uiComponent = viewComponent as UIComponent;
			if (uiComponent.initialized)
			{
				onRegister();
			}
			else
			{
				uiComponent.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete, false, 0, true);
			}
		}
		
		private function onCreationComplete(e:FlexEvent):void
		{
			uiComponent.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			onRegister();
		}
	
	}

}