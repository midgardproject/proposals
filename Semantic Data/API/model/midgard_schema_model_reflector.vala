
using GLib;

namespace Midgard {

	public interface SchemaModelReflector : GLib.Object {
	
		/* properties */
		public abstract SchemaModel { get; construct; }

		/* methods */
		public abstract string get_typename ();
		public abstract GLib.Type get_gtype ();
		public abstract GLib.Value get_default_value ();
	}
}
