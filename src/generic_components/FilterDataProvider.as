package generic_components
{
	import generic_components.auxcode.ScorClassAux;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;

	public class FilterDataProvider
	{
		private var _dataProvider:ArrayCollection;
		public function FilterDataProvider()
		{
		}

	
		public function filter(text:String,dataProvider:ArrayCollection,labelFunction:Function):ArrayCollection{
			if(!text||text=="")return dataProvider;
			var scorCol:Vector.<ScorClassAux>=GenerateScors(text,dataProvider,labelFunction);
			var res:ArrayCollection=new ArrayCollection();
			scorCol.forEach(function(o:ScorClassAux,i:int,a:*):void{res.addItem(o.object);});
			return res;
		}
		
		private function GenerateScors(text:String, dataProvider:ArrayCollection, labelFunction:Function):Vector.<ScorClassAux>
		{
			var scorCollection:Vector.<ScorClassAux>=new Vector.<ScorClassAux>();
			for each (var i:Object in dataProvider) 
			{
				var label:String=String(labelFunction(i)).toLowerCase();
				var s:Number=evaluate(text,label);
				if(s<=0) continue;
				var scor:ScorClassAux=new ScorClassAux();
				scor.object=i;
				scor.label=label;
				scor.scor=s;
				scorCollection.push(scor);
			}
			scorCollection.sort(function(A:ScorClassAux,B:ScorClassAux):int{
				if(A.scor<B.scor)
					return 1;
				else return -1;});
			
			return scorCollection;
			
		}
		
		private function evaluate(text:String, label:String):Number
		{
			text=text.toLowerCase();
			var index:int=label.indexOf(text);
			if(index<0) return 0;
			if(index==0)
				return 100;
			var s:String=label.charAt(index-1);
			if(s==" "||s=="-"||s=="_"||s=="/")
				return 75;
			return 50;
			
		}
	}
}