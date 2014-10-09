package xmlserialization
{
	import flash.utils.describeType;
	
	public class SimpleSerializer
	{
		public function SimpleSerializer()
		{
		}
		
		public function toXML(o:*):XML {
			return (new ReflectionConverter).marshal(o);			
		}
		
		public function fromXML(xml:XML):*{
			return (new ReflectionConverter).unmarshal(xml);
		}
	}
}