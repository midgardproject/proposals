using GLib;

namespace Midgard {

	errordomain StorableError {
		
	}

	public interface Storable : GLib.Object {

		/* signals */
		public abstract signal void create ();
		public abstract signal void created ();
		public abstract signal void update ();
		public abstract signal void updated ();
		public abstract signal void remove ();
		public abstract signal void removed ();

		/* methods */
		public abstract SchemaManager? get_schema_manager ();
	}

	errordomain MetadataError {

	}

	public abstract class Metadata : Storable {

		/* proprties */
		public abstract string parent { get; construct; };	
		public abstract uint action { get; }; /* is it needed ? */
		public abstract Timestamp created { get; };
		public abstract Timestamp revised { get; };
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
