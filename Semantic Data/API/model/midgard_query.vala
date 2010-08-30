using GLib;


namespace Midgard
{
	public interface QueryConstraintSimple : Glib.Object {

		QueryConstraintSimple[]? list_constraints ();
	}

	public interface QueryStorage : GLib.Object {
		
		/* properties */
		public string classname { get; set; }
	}

	public interface QueryConstraint : QueryConstraintSimple {

		/* properties */
		public QueryHolder holder { get; set; }
		public QueryProperty property { get; set; }
		public QueryStorage storage { get; set; }
		public string operator { get; set; }

		/* methods */
		public abstract QueryStorage? get_storage ();
		public abstract void set_storage (QueryStorage storage);
		public abstract QueryProperty? get_property ();
		public abstract void set_property (QueryProperty property);
		public abstract string  get_operator ();
		public abstract void set_operator (string operator);
	}

	public interface QueryConstraintGroup : QueryConstraintSimple {

		/* properties */
		public abstract string grouptype { get; set; }

		public abstract string get_group_type ();
		public abstract void set_group_type (string name);
		public abstract void add_constraint (QueryConstraintSimple constraint);
	}

	public interface QueryConstraintValueHolder : GLib.Object {
		
		public abstract GLib.Value get_value ();
		public abstract void set_value (GLib.Value); 
	}	

	public class QueryValue : GLib.Object, QueryConstraintValueHolder {
		
	}

	public class QueryProperty : GLib.Object, QueryConstraintValueHolder {
		
		/* properties */
		string property { get; set; }
		QueryStorage storage { get; set; }
	}

	public interface QueryExecutor : Executable {

		public abstract void set_constraint (QueryConstraintSimple constraint);
		public abstract void set_limit (uint limit);
		public abstract void set_offset (uint offset);
		public abstract void add_order (QueryProperty property, string type);
		public abstract uint get_results_count ();
		public abstract void validate () throws ValidationError;
	}

	public interface QuerySelect : QueryExecutor {
		
		public abstract void add_join (string type, QueryProperty left_property, QueryProperty right_property);		
		public abstract void Storable[]? list_objects ();
		public abstract void toggle_read_only (bool toggle);
	}

	public interface QueryData : QueryExecutor {
		
		public abstract void add_join (string type, QueryProperty left_property, QueryProperty right_property);		
		public abstract ?? list_data ();
	}
}
