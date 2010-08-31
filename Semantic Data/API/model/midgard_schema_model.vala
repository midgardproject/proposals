using GLib;

namespace Midgard {

	errordomain ValidationError {
		NAME_INVALID,
		TYPE_INVALID,
		VALUE_INVALID,
		REFERENCE_INVALID,
		PARENT_INVALID,
		LOCATION_INVALID
	}

	public interface Model : GLib.Object {
		
		/* properties */
		public abstract string name { get; construct; }

		/* methods */
		public abstract string get_name ();
		public abstract Model add_model (Model model);
		public abstract Model get_model_by_name (string name);
		public abstract Model add_parent_model (Model model);
		public abstract Model get_parent_model ();
		public abstract Model[]? list_models ();
	}

	public interface ModelProperty : Model, Executable {

		/* methods */
		public abstract void set_value_typename (string name);
		public abstract void set_value_gtype (GLib.Type type);
		public abstract void set_value_default (GLib.Value value);
		public abstract void set_private (bool toggle);
		public abstract void set_description (string description);
		public abstract bool set_namespace (string name);
		public abstract string get_namespace ();
	}

	public class SchemaModel : GLib.Object, Model {

		public string name {
			get { return "foo"; }
		}

		public string get_name () { return "foo"; }
		public SchemaModel? add_model (SchemaModel model) { return null; }
		public SchemaModel? get_model_by_name (string name) { return null; }
 		public SchemaModel? add_parent_model (SchemaModel model) { return null; }
 		public SchemaModel? get_parent_model () { return null; }
		public SchemaModel[]? list_models () { return null; }
 		public bool is_valid () { return false; }	
	}

	public class SchemaModelProperty : GLib.Object, Model {
	
		public string name {
			get { return "foo"; }
		}

		public string get_name () { return "foo"; }
		public SchemaModel? add_model (SchemaModel model) { return null; }
		public SchemaModel? get_model_by_name (string name) { return null; }
 		public SchemaModel? add_parent_model (SchemaModel model) { return null; }
 		public SchemaModel? get_parent_model () { return null; }
		public SchemaModel[]? list_models () { return null; }
		public bool is_valid () { return false; }

		public void set_value_typename (string name) { return; }
		public void set_value_gtype (GLib.Type type) { return; }
		public void set_value_default (GLib.Value value) { return; }
		public void set_private (bool toggle) { return; }
		public void set_description (string description) { return; }
		public bool set_namespace (string name) { return false; }
		public string get_namespace () { return "foo"; }
	}

	errordomain SchemaBuilderError {
		NAME_EXISTS
	}

	public class SchemaBuilder : GLib.Object, Executable {

		/* methods */
		public void register_model (SchemaModel model) throws SchemaBuilderError, ValidationError { }
		public void register_storage_models (StorageManager manager) throws SchemaBuilderError, ValidationError { }
		public Storable? factory (StorageManager storage, string classname) throws SchemaBuilderError, ValidationError { return null; }
		public SchemaModel? get_schema_model (string classname) { return null; }
		
		public void execute () { return; }
	}
}
