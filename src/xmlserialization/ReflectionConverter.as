package xmlserialization
{
import core.Logger;

import flash.utils.describeType;

import mx.utils.ObjectUtil;

public class ReflectionConverter
{
    public function ReflectionConverter() {
    }

    public function marshal(source:Object):XML
    {
        var writer:XMLWriter=new XMLWriter();
        var objDescriptor:XML=describeType(source);
        var property:XML;
        var propertyType:String;
        var propertyValue:Object;

        var qualifiedClassName:String=objDescriptor.@name;
       // Logger.write("qualifiedClassName "+qualifiedClassName);
        qualifiedClassName=qualifiedClassName.split("::").join(".");
         //Logger.write("qualifiedClassName "+qualifiedClassName);

         qualifiedClassName=qualifiedClassName.replace("<","_le314");
        qualifiedClassName=qualifiedClassName.replace(">","_ge314");
        writer.xml.setName(qualifiedClassName);

        for each(property in objDescriptor.elements("variable")){
            propertyValue=source[property.@name];
            if (propertyValue!=null){
                if (ObjectUtil.isSimple(propertyValue)){
                    writer.addProperty(property.@name, propertyValue.toString());
                }
                else {
                    writer.addProperty(property.@name, (new ReflectionConverter).marshal(propertyValue).toXMLString());
                }
            }
        }
        for each(property in objDescriptor.elements("accessor")){
            if (property.@access=="readonly"){
                continue;
            }
            propertyValue=source[property.@name];
            if (source[property.@name]!=null){
                if (ObjectUtil.isSimple(propertyValue)){
                    writer.addProperty(property.@name, propertyValue.toString());
                }
                else {
                    writer.addProperty(property.@name, (new ReflectionConverter).marshal(propertyValue).toXMLString());
                }
            }
        }
        return writer.xml;
    }

    public function unmarshal(xml:XML):Object
    {
        var node:XML;
        var objectClass:Class;
        var objDescriptor:XML;
        var object:Object;
        var child:XML;
        var propertyType:String;
        var propertyClass:Class;
        node=xml;
        var qualifiedClassName:String = node.name();
             qualifiedClassName=qualifiedClassName.replace("_le314","<");
        qualifiedClassName=qualifiedClassName.replace("_ge314",">");

        objectClass=flash.utils.getDefinitionByName(qualifiedClassName) as Class;
        object=new objectClass();
        objDescriptor=describeType(object);
        for each(child in xml.children()){
            node=child;
            propertyType=getTypeFromDescriptor(node.name(), objDescriptor);
            if (propertyType!=null){
                propertyClass=flash.utils.getDefinitionByName(propertyType) as Class;
                if (ObjectUtil.isSimple(new propertyClass())){
                    object[node.name()]=new propertyClass(node.toString());
                    if(node.toString()=="false")
                        object[node.name()]=false;
                }
                else{
                    object[node.name()]=(new ReflectionConverter).unmarshal(node.children()[0]);
                }
            }
        }
        return object;
    }

    /**
     * Checks if property with given name exists in class and returns property type.
     * Returns null if class has no property with that name.
     *
     * @param name property name
     * @return
            *
     */
    private function getTypeFromDescriptor(name:String, objDescriptor:XML):String {
        for each(var property:XML in objDescriptor.elements("variable")) {
            if (property.@name==name){
                return (String(property.@type));
            }
        }
        for each(var accessor:XML in objDescriptor.elements("accessor")) {
            if (accessor.@name==name){
                return (String(accessor.@type));
            }
        }
        return null;
    }

    /**
     * Reads [RemoteType] user defined metadata on property
     *
     */
    private function getRemoteType(propertyMetadataList:XMLList):String{
        var remoteType:String;
        for each (var metadata:XML in propertyMetadataList){
            if (metadata.@name=="RemoteType"){
                for each (var arg:XML in metadata.elements("arg")){
                    if (arg.@key=="alias"){
                        remoteType=arg.@value;
                    }
                }
            }
        }
        return remoteType;
    }
}
}