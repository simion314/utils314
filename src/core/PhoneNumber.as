package core
{
	import mx.messaging.channels.StreamingAMFChannel;

	public class PhoneNumber
	{
		private var number:String;
		private var prefix:String;
		private var country:String;
		private var phoneType:String;
		public function PhoneNumber(number:String,prefix:String="",phoneType:String="" ,country:String=null)
		{
			this.number=number;
			this.prefix=prefix;
			this.country=country;
			this.phoneType=phoneType;
		}
		public function toString(dontShowType:Boolean=false):String{
			var res:String="";
			if(phoneType&&dontShowType==false)
				res+=phoneType+": ";
			if(prefix&&prefix.length>0)
				res+="("+ prefix+") ";
			res+= number;
			return res;
		}
	}
}