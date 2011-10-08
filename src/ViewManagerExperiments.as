package {
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class ViewManagerExperiments extends Sprite {

		public function ViewManagerExperiments() {
			addChild(new ViewManagerExperimentsSkin.ProjectSprouts() as DisplayObject);
			trace("ViewManagerExperiments instantiated!");
		}
	}
}
