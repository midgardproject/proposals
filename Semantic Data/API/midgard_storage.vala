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
		public abstract bool exists (Storable object);
		public abstract bool create (Storable object) throws StorageManagerError;
		public abstract bool update (Storable object) throws StorageManagerError;
		public abstract bool save (Storable object) throws StorageManagerError; 
		public abstract bool remove (Storable object) throws StorageManagerError;
		public abstract bool purge (Storable object) throws StorageManagerError;
		public abstract Storable? get_by_path (string path) throws StoragemanagerError;
		public abstract string? get_path (Storable);
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
		public abstract void value_set_typename (string type);
		public abstract string value_get_typename ();
		public abstract void value_set_gtype (GLib.Type type);
		public abstract GLib.Type value_get_gtype ();
		public abstract bool is_valid () throws StorageManagerTypePropertyError;
		public abstract void value_set_default (GLib.Value val);
		public abstract GLib.Value value_get_default ();
		public abstract bool value_has_default ();
	}	

	errordomain StorageMapperTypeError {
		NOT_EXIST
	}

	public interface StorageMapperType : GLib.Object {
		
		/* properties */
		public abstract string name { get; construct; }

		/* methods */
		public abstract StorageMapperTypeProperty get_property_mapper (string name);
		public abstract string[]? list_property_names ();
		public abstract StorageManagerTypeProperty[]? list_properties();
	}
}
