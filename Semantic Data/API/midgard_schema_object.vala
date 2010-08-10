using GLib;

namespace Midgard {

	errordomain StorableError {

	}

	public interface Storable : GLib.Object {

		/* methods */
		public abstract StorageManager? get_storage_manager ();
		public abstract QueryManager? get_query_manager ();
	}

	errordomain SchemaObjectError {
		
	}

	public interface SchemaObject : Storable {

		/* methods */
		public abstract SchemaManager? get_schema_manager ();
		public abstract void set_property_value (string name, GLib.Value);
		public abstract GLib.Value get_property_value (string name);
		public abstract string[]? list_all_properties ();
	}
}
