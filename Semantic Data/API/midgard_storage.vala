using GLib;

namespace Midgard {

	/*
	nodes iface ?
		public abstract Storable? get_by_path (string path) throws StoragemanagerError;
		public abstract string? get_path (Storable);

	*/

	errordomain StorageManagerError {
		STORAGE_INVALID,
		STORAGE_EXISTS,
		INTERNAL
	}

	public interface StorageManager : GLib.Object {

		/* properties */
		public abstract Config config { get; construct; }

		/* signals */
		public signal void connected ();
		public signal void disconnected ();
		public signal void lost-provider (); 

		/* connection methods */
		public abstract bool open () throws FIXME ;
		public abstract void close ();
		public abstract StorageManager fork ();
		public abstract Storagemanager clone ();

		public abstract bool create_storage (StorageMapperType mapper);
		public abstract bool update_storage (StorageMapperType mapper);
		public abstract bool remove_storage (StorageMapperType mapper);
		public abstract bool exists_storage (StorageMapperType mapper);
		public abstract bool move_storage (StorageMapperType src, StorageMapperType dest);
		public abstract bool create_storage_element (StorageMapperType mapper, StorageMapperTypeProperty property);
		public abstract bool update_storage_element (StorageMapperType mapper, StorageMapperTypeProperty property);
		public abstract bool remove_storage_element (StorageMapperType mapper, StorageMapperTypeProperty property);
		public abstract bool move_storage_element (StorageMapperTypeProperty src, StoragemapperTypeProperty dest);

		public abstract StorageMapperType[]? list_storage_mappers ();
		public abstract StoragemapperType? get_storage_mapper (string name);
		public abstract SchemaType[]? list_schema_types ();
		public abstract SchemaType? get_schema_type (string name);
		public abstract StorageContentManager? get_content_manager ();
	}

	errordomain StorageContentManagerError {

		OBJECT_INVALID,
		OBJECT_DUPLICATE,
		INTERNAL
	}

	public interface StorageContentManager : GLib.Object {

		public abstract StorageManager storagemanager { get; construct; }; 

		/* per object methods */
		public abstract bool exists (Storable object);
		public abstract bool create (Storable object) throws StorageContentManagerError;
		public abstract bool update (Storable object) throws StorageContentManagerError;
		public abstract bool save (Storable object) throws StorageContentManagerError; 
		public abstract bool remove (Storable object) throws StorageContentManagerError;
		public abstract bool purge (Storable object) throws StorageContentManagerError;

		public abstract QueryManager get_query_manager ();
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
		public abstract bool is_valid () throws StorageMapperTypePropertyError;
		public abstract void value_set_default (GLib.Value val);
		public abstract GLib.Value value_get_default ();
		public abstract bool value_has_default ();
		public abstract bool location_set (string location) throws StorageMapperTypePropertyError;
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
		public abstract bool add_property_mapper (StorageMapperTypeProperty property);
		public abstract StorageMapperTypeProperty get_property_mapper (string name);
		public abstract string[]? list_property_names ();
		public abstract StorageManagerTypeProperty[]? list_properties();
		public abstract bool location_set (string location) throws StorageMapperTypeError;
		public abstract string location_get ();
	}
}
