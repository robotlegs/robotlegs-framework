# Matching Extension

## Overview

TypeMatchers allow you to build up rich descriptions of objects based on their type - the class, superclass chain and interfaces the implement.

## Extension Installation

This extension does not need to be installed, it is used by the MediatorMap extension, but can also be used in other extensions.

## TypeMatcher Usage

You create a typeMatcher using new:

```as3
new TypeMatcher()
```

Any number of calls to the following api can be chained:

```as3
allOf(...types)
anyOf(...types)
noneOf(...types)
```

The parameter `...types` can be an array of types or simply a list. Using an array will allow you to use sets of types to configure multiple matchers.

TypeMatchers are locked as soon as they have been used for matching, but you can explicitly lock your TypeMatcher with a call to

	lock()
	
Once locked, the only api available is

	clone()
	
This creates a duplicate TypeMatcher, which is unlocked, so that you can further customise this matcher.

TypeMatchers are not internally checked for conflicts, so it's your responsibility to ensure that your rules make sense.

There is no 'or' provided. Instead, use multiple matchers and map each of them to the same rules - ensuring that your rules aren't nested, or multiple matches will occur. For guidance on testing your matchers check out the TypeMatcher unit tests.

## PackageMatcher Usage

The package matcher has the following api:

```as3
require(fullPackage:String)
anyOf(...packages)
allOf(...pacakges)
```

You can only `require` one package. Multiple calls to `anyOf` and `allOf` can be chained. Multiple calls to `require` will throw an error.

The package matcher will be locked the first time it is used, but can be explicitly locked with a call to

	lock();

## Building your own Matchers

... info to follow