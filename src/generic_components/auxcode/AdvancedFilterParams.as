package generic_components.auxcode
{
	import core.StringUtils;

	public class AdvancedFilterParams
	{
		private var _text:String;
		private var _fromDate:Date;
		private var _toDate:Date;

		

		private var _filterFunction:Function;
		public function AdvancedFilterParams(txt:String=null,from:Date=null,to:Date=null,m_filterFunction:Function=null)
		{
			this.text=txt;
			this.fromDate=from;
			this.toDate=to;
			this.filterFunction=m_filterFunction;
		}
		public function get filterFunction():Function
		{
			return _filterFunction;
		}
		
		public function set filterFunction(value:Function):void
		{
			_filterFunction = value;
		}
		public function get isEmpty():Boolean{
			return (!text||text=="")&&(!fromDate)&&(!toDate);
		}
		public function get toDate():Date
		{
			return _toDate;
		}

		public function set toDate(value:Date):void
		{
			_toDate = value;
		}

		public function get fromDate():Date
		{
			return _fromDate;
		}

		public function set fromDate(value:Date):void
		{
			_fromDate = value;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value.toLowerCase();
		}
		public function applyFilterTextOrDate(o:*):Boolean{
			return applyFilterAsDate(0)||applyFilterAsText(0);
		}
		public function applyFilterAsDate(o:*):Boolean{
			var d:Date;
			var str:String;
			if(fromDate==null&&toDate==null)
				return true;
			if(o is Date)
				d=o as Date;
			else
			{
				str=o.toString();
				//maybe o is a date but in String format
				d=new Date(text);
				if(isNaN(d.valueOf()))d=null;
			}
			if(d)
			{
				if(fromDate!=null){
					if(d.time<fromDate.time)
						return false;
				}
				if(toDate!=null){
					if(d.time>toDate.time)
						return false;
				}
				return true;	
			}
			return false;
		}
		public function applyFilterAsText(o:*):Boolean{
			var str:String=(o.toString()).toLowerCase();
			if(text==null||text=="")
				return true;
			if(str)
				return str.indexOf(text)>=0;
			else
				return true
		
		}
	}
}