package xmlserialization
{
public class XMLWriter
{
    public var xml:XML;

    public function XMLWriter()
    {
        xml=<obj/>;
    }

    public function reset():void {
        xml=new XML();
    }

    public function addProperty(propertyName:String, propertyValue:String):XML {
        var xmlProperty:XML=<new/>
        xmlProperty.setName(propertyName);
        xmlProperty.appendChild(propertyValue);
        xml.appendChild(xmlProperty);
        return xmlProperty;
    }


}
}