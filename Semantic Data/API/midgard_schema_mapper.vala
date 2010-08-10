using GLib;

namespace Midgard
{


public interface SchemaMapper : GLib.Object
{
    // Singleton {{{
    private static SchemaMapper instance;

    public static Prefs get_instance()
    {
        if (instance == null)
            instance = new SchemaMapper();

        return instance;
    }

    private SchemaMapper() { }
    //}}}

    // managing mappings
    public GLib.HashTable<string,string> getMapping(GLib.Type type);
    public void moveFieldToTable(GLib.Type type, string field);
    public void moveFieldToParameters(GLib.Type type, string field);
}


}
