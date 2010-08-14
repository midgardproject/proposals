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
		public abstract void set_value_typename (string type) throws SchemaTypePropertyError;
		public abstract string get_value_typename	();
		public abstract void set_value_gtype (GLib.Type type) throws SchemaTypePropertyError;
		public abstract GLib.Type get_value_gtype (GLib.Type type);
		public abstract void set_value_default (GLib.Value) throws SchemaTypePropertyError;
		public abstract GLib.Value get_value_default ();
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
	}

	errordomain SchemaError {
		TYPE_EXISTS,
		TYPE_INVALID,
		INTERNAL
	}

	public interface Schema : GLib.Object {

		/* methods */
		public abstract void register_type (SchemaType type, string parent) throws SchemaError;
		public abstract void register_available_types () throws SchemaError;
		public abstract Storable? factory (Connection mgd, string classname) throws SchemaError;
		public abstract Schematype? get_schema_type (string classname); 
	}
}
