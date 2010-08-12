using GLib;

namespace Midgard {

	errordomain StorageManagerError {
		OBJECT_INVALID,
		OBJECT_DUPLICATE,
		PATH_RELATIVE,
		PATH_INVALID,
		INTERNAL
	}

	/*
	nodes iface ?
		public abstract Storable? get_by_path (string path) throws StoragemanagerError;
		public abstract string? get_path (Storable);

	*/

	public interface StorageManager : GLib.Object {

		public abstract Config config { get; construct; }

		/* connection methods */
		public abstract bool open () throws FIXME ;
		public abstract void close ();
		public abstract StorageManager fork ();
		public abstract Storagemanager clone ();

		/* per object methods */
		public abstract bool exists (Storable object);
		public abstract bool create (Storable object) throws StorageManagerError;
		public abstract bool update (Storable object) throws StorageManagerError;
		public abstract bool save (Storable object) throws StorageManagerError; 
		public abstract bool remove (Storable object) throws StorageManagerError;
		public abstract bool purge (Storable object) throws StorageManagerError;

		/* per class methods */
		public abstract bool create_storage (string classname);
		public abstract bool update_storage (string classname);
		public abstract bool remove_storage (string classname);
	}

	errordomain StorageMapperTypePropertyError {
		TYPE_INVALID,
		VALUE_INVALID,
		LOCATION_EXISTS,
		LOCATION_INVALID
	}

	/* Initialized for every given property name */
	public interface StorageMapperTypeProperty : GLib.Object {
	
		/* properties */
		public abstract string name { get; construct; }
		public abstract bool has_index { get; set; }
		public abstract bool is_primary { get; set; }

		/* method */
		public abstract void value_set_typename (string type);
		public abstract string value_get_typename ();
		public abstract void value_set_gtype (GLib.Type type);
		public abstract GLib.Type value_get_gtype ();
		public abstract bool is_valid () throws StorageManagerTypePropertyError;
		public abstract void value_set_default (GLib.Value val);
		public abstract GLib.Value value_get_default ();
		public abstract bool value_has_default ();
		public abstract bool location_set (string location) throws StorageManagerTypePropertyError;
		public abstract string location_get ();
	}	

	errordomain StorageMapperTypeError {
		NOT_EXIST
	}

	/* Initialized for every given class name */
	public interface StorageMapperType : GLib.Object {
		
		/* properties */
		public abstract string name { get; construct; }

		/* methods */
		public abstract StorageMapperTypeProperty get_property_mapper (string name);
		public abstract string[]? list_property_names ();
		public abstract StorageManagerTypeProperty[]? list_properties();
	}
}
