package  generic_components
{
	
	import mx.collections.ArrayCollection;
	
	import spark.components.DropDownList;
	
	public class TimeDropDownList extends DropDownList
	{
		private static const times:ArrayCollection=generateTimes();
		public function TimeDropDownList()
		{
			super();
			width=100;
			dataProvider=times;
		}
		public function setTimeHM(h:int,m:int,PM:Boolean):void{
			var deltaH:int=0;
			if(h!=12)deltaH=h;
			if(PM) deltaH+=12;
			var minIndex:int=0;
			if(m>=15&&m<30)
				minIndex=1;
			else
				if(m>=30&&m<45)
					minIndex=2;
				else
					if(m>=45)
						minIndex=3;
			deltaH=deltaH*4+ minIndex;
			if(deltaH>=times.length)
				deltaH=0;
			this.selectedIndex=deltaH;
		}
		public function getTime():Array{
			var h:int;
			var m:int;
			var PM:Boolean;
			
			
			var index:int=this.selectedIndex;
			if(index>48)PM=true;
			index=index%48;
			var x:Number=index/4;
			var celing:int=Math.ceil(x)-1;
			if(celing==0)h=12;
			else h=celing;
			var res:int=index%4;
			m=res*15;
			
			return [h,m,PM];
		}
		public function setTimeFromDate(d:Date):void{
			var PM:Boolean=12<=d.hours;
			var h:int;
			if(d.hours==0)
				h=12;
			else
				h=d.hours%12;
			var m:int=d.minutes/15 * 15;
			
			setTimeHM(h,m,PM);
		}
		public function setupTimeOnThisDate(d:Date):void{
			var t:Array=getTime();
			var h:int=t[0];
			var PM:Boolean=t[2];
			if(h==12&&PM==false)
				h=0;
			if(PM)
				h=h+12;
			d.hours=h;
			d.minutes=t[1];
			d.seconds=0;
		}
		private static function generateTimes():ArrayCollection{
			var res:ArrayCollection=new ArrayCollection();
			var hrs:Array=['12','01','02','03','04','05','06','07','08','09','10','11'];
			var temp:Array=[];
			for each (var s:String in hrs) 
			{
				temp.push(s+":"+"00");
				temp.push(s+":"+"15");
				temp.push(s+":"+"30");
				temp.push(s+":"+"45");	
			}
			for (var i:int = 0; i < temp.length; i++) 
			{
				res.addItem(temp[i]+" AM");
			}
			for (var j:int = 0; j < temp.length; j++) 
			{
				res.addItem(temp[j]+" PM");
			}
			return res;
		}
		
	}
}