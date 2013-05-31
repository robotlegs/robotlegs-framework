# Logging

A lightweight logging implementation used internally by the framework.

We chose not to use a 3rd-party logging implementation to reduce dependencies on 3rd-party libraries. An interface exists that allows you to integrate easily with 3rd party log targets.

## Defaults

The default log level is INFO. Many events logged by the framework and extensions are logged at the DEBUG level, which means they will be filtered out. Also, no log targets are installed by default, so even if you set the logLevel to DEBUG you might not see any output.

Note: The MVCS bundle changes these defaults. It adds a TraceLogTarget and sets the log level to DEBUG.

## Log Targets

To set the log level to DEBUG and add a simple trace logging target do the following:

```as3
context.logLevel = LogLevel.DEBUG;
context.addLogTarget(new TraceLogTarget(context));
```

Or you can use the provided extension (already included in the MVCS bundle):

```as3
context.logLevel = LogLevel.DEBUG;
context.install(TraceLoggingExtension);
```

You can make your own custom log targets by implementing the ILogTarget interface.

## Loggers

You can pull a fresh logger out of the context like so:

```as3
logger = context.getLogger(this);
logger.warn("I'm sorry {0}, I am far too well to come in to work today.", [boss]);
```

Or, instead of passing an instance, pass a class:

```as3
logger = context.getLogger(MyClass);
```

The problem here is that you need a reference to the context.

For an easier way to inject loggers please see the readme in the EnhancedLogging extension package.
