using GLib;

namespace Midgard {

	errordomain SchemaTypePropertyError {
		NAME_INVALID,
		TYPE_INVALID,
		VALUE_INVALID,
		REFERENCE_INVALID
	}

	public interface SchemaTypeProperty : GLib.Object {

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
		public abstract bool set_namespace (string name);
		public abstract string get_namespace ();
	}

	errordomain SchemaTypeError {
		NAME_EXISTS,
		NAME_INVALID,
		PROPERTY_EXISTS,
		STORAGE_INVALID
	}

	public interface SchemaType : GLib.Object {

		/* properties */
		public abstract string name { get; construct;}	

		/* methods */
		public abstract bool property_exists (SchemaTypeProperty property);
		public abstract void property_add (SchemaTypeProperty property) throws SchemaTypeError;
		public abstract SchemaTypeProperty? get_property (string name); 
		public abstract void set_storage_mapper (StorageMapper mapper) throws SchemaTypeError;

	}

	errordomain SchemaError {
		TYPE_EXISTS,
		TYPE_INVALID,
		INTERNAL
	}

	public interface Schema : GLib.Object {

		/* methods */
		public abstract void register_type (SchemaType type, SchemaType parent) throws SchemaError;
		public abstract void register_available_types () throws SchemaError;
		public abstract Object? factory (Connection mgd, string classname) throws SchemaError;
		public abstract Schematype? get_schema_type (string classname); 
	}
}
