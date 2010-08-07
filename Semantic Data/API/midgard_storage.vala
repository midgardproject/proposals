using GLib;

namespace Midgard {

	errordomain StorageManagerError {
		INTERNAL
	}

	public interface StorageManager : GLib.Object {

		/* methods */
		public abstract bool exists ();
		public abstract void create () throws StorageManagerError;
		public abstract void update () throws StorageManagerError; 
		public abstract void remove () throws StorageManagerError;
	}

	errordomain StorageManagerTypePropertyError {
		TYPE_INVALID
	}

	public interface StorageManagerTypeProperty : GLib.Object {

		/* properties */
		public abstract string name { get; construct; }
		public abstract bool index { get; set; }
		public abstract bool is_pk { get; set; }

		/* method */
		public abstract void set_typename (string type);
		public abstract string get_typename ();
		public abstract void set_gtype (GLib.Type type);
		public abstract GLib.Type get_gtype ();
		public abstract bool is_valid () throws StorageManagerTypePropertyError;
		public abstract void set_default_value (GLib.Value val);
		public abstract GLib.Value get_default_value ();
		public abstract bool has_default_value ();
	}	

	errordomain StorageManagerTypeError {
		NOT_EXIST
	}

	public interface StorageManagerType : GLib.Object {
		
		/* properties */
		public abstract string name { get; construct; }

		/* methods */
		public abstract StorageManagerTypeProperty get_property_storage_manager (string name);
		public abstract string[]? list_property_names ();
		public abstract StorageManagerTypeProperty[]? list_properties();
	}
}
