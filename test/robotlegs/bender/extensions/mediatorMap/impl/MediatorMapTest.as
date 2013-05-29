//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.display.Sprite;
	import flash.media.Sound;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
	import robotlegs.bender.framework.impl.Context;

	public class MediatorMapTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var mediatorMap:MediatorMap;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			const context:Context = new Context();
			mediatorMap = new MediatorMap(context);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function mapMatcher_creates_mapper():void
		{
			const matcher:TypeMatcher = new TypeMatcher().allOf(Sprite);
			assertThat(mediatorMap.mapMatcher(matcher), instanceOf(IMediatorMapper));
		}

		[Test]
		public function mapMatcher_to_matching_TypeMatcher_returns_same_mapper():void
		{
			const matcher1:TypeMatcher = new TypeMatcher().allOf(Sprite);
			const matcher2:TypeMatcher = new TypeMatcher().allOf(Sprite);
			const mapper1:Object = mediatorMap.mapMatcher(matcher1);
			const mapper2:Object = mediatorMap.mapMatcher(matcher2);
			assertThat(mapper1, equalTo(mapper2));
		}

		[Test]
		public function mapMatcher_to_differing_TypeMatcher_returns_different_mapper():void
		{
			const matcher1:TypeMatcher = new TypeMatcher().allOf(Sprite);
			const matcher2:TypeMatcher = new TypeMatcher().allOf(Sound);
			const mapper1:Object = mediatorMap.mapMatcher(matcher1);
			const mapper2:Object = mediatorMap.mapMatcher(matcher2);
			assertThat(mapper1, not(equalTo(mapper2)));
		}

		[Test]
		public function unmap_returns_mapper():void
		{
			const mapper:Object = mediatorMap.mapMatcher(new TypeMatcher().allOf(Sprite));
			assertThat(mediatorMap.unmapMatcher(new TypeMatcher().allOf(Sprite)), equalTo(mapper));
		}

		[Test]
		public function robust_to_unmapping_non_existent_mappings():void
		{
			mediatorMap.unmapMatcher(new TypeMatcher().allOf(Sprite)).fromAll();
		}
	}
}
