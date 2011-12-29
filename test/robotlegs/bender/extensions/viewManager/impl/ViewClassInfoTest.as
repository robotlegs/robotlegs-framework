//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;
	import ArgumentError;
	import robotlegs.bender.extensions.viewManager.impl.support.CustomSprite;
	import flash.system.ApplicationDomain;
	import robotlegs.bender.extensions.viewManager.impl.ViewClassInfoTest;

	public class ViewClassInfoTest
	{

		protected var instance:ViewClassInfo;

		protected const TYPE:Class = CustomSprite;
		protected const FQCN:String = "robotlegs.bender.extensions.viewManager.impl.support.CustomSprite";
		protected const APP_DOMAIN:ApplicationDomain = new ApplicationDomain();

		[Before]
		public function setUp():void
		{
			instance = new ViewClassInfo(TYPE, FQCN, APP_DOMAIN);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
		}

		[Test]
		public function get_type_returns_value_given():void
		{
			assertThat(instance.type, equalTo(TYPE));
		}

		[Test]
		public function get_fqcn_returns_value_given():void
		{
			assertThat(instance.fqcn, equalTo(FQCN));
		}

		[Test]
		public function get_app_domain_returns_value_given():void
		{
			assertThat(instance.applicationDomain, equalTo(APP_DOMAIN));
		}

		[Ignore]
		[Test]
		public function typeNames_does_what_it_should():void
		{

		}

		[Ignore]
		[Test]
		public function isType_does_what_it_should():void
		{

		}

	}
}