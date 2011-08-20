//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.flex.mxml
{
	import flash.display.DisplayObjectContainer;
	import mx.core.IMXMLObject;
	import org.robotlegs.v2.context.api.IContextBuilderConfig;
	import org.robotlegs.v2.context.impl.ContextBuilder;

	[DefaultProperty("configs")]
	public class ContextBuilder extends org.robotlegs.v2.context.impl.ContextBuilder implements IMXMLObject
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _configs:Vector.<IContextBuilderConfig> = new Vector.<IContextBuilderConfig>;

		public function get configs():Vector.<IContextBuilderConfig>
		{
			return _configs;
		}

		public function set configs(value:Vector.<IContextBuilderConfig>):void
		{
			_configs = value;
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function initialized(document:Object, id:String):void
		{
			configs.forEach(function(config:IContextBuilderConfig, ... rest):void
			{
				installConfig(config);
			}, this);

			configs = null;

			if (!context.contextView)
			{
				const container:DisplayObjectContainer = document as DisplayObjectContainer;
				container && withContextView(container);
			}

			build();
		}
	}
}
