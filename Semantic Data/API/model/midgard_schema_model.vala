using GLib;

namespace Midgard {

	errordomain SchemaModelError {
		NAME_INVALID,
		TYPE_INVALID,
		VALUE_INVALID,
		REFERENCE_INVALID,
		PARENT_INVALID
	}

	public interface SchemaModel : GLib.Object {
		
		/* properties */
		public abstract string name { get; construct; }

		/* methods */
		public abstract string get_name ();
		public abstract SchemaModel add_model (SchemaModel model);
		public abstract SchemaModel get_model_by_name (string name);
		public abstract SchemaModel add_parent_model (SchemaModel model);
		public abstract SchemaModel get_parent_model ();
		public abstract bool is_valid () throws SchemaModelError;
	}

	public interface SchemaModelProperty : SchemaModel, Executable {

		/* methods */
		public abstract void set_value_typename (string type);
		public abstract void set_value_gtype (GLib.Type type);
		public abstract void set_value_default (GLib.Value);
		public abstract void set_private();
		public abstract void set_description (string description);
		public abstract bool set_namespace (string name);
		public abstract string get_namespace ();
	}

	public class SchemaType : SchemaModel, Executable {

	}

	errordomain SchemaError {
		NAME_EXISTS
	}

	public class Schema : GLib.Object {

		/* methods */
		public abstract void register_type (SchemaType type) throws SchemaError, SchemaModelError;
		public abstract void register_available_types () throws SchemaError, SchemaModelError;
		public abstract Storable? factory (Connection mgd, string classname) throws SchemaError, SchemaModelError;
		public abstract Schematype? get_schema_type (string classname); 
	}
}
