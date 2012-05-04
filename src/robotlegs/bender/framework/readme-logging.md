# Logging

A lightweight logging implementation used internally by the framework.

We chose not to use a 3rd-party logging implementation to reduce dependencies on 3rd-party libraries. An interface exists that allows you to integrate easily with 3rd party log targets.

## Defaults

The default log level is INFO. Many events logged by the framework and extensions are logged at the DEBUG level, which means they will be filtered out. Also, no log targets are installed by default, so even if you set the logLevel to DEBUG you might not see any output.

## Log Targets

To set the log level to DEBUG and add a simple trace logging target do the following:

    context.logLevel = LogLevel.DEBUG;
    context.addLogTarget(new TraceLogTarget(context));

Or you can use the provided extension (already included in the MVCS bundle):

    context.logLevel = LogLevel.DEBUG;
    context.extend(TraceLoggingExtension);

You can make your own custom log targets by implementing the ILogTarget interface.

## Loggers

You can pull a fresh logger out of the context like so:

    logger = context.getLogger(this);
    logger.warn("I'm sorry {0}, I am far too well to come in to work today.", [boss]);

Or, instead of passing an instance, pass a class:

    logger = context.getLogger(MyClass);

The problem here is that you need a reference to the context. Read on.

## LoggingExtension

If you install the LoggingExtension (already included in the MVCS bundle), getting loggers becomes even easier - simply inject an ILogger:

    public class MyClass
    {
        [Inject]
        public var logger:ILogger;

        public function MyClass()
        {
            // don't try to access the logger in your constructor
            // it won't have been set yet
        }

        public function explode(size:String):void
        {
            logger.info("The was a {0} explosion!", [size]);
        }
    }

## InjectorLoggingExtension

Ever wanted to know what the injector is up to? The InjectorLoggingExtension adds listeners to the injector and logs its every move.

The injection and mappings events are logged at the DEBUG level, so be sure to set your logLevel to debug if you want to see them.
