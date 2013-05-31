# Direct Command Map

## Overview

The Direct Command Map allows you to execute commands directly and to pin and release commands in/from memory.

## Command Execution

### Executing a single command

```as3
directCommandMap
	.map(RetrieveFlashVarsCommand)
	.execute();
```

### Executing a sequence of commands

```as3
directCommandMap
	.map(DoThisFirstCommand)
	.map(DoThisNextCommand)
	.map(DontForgetThisOneTooCommand)
	.map(FinallyDoThisCommand)
	.execute();
```

The sequence is handled synchronized, i.e. once the code in a command finishes execution the Direct Command Map immediately moves on to the execution of the next command in line.

### Mapping guards and hooks

You can optionally add guards and hooks:

```as3
directCommandMap
	.map(CalculateAnswerToLifeTheUniverseAndEverythingCommand)
		.withGuards(DeepThoughtBuiltGuard)
		.withHooks(StartAnnouncementCeremonyHook)
	.map(BuildEarthCommand)
		.withGuards(WeDontKnowTheQuestionGuard)
		.withHooks(AlertTheMiceHook)
	.execute();
```

For more information on guards and hooks check out: 

1. robotlegs.bender.framework.readme-guards
2. robotlegs.bender.framework.readme-hooks

### Mapping a payload

You can optionally pass a payload object to the `execute` method, its values will be injected into the commands:

```as3
const payload : CommandPayload = new CommandPayload();
payload.addPayload(new Adieu('So long and thanks for all the fish!'), Adieu);

directCommandMap
	.map(ExtractDolphinsCommand)
	.execute(payload);
```

For each payload item you need to provide a value and a class to map the value against. You have to make sure that each mapped value class is unique for the payload instance, otherwise the injection mapping will be overwritten.

This **WILL OVERWRITE** the first String value:

```as3
const payload : CommandPayload = new CommandPayload();
payload.addPayload('So long and thanks for all the fish!', String);
payload.addPayload('Hope you enjoyed the tuna!', String); //overwrites the previous String value
```

Your command receives the payload values as normal injections:

```as3
[Inject]
public var adieu : Adieu;

public function execute():void
{
	log.warn(adieu.toString());
}
```

### Note: Payload values are temporarily mapped for injection and sandboxed

All payload values are only mapped for the duration of the execution (sequence) and they won't be injected into any other freshly created objects besides the commands, i.e. they're sandboxed.

## Command instance pinning to and releasing from memory

By concept commands are short-lived, once their execution is finished they are released for garbage collection.
However, the Direct Command Map allows commands to explicitly pin themselves into memory and release when necessary:

```as3
[Inject]
public var directCommandMap : IDirectCommandMap;

[Inject]
public var importantService : IImportantService;

public function execute():void
{
	directCommandMap.detain(this);
	importantService.doSomethingImportant(onServiceCallComplete);
}

private function onServiceCallComplete():void
{
	directCommandMap.release(this);
}
```

# Direct Command Map extension

## Requirements

This extension requires the following extension:

+ CommandCenterExtension

## Extension Installation

```as3
_context = new Context()
    .install(DirectCommandMapExtension);
```

## Extension Usage

An instance of IDirectCommandMap is mapped into the context during extension installation. This instance can be injected into clients and used as below.

```as3
[Inject]
public var directCommandMap : IDirectCommandMap;
```
