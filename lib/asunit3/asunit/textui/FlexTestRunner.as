package asunit.textui {
    import flash.display.DisplayObject;
    import flash.events.Event;
    import mx.core.IUIComponent;
    import asunit.textui.TestRunner;

    /**
    *   @private
    **/
    public class FlexTestRunner extends TestRunner {

        public function FlexTestRunner() {
            setPrinter(new ResultPrinter());
        }
    
        protected override function addedHandler(event:Event):void {
            if(event.target === this) {
                parent.addEventListener(Event.RESIZE, resizeHandler);
                resizeHandler(new Event(Event.RESIZE));
            }
            else {
                event.stopPropagation();
            }
        }
    
        public override function set width(w:Number):void {
            fPrinter.width = w;
        }
    
        public override function set height(h:Number):void {
            fPrinter.height = h;
        }
    
        public function resizeHandler(event:Event):void {
            width = parent.width;
            height = parent.height;
        }
    
        public override function addChild(child:DisplayObject):DisplayObject {
            if(parent && child is IUIComponent) {
                // AND check for 'is' UIUComponent...
                return parent.addChild(child);
            }
            else {
                return super.addChild(child);
            }
        }
    
        public override function removeChild(child:DisplayObject):DisplayObject {
            if(child is IUIComponent) {
                return parent.removeChild(child);
            }
            else {
                return super.removeChild(child);
            }
        }
    }
}
