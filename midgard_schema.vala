using GLib;

namespace Midgard {

	errordomain SchemaManagerTypePropertyError {
		NAME_INVALID,
		TYPE_INVALID,
		VALUE_INVALID,
		REFERENCE_INVALID
	}

	public interface SchemaManagerTypeProperty : GLib.Object {

		/* properties */
		public abstract string name { get; construct; }

		/* methods */
		public abstract void set_typename (string type) throws SchemaTypePropertyError;
		public abstract string get_typename	();
		public abstract void set_gtype (GLib.Type type) throws SchemaTypePropertyError;
		public abstract GLib.Type get_gtype (GLib.Type type);
		public abstract void set_default_value (GLib.Value) throws SchemaTypePropertyError;
		public abstract GLib.Value get_default_value ();
		public abstract void set_private();
		public abstract void set_description (string description);
		public abstract void set_reference (SchemaType type, SchemaProperty property) throws SchemaTypeProperty;
	}

	errordomain SchemaManagerTypeError {
		NAME_EXISTS,
		NAME_INVALID,
		PROPERTY_EXISTS,
		STORAGE_INVALID
	}

	public interface SchemaManagerType : GLib.Object {

		/* properties */
		public abstract string name { get; construct;}	

		/* methods */
		public abstract bool property_exists (SchemaTypeProperty property);
		public abstract void property_add (SchemaTypeProperty property) throws SchemaTypeError;
		public abstract void register () throws SchemaTypeError;
		public abstract void set_storage_manager (StorageManager manager) throws SchemaTypeError;
	}

	errordomain SchemaStorageError {
		TYPE_EXISTS,
		INTERNAL
	}

	public interface SchemaStorage : GLib.Object {

		/* properties */
		public abstract SchemaType schematype { get; construct; }

		/* methods */
		public abstract bool exists ();
		public abstract void create () throws SchemaStorageError;
		public abstract void update () throws SchemaStorageError; 
		public abstract void remove () throws SchemaStorageError;
	}
}
