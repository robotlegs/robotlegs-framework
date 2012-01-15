# Robotlegs

This readme describes the Robotlegs codebase. For a general overview see the main readme.md file.

# Overview

Robotlegs is built on top of a few core building blocks:

+ A set of conventions for dealing with asynchronous operations
+ An asynchronous message dispatcher
+ A state machine
+ An object processor

These core components are composed to form:

+ An object manager
+ A configuration manager
+ A context

## Code

The codebase is broken down as follows:

### Core

The low level stuff:

+ MessageDispatcher
+ StateMachine
+ ObjectProcessor

### Framework

The high level stuff:

+ ObjectManager
+ ConfigManager
+ Context

### Extensions

Built-in framework extensions:

+ ContextViewExtension
+ StageSyncExtension
+ ModularityExtension

### Bundles

Built-in bundles:

+ ClassicRobotlegsBundle
