# MVCS Bundle (Classic)

This bundle installs a number of extensions and configurations for developers who are comfortable with the typical Robotlegs V1 MVCS setup.

## Included Extensions

* LoggingExtension - allows you to inject loggers into clients
* TraceLoggingExtension - sets up a simple trace log target
* ContextViewExtension - consumes a display object container as the contextView
* EventDispatcherExtension - makes a shared event dispatcher available
* ModularityExtension - allows the context to expose and/or inherit dependencies
* StageSyncExtension - automatically initializes the context when the contextView lands on stage
* CommandMapExtension - the foundation for other command map extensions
* EventCommandMapExtension - an event driven command map
* LocalEventMapExtension - automatically cleans up listeners for its clients
* ViewManagerExtension - allows you to add multiple containers as "view roots"
* StageObserverExtension - watches the stage for view components using magic
* ManualStageObserverExtension - non-magical view wiring
* MediatorMapExtension - configures and creates mediators for view components

Note: for more information on these extensions please see the extensions package.

## Included Base Classes

* Command - optional, abstract command
* Mediator - default mediator implementation

## Included Configs

* ContextViewListenerConfig - adds the contextView to the viewManager
