package core
{
import flash.net.URLRequest;
import flash.net.navigateToURL;

public class EmailUtils
{	private static const DISALLOWED_LOCALNAME_CHARS:String =
	"()<>,;:\\\"[] `~!#$%^&*={}|/?'";
						
	private static const DISALLOWED_DOMAIN_CHARS:String =
		"()<>,;:\\\"[] `~!#$%^&*+={}|/?'";
	
	public static function validateEmail2(emailAddress:String):Boolean {
		var emailExpression:RegExp = /^[\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
		if (emailAddress.match(emailExpression) == null) {
			return false;
		}
		else {
			return true;
		}
	}
	public static function validateEmail(emailStr:String):Boolean
	{
		// Validate the domain name
		// If IP domain, then must follow [x.x.x.x] format
		// Can not have continous periods.
		// Must have at least one period.
		// Must end in a top level domain name that has 2, 3, 4, or 6 characters.
		
		var username:String = "";
		var domain:String = "";
		var n:int;
		var i:int;
		
		// Find the @
		var ampPos:int = emailStr.indexOf("@");
		if (ampPos == -1)
			return false;//missing @ sign
			// Make sure there are no extra @s.
		else if (emailStr.indexOf("@", ampPos + 1) != -1) 
		{ 
			return false;// "tooManyAtSigns",		
		}
		
		// Separate the address into username and domain.
		username = emailStr.substring(0, ampPos);
		domain = emailStr.substring(ampPos + 1);
		
		// Validate username has no illegal characters
		// and has at least one character.
		var usernameLen:int = username.length;
		if (usernameLen == 0)
		{
			return false;//missingUsername",
		}
		
		for (i = 0; i < usernameLen; i++)
		{
			if (DISALLOWED_LOCALNAME_CHARS.indexOf(username.charAt(i)) != -1)
			{
				return false;//"invalidChar",
			}
		}
		
		var domainLen:int = domain.length;
		
		// check for IP address
		if ((domain.charAt(0) == "[") && (domain.charAt(domainLen - 1) == "]"))
		{
			// Validate IP address
			if (!isValidIPAddress(domain.substring(1, domainLen - 1)))
			{
				return false;//"invalidIPDomain",
				
			}
		}
		else
		{
			// Must have at least one period
			var periodPos:int = domain.indexOf(".");
			var nextPeriodPos:int = 0;
			var lastDomain:String = "";
			
			if (periodPos == -1)
			{
				return false;// "missingPeriodInDomain",
				
			}
			
			while (true)
			{
				nextPeriodPos = domain.indexOf(".", periodPos + 1);
				if (nextPeriodPos == -1)
				{
					lastDomain = domain.substring(periodPos + 1);
					if (lastDomain.length != 3 &&
						lastDomain.length != 2 &&
						lastDomain.length != 4 &&
						lastDomain.length != 6)
					{
						return false;//, "invalidDomain",
							
					}
					break;
				}
				else if (nextPeriodPos == periodPos + 1)
				{
					return false; //"invalidPeriodsInDomain",
					
				}
				periodPos = nextPeriodPos;
			}
			
			// Check that there are no illegal characters in the domain.
			for (i = 0; i < domainLen; i++)
			{
				if (DISALLOWED_DOMAIN_CHARS.indexOf(domain.charAt(i)) != -1)
				{
					return false;// "invalidChar",
					
				}
			}
			
			// Check that the character immediately after the @ is not a period.
			if (domain.charAt(0) == ".")
			{
				return false;// "invalidDomain",
				
			}
		}
		
		return true;
	}
	private static function isValidIPAddress(ipAddr:String):Boolean
	{
		var ipArray:Array = [];
		var pos:int = 0;
		var newpos:int = 0;
		var item:Number;
		var n:int;
		var i:int;
		
		// if you have :, you're in IPv6 mode
		// if you have ., you're in IPv4 mode
		
		if (ipAddr.indexOf(":") != -1)
		{
			// IPv6
			
			// validate by splitting on the colons
			// to make it easier, since :: means zeros, 
			// lets rid ourselves of these wildcards in the beginning
			// and then validate normally
			
			// get rid of unlimited zeros notation so we can parse better
			var hasUnlimitedZeros:Boolean = ipAddr.indexOf("::") != -1;
			if (hasUnlimitedZeros)
			{
				ipAddr = ipAddr.replace(/^::/, "");
				ipAddr = ipAddr.replace(/::/g, ":");
			}
			
			while (true)
			{
				newpos = ipAddr.indexOf(":", pos);
				if (newpos != -1)
				{
					ipArray.push(ipAddr.substring(pos,newpos));
				}
				else
				{
					ipArray.push(ipAddr.substring(pos));
					break;
				}
				pos = newpos + 1;
			}
			
			n = ipArray.length;
			
			const lastIsV4:Boolean = ipArray[n-1].indexOf(".") != -1;
			
			if (lastIsV4)
			{
				// if no wildcards, length must be 7
				// always, never more than 7
				if ((ipArray.length != 7 && !hasUnlimitedZeros) || (ipArray.length > 7))
					return false;
				
				for (i = 0; i < n; i++)
				{
					if (i == n-1)
					{
						// IPv4 part...
						return isValidIPAddress(ipArray[i]);
					}
					
					item = parseInt(ipArray[i], 16);
					
					if (item != 0)
						return false;
				}
			}
			else
			{
				
				// if no wildcards, length must be 8
				// always, never more than 8
				if ((ipArray.length != 8 && !hasUnlimitedZeros) || (ipArray.length > 8))
					return false;
				
				for (i = 0; i < n; i++)
				{
					item = parseInt(ipArray[i], 16);
					
					if (isNaN(item) || item < 0 || item > 0xFFFF)
						return false;
				}
			}
			
			return true;
		}
		
		if (ipAddr.indexOf(".") != -1)
		{
			// IPv4
			
			// validate by splling on the periods
			while (true)
			{
				newpos = ipAddr.indexOf(".", pos);
				if (newpos != -1)
				{
					ipArray.push(ipAddr.substring(pos,newpos));
				}
				else
				{
					ipArray.push(ipAddr.substring(pos));
					break;
				}
				pos = newpos + 1;
			}
			
			if (ipArray.length != 4)
				return false;
			
			n = ipArray.length;
			for (i = 0; i < n; i++)
			{
				item = Number(ipArray[i]);
				if (isNaN(item) || item < 0 || item > 255)
					return false;
			}
			
			return true;
		}
		
		return false;
	}
	public static function openEmailClient(from:String,to:String,subject:String,body:String):void{
		var request:URLRequest;
		var str:String="mailto:"+escape(to)+"?subject="+
			escape(subject)+"&body="+escape(body);
		request=new URLRequest(str);
		navigateToURL(request);
	}
	public static function webSiteFromEmail(email:String):String{
		if(!validateEmail(email))return "";
		var a:Array=email.split("@");
		if(a.length!=2) return "";
		var d:String=a[1];
		if(!isUnhKnownDomain(d))
			return "";
		return "www."+d;
		
		function isUnhKnownDomain(d:String):Boolean{
			var knownDomains:Array=['gmail','yahoo','hotmail'];
			return knownDomains.every(function(o:Object,i:int,a:Array):Boolean{
				return d.indexOf(o as String)!=0;
			});
		}
	}
	
	 
}
}