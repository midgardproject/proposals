using GLib;

namespace Midgard {

	errordomain StorageManagerError {
		OBJECT_INVALID,
		OBJECT_DUPLICATE,
		PATH_RELATIVE,
		PATH_INVALID,
		INTERNAL
	}

	public interface StorageManager : GLib.Object {

		/* methods */
		public abstract bool exists ();
		public abstract bool create () throws StorageManagerError;
		public abstract bool update () throws StorageManagerError;
		public abstract bool save () throws StorageManagerError; 
		public abstract bool remove () throws StorageManagerError;
		public abstract bool purge () throws StorageManagerError;
		public abstract Object? get_by_path (string path) throws StoragemanagerError;
		public abstract string? get_path ();
	}

	errordomain StorageMapperTypePropertyError {
		TYPE_INVALID
	}

	public interface StorageMapperTypeProperty : GLib.Object {
	
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

	errordomain StorageMapperTypeError {
		NOT_EXIST
	}

	public interface StorageMapperType : GLib.Object {
		
		/* properties */
		public abstract string name { get; construct; }

		/* methods */
		public abstract StorageManagerTypeProperty get_property_manager (string name);
		public abstract string[]? list_property_names ();
		public abstract StorageManagerTypeProperty[]? list_properties();
	}
}
