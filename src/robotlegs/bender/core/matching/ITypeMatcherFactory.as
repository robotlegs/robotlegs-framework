package robotlegs.bender.core.matching
{
	public interface ITypeMatcherFactory extends ITypeMatcher
	{
		function clone():TypeMatcher;
	}
}

