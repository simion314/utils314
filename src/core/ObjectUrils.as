package core
{
	public class ObjectUrils
	{
		public function ObjectUrils()
		{
		}
		//this function seem to not work on static types
		//seem to work only on dynamic objects that store the props in a hash table
		public static  function getObjectProperties(obj:Object):Array{
			var res:Array=[];
			for(var id:String in obj) {
				if(id=="mx_internal_uid"||id=="uid")
					continue;
				res.push(id);
			}
			return res;
		}
		public static  function getObjectPropertiesAndValues(obj:Object):Array{
			var res:Array=[];
			for(var id:String in obj) {
				if(id=="mx_internal_uid"||id=="uid")
					continue;
				var o:*=new Object();
				//trace(id);
				o.property=id;
				o.value=obj[id];
				res.push(o);
			}
			return res;
		}
	}
}