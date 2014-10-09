package core
{
	import flash.globalization.DateTimeFormatter;
	import flash.globalization.DateTimeStyle;
	
	import mx.formatters.DateFormatter;
	
	

	public class StringUtils
	{
		public static var dateFormat:String="YYYY/MM/DD HH:MM";
		private static var fmt:DateFormatter=new DateFormatter();
		public function StringUtils()
		{
		}
		public static function humanFromCamelCase(txt:String):String{			
			return txt.replace(/([A-Z])/g, ' $1').replace(/^ /, "");
		}
		
		public static  function isDateTime(text:String,keepTime:Boolean=false):String{
			var date:Date=new Date(text);
			if(!date||isNaN(date.valueOf())) return null;
//			
			fmt.formatString=dateFormat;
			var res:String= fmt.format(date);
			if(res&&res.length>0)
				return res;
			else return null;
		}
		public static function numberToString(n:Number,preferComma:Boolean=false):String{
			if(!preferComma)
				return n.toFixed(2);
			else
				return n.toFixed(2).replace(".",",");
		}
		public static const states:Array=['Alabama',
			'Alaska',
			'Arizona',
			'Arkansas',
			'California',
			'Colorado',
			'Connecticut',
			'Delaware',
			'District of Columbia',
			'Florida',
			'Georgia',
			'Hawaii',
			'Idaho',
			'Illinois',
			'Indiana',
			'Iowa',
			'Kansas',
			'Kentucky',
			'Louisiana',
			'Maine',
			'Montana',
			'Nebraska',
			'Nevada',
			'New Hampshire',
			'New Jersey',
			'New Mexico',
			'New York',
			'North Carolina',
			'North Dakota',
			'Ohio',
			'Oklahoma',
			'Oregon',
			'Maryland',
			'Massachusetts',
			'Michigan',
			'Minnesota',
			'Mississippi',
			'Missouri',
			'Pennsylvania',
			'Rhode Island',
			'South Carolina',
			'South Dakota',
			'Tennessee',
			'Texas',
			'Utah',
			'Vermont',
			'Virginia',
			'Washington',
			'West Virginia',
			'Wisconsin',
			'Wyoming'];
		public static const statesAbrv:Array=['AL',
			'AK',
			'AZ',
			'AR',
			'CA',
			'CO',
			'CT',
			'DE',
			'DC',
			'FL',
			'GA',
			'HI',
			'ID',
			'IL',
			'IN',
			'IA',
			'KS',
			'KY',
			'LA',
			'ME',
			'MT',
			'NE',
			'NV',
			'NH',
			'NJ',
			'NM',
			'NY',
			'NC',
			'ND',
			'OH',
			'OK',
			'OR',
			'MD',
			'MA',
			'MI',
			'MN',
			'MS',
			'MO',
			'PA',
			'RI',
			'SC',
			'SD',
			'TN',
			'TX',
			'UT',
			'VT',
			'VA',
			'WA',
			'WV',
			'WI',
			'WY'];
	}
}