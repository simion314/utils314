package core
{
	public class MathAux
	{
		private static const trashHold:Number =0.01;
		public function MathAux()
		{
		}
		
		public static function roundToNearestInt(v:Number):int{
			var floor:int=Math.floor(v);
			var delta1:Number=v-floor;
			var delta2:Number=1-delta1;
			if(delta1<=delta2)
				return floor;
			else
				return floor+1;	
		}
		
		public static function roundTrashHold(v:Number,_trashHoldf:Number=trashHold):Number{
			var round:int=roundToNearestInt(v);
			if(Math.abs(round-v)<=_trashHoldf)
				return round;
				else 
					return v;
		}
		public static function roundToDecimal(v:Number,decimal:int=3):Number{
			var res:Number= Math.floor(v*Math.pow(10,decimal)+0.5);
				res=Math.floor(res)/Math.pow(10,decimal);
			return res;
		}
		public static function signum(a:Number):int{
			if(a==0) return 0;
			if(a>0) return 1;
			else return -1;
		}
		public static function compare(a:Number,b:Number):int{
		if(a==b) return 0;
		if(a>b) return 1;
		else return -1;
		}
	}
}