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
	import robotlegs.bender.core.api.IContextBuilderBundle;
	import robotlegs.bender.core.api.IContextConfig;
	import robotlegs.bender.core.impl.ContextBuilder;

	[DefaultProperty("configs")]
	public class ContextBuilderTag extends ContextBuilder implements IMXMLObject
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

		private var _documentView:DisplayObjectContainer;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function initialized(document:Object, id:String):void
		{
			_documentView = document as DisplayObjectContainer;
			// if the contextView is bound it will only be set a frame later
			setTimeout(configureBuilder, 1);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function configureBuilder():void
		{
			if (!context.contextView)
			{
				withContextView(_contextView || _documentView);
			}

			for each (var config:Object in configs)
			{
				const configClass:Class = config['constructor'] as Class;
				if (config is IContextBuilderBundle)
				{
					withBundle(configClass);
				}
				else if (config is IContextConfig)
				{
					withConfig(configClass);
				}
				else
				{
					throw new Error("Unrecognised builder option.");
				}
			}

			configs.length = 0;

			build();
		}
	}
}
