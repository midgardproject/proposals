
using Glib;

namespace Midgard {

	errordomain WorkspaceStorageError {
	        WORKSPACE_STORAGE_ERROR_NAME_EXISTS,
        	WORKSPACE_STORAGE_ERROR_INVALID_PATH,
        	WORKSPACE_STORAGE_ERROR_OBJECT_NOT_EXISTS,
       		WORKSPACE_STORAGE_ERROR_CONTEXT_VIOLATION
	}

	public interface WorkspaceStorage : GLib.Object {
	
		public abstract string path { get; construct; }
	}

	public class WorkspaceContext : GLib.Object, WorkspaceStorage {

		public string[]? get_workspace_names ();
		public Workspace? get_workspace_by_name (); 
		public bool has_workspace (Workspace workspace);
	}

	public class Workspace : GLib.Object, WorkspaceStorage {

		public Workspace parent { get; construct; }
		public WorkspaceContext context { get; }

		public Workspace[]? list_children ();
		public Workspace? get_by_path ();
	}

	public class SQLWorkspaceManager : StorageWorkspaceManager, SQLStorageManager {

		public WorkspaceStorage workspace { get; set; }
		public bool workspace_create (WorkspaceStorage workspace) throws WorkspaceStorageError;
		public bool workspace_exists (WorkspaceStorage workspace) throws WorkspaceStorageError;	
	}
}
