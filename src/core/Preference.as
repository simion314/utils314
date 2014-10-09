/*
Adobe Systems Incorporated(r) Source Code License Agreement
Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.

Please read this Source Code License Agreement carefully before using
the source code.

Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive, 
no-charge, royalty-free, irrevocable copyright license, to reproduce,
prepare derivative works of, publicly display, publicly perform, and
distribute this source code and such derivative works in source or 
object code form without any attribution requirements.  

The name "Adobe Systems Incorporated" must not be used to endorse or promote products
derived from the source code without prior written permission.

You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
against any loss, damage, claims or lawsuits, including attorney's 
fees that arise or result from your use or distribution of the source 
code.

THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT 
ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  ALSO, THERE IS NO WARRANTY OF 
NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT.  IN NO EVENT SHALL ADOBE 
OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package core
{
import core.Logger;

import crypto.Simplecrypt;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.*;
import flash.utils.ByteArray;

import mx.collections.SortField;

//[Event(name=PreferenceChangeEvent.PREFERENCE_CHANGED_EVENT, type="com.adobe.air.notification.PreferenceChangeEvent")]

public class Preference //extends EventDispatcher
{
	private var _modified: Boolean = false;
	private var _filename: String = null;
	
	private var _data: Object = {};
	
	public function Preference(filename: String = null)
	{
		super();
		registerClassAlias("com.adobe.air.preferences.PreferenceItem",  PreferenceItem);
		registerClassAlias("mx.collections.SortField",mx.collections.SortField);
		if (filename == null)
		{
			this._filename = "_prefs.obj";
		}
		else
		{
			this._filename = filename;
		}
	}
	
	public function get modified(): Boolean
	{
		return this._modified;
	}
	
	private static const s_boolean: String = 'Boolean';
	private static const s_int: String = 'int';
	private static const s_uint: String = 'uint';
	private static const s_number: String = 'Number';
	private static const s_bytearray: String = 'ByteArray';
	public var absoluteFilePath:Boolean=false;
	public var pchei:String="";
	
	public function setValue(name: String, value: *, encrypted: Boolean = false): void
	{
		if(!encrypted){
			var oldValue: * = this.getValue(name);
			this._modified = oldValue != value;
		}
		else{
			
			this._modified = oldValue != value;
		}
		if (this._modified)
			
		{
			var prefItm: PreferenceItem = new PreferenceItem();
			prefItm.encrypted = encrypted;
			if (encrypted)
			{
				var string:String;
				if(!(value is String)){
					string=value.toString();
				}
				else
					string=value as String;
				
				string=Simplecrypt.encrypt(string,this.pchei);
				var nname:String=Simplecrypt.encrypt(name,this.pchei);
				prefItm.value = string;
				this._data[nname] = prefItm;
				
			}
			else
			{
				prefItm.value = value;
				this._data[name] = prefItm;
			}
			
			//this.dispatchEvent(new com.adobe.air.preferences.PreferenceChangeEvent( com.adobe.air.preferences.PreferenceChangeEvent.ADD_EDIT_ACTION, name, oldValue, value));
			this.save();
		}
	}
	
	
	public function getValue(name: String, defaultValue: * = null): *
	{
		var prefItm: PreferenceItem;
		var result: * = defaultValue;
		var nname:String=Simplecrypt.encrypt(name, pchei);
		//w4nDk8Onw5vDo8KSwqbDgcKUwpJwwr/Ckw==
		if(this._data[nname] != undefined)
		{
			prefItm= PreferenceItem(this._data[nname]);
			var enc:String=prefItm.value;
			result=Simplecrypt.decrypt(enc,this.pchei);
			return result;
		}
		if (this._data[name] != undefined)
		{
			try{
				prefItm= PreferenceItem(this._data[name]);
				//				
				var bytes:ByteArray;
				if (prefItm.value == s_boolean)
				{
					result = bytes.readBoolean();
				}
				else if (prefItm.value == s_int)
				{
					result = bytes.readByte();
				}
				else if (prefItm.value == s_uint)
				{
					result = bytes.readUnsignedByte();
				}
				else if (prefItm.value == s_number)
				{
					result = bytes.readDouble();
				}
				else if (prefItm.value == s_bytearray)
				{
					result = new ByteArray();
					bytes.readBytes(result);
				}
					// all other types including string
				else{
					if(prefItm.value is Array||prefItm.value is String)
						result= prefItm.value;
					else
					{
//						result = bytes.readUTFBytes(bytes.length);
//						if(!result)
							result= prefItm.value;
					}
				}
			}
			catch(e:Error){
Logger.write("Error in reading settings value "+name+" "+e.message);
				return null;
			}
		}
		return result;
	}
	
	public function deleteValue(name: String): void
	{
		if (this._data[name] != undefined)
		{
			var oldValue:* = this.getValue(name);
			
			delete this._data[name];
			//this.dispatchEvent(new PreferenceChangeEvent(PreferenceChangeEvent.DELETE_ACTION, name, oldValue));
			this.save();
		}
	}
	
	public function save(): void
	{
		var prefsFile: File;
		if(!this.absoluteFilePath)
			prefsFile= File.applicationStorageDirectory.resolvePath(this._filename);
		else
			prefsFile=new File(this._filename);
		
		var fs: FileStream = new FileStream();
		try
		{
			fs.open(prefsFile, FileMode.WRITE);
			fs.writeObject(this._data);
		}
		finally
		{
			fs.close();
		}
	}
	
	public function load(): void
	{
		var prefsFile: File = File.applicationStorageDirectory.resolvePath(this._filename);
		if (prefsFile.exists)
		{
			var fs: FileStream = new FileStream();
			try{
				fs.open(prefsFile, FileMode.READ);
				this._data = fs.readObject();
			}
			catch(e:Error){
				Logger.write("Error loading preference file "+prefsFile.name +" "+e.message);
				fs.close();
				prefsFile.deleteFile();
				return;
			}
			
			fs.close();
			
		}
	}
}
}
