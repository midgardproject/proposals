using GLib;

namespace Midgard {

	public interface QueryManager : GLib.Object {

	}

	public interface Config : GLib.Object {

	}

	errordomain StorageManagerError {
		ACCESS_DENIED
	}

	public interface StorageManager : GLib.Object {

		/* properties */
		public abstract Config config { get; construct; }

		/* signals */
		public abstract signal void connected ();
		public abstract signal void disconnected ();
		//public abstract signal void lost-provider (); 

		/* connection methods */
		public abstract bool open () throws StorageManagerError ;
		public abstract void close ();

		/* FIXME, add Clonable interface ? */
		public abstract StorageManager fork ();
		public abstract StorageManager clone ();

		public abstract StorageContentManager? get_content_manager ();
		public abstract StorageModelManager? get_model_manager (); 
	}

	public interface StorageExecutor : Executable {
		
		/* methods */
		public abstract bool exists ();
	 	public abstract void prepare_create ();
		public abstract void prepare_update ();
		public abstract void prepare_save ();
		public abstract void prepare_remove ();
		public abstract void prepare_purge ();
	}

	public interface StorageModelManager : SchemaModel, StorageExecutor {

		public abstract StorageMapperType create_mapper (SchemaType type, string location);
		public abstract StorageMapperType[]? list_mappers ();
		public abstract StorageMapperType? get_mapper_by_name (string name);
		public abstract SchemaType[]? list_schemas ();
		public abstract SchemaType? get_schema_by_name (string name);
	}

	errordomain StorageContentManagerError {

		OBJECT_INVALID,
		OBJECT_DUPLICATE,
		INTERNAL
	}

	public interface StorageContentManager : GLib.Object {

		/* public abstract StorageManager storagemanager { get; construct; };  */

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
	public interface StorageMapperTypeProperty : StorageExecutor, SchemaModelProperty {
	
		/* method */
		public abstract void set_primary (bool toggle);
		public abstract bool is_primary ();
		public abstract void set_index (bool toggle);
		public abstract bool has_index ();
		public abstract bool location_set (string location);
		public abstract string location_get ();
	}	

	errordomain StorageMapperTypeError {
		STORAGE_INVALID,
		STORAGE_EXISTS,
		INTERNAL
	}

	/* Initialized for every given class name */
	public interface StorageMapperType : StorageExecutor, SchemaModel {
		
		/* properties */
		public abstract string name { get; construct; }

		/* methods */
		public abstract bool add_property_mapper (StorageMapperTypeProperty property);
		public abstract StorageMapperTypeProperty get_property_mapper (string name);
		public abstract string[]? list_property_names ();
		public abstract StorageMapperTypeProperty[]? list_properties();
		public abstract bool location_set (string location) throws StorageMapperTypeError;
		public abstract string location_get ();
	}
}
