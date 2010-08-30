using GLib;

namespace Midgard {

	public interface QueryManager : GLib.Object {

	}

	public interface Config : GLib.Object {

	}

	/* FIXME, improve it so we can catch exception in one step */
	public interface Transaction : GLib.Object {

		public abstract string name ( get; construct; }

		public abstract bool begin ();
		public abstract bool commit ();
		public abstract bool rollback ();
		public abstract bool get_status ();
		public abstract string get_name ();
	}

	public interface StorageManagerPool : GLib.Object {
		
		public abstract void register_manager_type (string classname);
		public abstract StorageManager create_manager (string classname);
		public abstract string[]? list_managers();
		public abstract StorageManager? get_manager_by_name (string name);
	}

	errordomain StorageManagerError {
		ACCESS_DENIED
	}

	public interface StorageManager : GLib.Object {

		/* properties */
		public abstract string name { get; construct; }
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
		public abstract Profiler get_profiler ();
		public abstract Transaction? get_transaction ();
	}

	public interface StorageExecutor : Executable {
		
		/* methods */
		public abstract bool exists ();
	 	public abstract void prepare_create () throws ValidationError;
		public abstract void prepare_update () throws ValidationError;
		public abstract void prepare_save () throws ValidationError;
		public abstract void prepare_remove () throws ValidationError;
		public abstract void prepare_purge () throws ValidationError;
	}

	public interface StorageModelManager : SchemaModel, StorageExecutor {

		public abstract StorageManager get_storage_manager ();

		public abstract StorageModel create_storage_model (SchemaModel schema_model, string location);
		public abstract StorageModel[]? list_storage_models ();
		public abstract StorageModel? get_model_by_name (string name);
		public abstract SchemaModel[]? list_schema_models ();
		public abstract SchemaModel? get_schema_model_by_name (string name);
	}

	errordomain StorageContentManagerError {

		OBJECT_INVALID,
		OBJECT_DUPLICATE,
		INTERNAL
	}

	public interface StorageContentManager : GLib.Object {

		/* public abstract StorageManager storagemanager { get; construct; };  */

		public abstract StorageManager get_storage_manager ();

		/* per object methods */
		public abstract bool exists (Storable object);
		public abstract bool create (Storable object) throws StorageContentManagerError;
		public abstract bool update (Storable object) throws StorageContentManagerError;
		public abstract bool save (Storable object) throws StorageContentManagerError; 
		public abstract bool remove (Storable object) throws StorageContentManagerError;
		public abstract bool purge (Storable object) throws StorageContentManagerError;

		public abstract QueryManager get_query_manager ();
	} 

	/* Initialized for every given property name */
	public interface StorageModelProperty : StorageExecutor, ModelProperty {
	
		/* method */
		public abstract void set_primary (bool toggle);
		public abstract bool is_primary ();
		public abstract void set_index (bool toggle);
		public abstract bool has_index ();
		public abstract bool location_set (string location);
		public abstract string location_get ();
	}	

	errordomain StorageModelError {
		STORAGE_INVALID,
		STORAGE_EXISTS,
		INTERNAL
	}

	/* Initialized for every given class name */
	public interface StorageModel : Model {
		
		public abstract bool location_set (string location) throws StorageModelError;
		public abstract string location_get ();
	}
}
