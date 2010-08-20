using GLib;

namespace Midgard {

	errordomain SchemaModelError {
		NAME_INVALID,
		TYPE_INVALID,
		VALUE_INVALID,
		REFERENCE_INVALID,
		PARENT_INVALID
	}

	public interface SchemaModel : Glib.Object {
		
		/* properties */
		public abstract string name { get; construct; }

		/* methods */
		public abstract string get_name ();
		public abstract SchemaModel type_add (SchemaModel model);
		public abstract SchemaModel type_get (string name);
		public abstract SchemaModel type_add_parent (SchemaModel model);
		public abstract SchemaModel type_get_parent ();
	}

	public class SchemaTypeProperty : SchemaModel {

		/* methods */
		public abstract void set_value_typename (string type);
		public abstract string get_value_typename ();
		public abstract void set_value_gtype (GLib.Type type);
		public abstract GLib.Type get_value_gtype (GLib.Type type);
		public abstract void set_value_default (GLib.Value);
		public abstract GLib.Value get_value_default ();
		public abstract void set_private();
		public abstract void set_description (string description);
		public abstract bool set_namespace (string name);
		public abstract string get_namespace ();
	}

	public class SchemaType : SchemaModel {

	}

	public class Schema : GLib.Object {

		/* methods */
		public abstract void register_type (SchemaType type) throws SchemaError;
		public abstract void register_available_types () throws SchemaError;
		public abstract Storable? factory (Connection mgd, string classname) throws SchemaError;
		public abstract Schematype? get_schema_type (string classname); 
	}
}
