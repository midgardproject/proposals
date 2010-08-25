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
		public abstract void set_value_default (GLib.Value value);
		public abstract void set_private();
		public abstract void set_description (string description);
		public abstract bool set_namespace (string name);
		public abstract string get_namespace ();
	}

	public class SchemaType : GLib.Object, SchemaModel, Executable {

		public string name {
			get { return "foo"; }
		}

		public string get_name () { return "foo"; }
		public SchemaModel? add_model (SchemaModel model) { return null; }
		public SchemaModel? get_model_by_name (string name) { return null; }
 		public SchemaModel? add_parent_model (SchemaModel model) { return null; }
 		public SchemaModel? get_parent_model () { return null; }
 		public bool is_valid () { return false; }
 		public void execute () { } 
	}

	errordomain SchemaError {
		NAME_EXISTS
	}

	public class Schema : GLib.Object {

		/* methods */
		public void register_type (SchemaType type) throws SchemaError, SchemaModelError { }
		public void register_available_types () throws SchemaError, SchemaModelError { }
		public Storable? factory (StorageManager storage, string classname) throws SchemaError, SchemaModelError { return null; }
		public SchemaType? get_schema_type (string classname) { return null; }
	}
}
