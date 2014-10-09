package generic_components
{
	import spark.components.Group;
	import spark.components.VGroup;
	
	public class ControlledScrollVGroup extends VGroup
	{
		private var _step_size:int = 0;
		
		public function get stepSize():int
		{
			return _step_size;
		}
		
		public function set stepSize(value:int):void
		{
			_step_size = value;
		}
		
		override public function getVerticalScrollPositionDelta(navigationUnit:uint):Number
		{
			var megaValue:Number = super.getVerticalScrollPositionDelta(navigationUnit);
			
			if(megaValue == 0)
			{
				return 0;
			}
			
			var smallerValue:int =  _step_size;
			
			if(smallerValue ==0)
			{
				return megaValue;
			}
			
			if(megaValue < 0)
			{
				smallerValue = -1*smallerValue;
			}
//			if (megaValue==1 || megaValue==-1) // allows mouse left-click in gutter to jump scrollbar into new position
//				return smallerValue;
//			else
//				return megaValue;
			return smallerValue;
		}
		
		public function ControlledScrollVGroup()
		{
			super();
		}
	}
}