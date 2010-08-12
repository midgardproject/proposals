using GLib;

namespace Midgard {

	errordomain StorableError {

	}

	public interface Storable : GLib.Object {

	}

	errordomain MetadataError {

	}

	public abstract class Metadata : Storable {

	}

	errordomain SchemaObjectError {
		
	}

	public abstract class SchemaObject : Storable {

		/* properties */
		public string guid { get; };
		public uint id { get; };
		public Metadata { get; };	
	
		/* methods */
		public abstract void set_property_value (string name, GLib.Value);
		public abstract GLib.Value get_property_value (string name);
		public abstract string[]? list_all_properties ();
	}

	public abstract class DBObject : Storable {

	}
}
