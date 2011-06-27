package {
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import skins.ViewManagerExperimentsSkin;
	
	public class ViewManagerExperiments extends Sprite {

		public function ViewManagerExperiments() {
			addChild(new ViewManagerExperimentsSkin.ProjectSprouts() as DisplayObject);
			trace("ViewManagerExperiments instantiated!");
		}
	}
}
