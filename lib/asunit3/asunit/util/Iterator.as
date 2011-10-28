package asunit.util {

    [ExcludeClass]
    public interface Iterator {
        function next():Object;
        function hasNext():Boolean;
        function reset():void;
    }
}