package asunit.framework {
    import flash.display.DisplayObjectContainer;
    import flash.events.IEventDispatcher;
        
    public interface Test extends IEventDispatcher {
        function countTestCases():int;
        function getName():String;
        function getTestMethods():Array;
        function toString():String;
        function setResult(result:TestListener):void;
        function run():void;
        function runBare():void;
        function getCurrentMethod():String;
        function getIsComplete():Boolean;
        function setContext(context:DisplayObjectContainer):void;
        function getContext():DisplayObjectContainer;
    }
}