
using Glib;

namespace Midgard {

	public class SQLStorageManager : GLib.Object, StorageManager {

		private string _name = "";
		private Config _config = null;
		private StorageContentManager _content_manager = null;
		private Profiler _profiler = null;
		private Transaction _transaction = null;
		private StorageWorkspaceManager _workspace_manager = null;

		public string name {
			get { return _name; }
			set { _name = value; }
		}
		
		public Config config {
			get { return _config; }
			set { _config = value; }
		}	

		public ContentManager content_manager {
			get { 
				if (!_content_manager)
					_content_manager = ContentManagerSQL ();
				return _content_manager; 
			} 
		}

		public Profiler profiler {
			get { return _profiler; }
		}
			
		public Transaction transaction {
			get { return _transaction; }
		}
		
		public WorkspaceManager workspace_manager {
			get { return _workspace_manager; }
		}

		public bool open () { return false; }
		public bool close () { return false; }

		public StorageManager fork () { return null; }
		public StorageManager clone () { return null; }
	}
}
