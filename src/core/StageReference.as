package core
{
	import flash.display.Stage;
	
	import mx.core.Window;
	
	import spark.components.WindowedApplication;

	public class StageReference
	{
		private static var _stage:Stage=null;
		private static var _instance:WindowedApplication;

		public static function get instance():WindowedApplication
		{
			return _instance;
		}

		public static function set instance(value:WindowedApplication):void
		{
			_instance = value;
		}

		public static function get stage():Stage
		{
			return _stage;
		}

		public static function set stage(value:Stage):void
		{
			_stage = value;
		}

	}
}