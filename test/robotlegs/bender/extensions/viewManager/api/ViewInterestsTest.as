//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.api
{
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;
	import robotlegs.bender.extensions.viewManager.api.ViewInterests;

	public class ViewInterestsTest
	{

		[Test]
		public function confirm_constants_are_powers_of_two():void
		{
			assertThat(ViewInterests.MISCELLANEOUS, equalTo(Math.pow(2,0)));
			// pow 1 is not used because misc tasks are non blocking
			assertThat(ViewInterests.MEDIATION, equalTo(Math.pow(2,2)));
			assertThat(ViewInterests.MEDIATION_BLOCK, equalTo(Math.pow(2,3)));

			assertThat(ViewInterests.INJECTION, equalTo(Math.pow(2,4)));
			assertThat(ViewInterests.INJECTION_BLOCK, equalTo(Math.pow(2,5)));

			assertThat(ViewInterests.SKINNING, equalTo(Math.pow(2,6)));
			assertThat(ViewInterests.SKINNING_BLOCK, equalTo(Math.pow(2,7)));

			assertThat(ViewInterests.LOCALISATION, equalTo(Math.pow(2,8)));
			assertThat(ViewInterests.LOCALISATION_BLOCK, equalTo(Math.pow(2,9)));

			assertThat(ViewInterests.LOGGING, equalTo(Math.pow(2,10)));
			assertThat(ViewInterests.LOGGING_BLOCK, equalTo(Math.pow(2,11)));

			assertThat(ViewInterests.PRESENTATION, equalTo(Math.pow(2,12)));
			assertThat(ViewInterests.PRESENTATION_BLOCK, equalTo(Math.pow(2,13)));

			assertThat(ViewInterests.ROBOTLEGS_8, equalTo(Math.pow(2,14)));
			assertThat(ViewInterests.ROBOTLEGS_8_BLOCK, equalTo(Math.pow(2,15)));

			assertThat(ViewInterests.CHANNEL_9, equalTo(Math.pow(2,16)));
			assertThat(ViewInterests.CHANNEL_9_BLOCK, equalTo(Math.pow(2,17)));

			assertThat(ViewInterests.CHANNEL_10, equalTo(Math.pow(2,18)));
			assertThat(ViewInterests.CHANNEL_10_BLOCK, equalTo(Math.pow(2,19)));

			assertThat(ViewInterests.CHANNEL_11, equalTo(Math.pow(2,20)));
			assertThat(ViewInterests.CHANNEL_11_BLOCK, equalTo(Math.pow(2,21)));

			assertThat(ViewInterests.CHANNEL_12, equalTo(Math.pow(2,22)));
			assertThat(ViewInterests.CHANNEL_12_BLOCK, equalTo(Math.pow(2,23)));

			assertThat(ViewInterests.CHANNEL_13, equalTo(Math.pow(2,24)));
			assertThat(ViewInterests.CHANNEL_13_BLOCK, equalTo(Math.pow(2,25)));

			assertThat(ViewInterests.CHANNEL_14, equalTo(Math.pow(2,26)));
			assertThat(ViewInterests.CHANNEL_14_BLOCK, equalTo(Math.pow(2,27)));

			assertThat(ViewInterests.CHANNEL_15, equalTo(Math.pow(2,28)));
			assertThat(ViewInterests.CHANNEL_15_BLOCK, equalTo(Math.pow(2,29)));

			assertThat(ViewInterests.CHANNEL_16, equalTo(Math.pow(2,30)));
			assertThat(ViewInterests.CHANNEL_16_BLOCK, equalTo(Math.pow(2,31)));
		}
	}
}