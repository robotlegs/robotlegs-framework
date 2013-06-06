# Enhanced Logging

Provides a number of extensions related to logging.

## TraceLoggerExtension

Adds a TraceLogTarget to the context. This will simply `trace()` log messages.

## InjectableLoggerExtension

If you install the InjectableLoggerExtension (already included in the MVCS bundle), getting loggers becomes even easier - simply inject an ILogger:

```as3
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
        logger.info("There was a {0} explosion!", [size]);
    }
}
```

## InjectorActivityLoggingExtension

Ever wanted to know what the injector is up to? The InjectorActivityLoggingExtension adds listeners to the injector and logs its every move.

The injection and mappings events are logged at the DEBUG level, so be sure to set your logLevel to debug if you want to see them.

WARNING: This extension will seriously degrade performance. Use it for fun, not profit.
