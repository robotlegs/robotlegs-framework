# MVCS Bundle (Classic)

This bundle installs a number of extensions and configurations for developers who are comfortable with the typical Robotlegs MVCS setup.

## Included Extensions

* TraceLoggingExtension - sets up a simple trace log target
* VigilanceExtension - throws errors when warnings are logged
* InjectableLoggerExtension - allows you to inject loggers into clients
* ContextViewExtension - consumes a display object container as the contextView
* EventDispatcherExtension - makes a shared event dispatcher available
* ModularityExtension - allows the context to expose and/or inherit dependencies
* DirectCommandMapExtension - allows you to execute commands directly and detain and release command instances
* EventCommandMapExtension - an event driven command map
* LocalEventMapExtension - automatically cleans up listeners for its clients
* ViewManagerExtension - allows you to add multiple containers as "view roots"
* StageObserverExtension - watches the stage for view components using magic
* MediatorMapExtension - configures and creates mediators for view components
* ViewProcessorMapExtension - allows direct view processing (e.g. direct injection)
* StageCrawlerExtension - scans the stage at initialization for existing views
* StageSyncExtension - automatically initializes the context when the contextView lands on stage

Note: For more information on these extensions please see the extensions package.

## Included Base Classes

* Command - optional, abstract command
* Mediator - default mediator implementation

## Included Configs

* ContextViewListenerConfig - adds the contextView to the viewManager
