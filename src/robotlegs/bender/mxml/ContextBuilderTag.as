//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.mxml
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.setTimeout;
	import mx.core.IMXMLObject;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.impl.Context;

	[DefaultProperty("configs")]
	public class ContextBuilderTag implements IMXMLObject
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _configs:Vector.<Object> = new Vector.<Object>;

		public function get configs():Vector.<Object>
		{
			return _configs;
		}

		public function set configs(value:Vector.<Object>):void
		{
			_configs = value;
		}

		private var _contextView:DisplayObjectContainer;

		public function set contextView(value:DisplayObjectContainer):void
		{
			_contextView = value;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _context:IContext = new Context();

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function initialized(document:Object, id:String):void
		{
			_contextView = document as DisplayObjectContainer;
			// if the contextView is bound it will only be set a frame later
			setTimeout(configureBuilder, 1);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function configureBuilder():void
		{
			for each (var config:Object in _configs)
			{
				_context.require(config);
			}

			if (_contextView)
				_context.require(_contextView);

			_configs.length = 0;
		}
	}
}
