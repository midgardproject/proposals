
using GLib;
using Midgard;

namespace Midgard {

	Config config = new Config ();
	config.dbtype = "SQLite";

	/* Open connection to SQLite database */
	StorageManagerSQL storage = new StorageManagerSQL ("config", config);
	try {
		storage.open ();
	} catch ( GLib.Error e ) {
		GLib.warning "Failed to open storage with given config. %s", e.message);
	}

	/* List all available schemas and register classes for GObject */
	unowned SchemaType[] types = storage.list_schema_types ();
	foreach (SchemaType type in types) {
		Schema.register_type (type);
	}	

	/* Make sure every class has storage created */
	unowned StorageMapperType[] mappers = storage.list_storage_mapers ();
	foreach (SchemaMapperType mapper in mappers) {
		storage.create_storage (mapper);
	}

	/* Instantiate person (we assume it's already registered) */
	SchemaObject person = Schema.factory ("person") as SchemaObject;
	person.firstname = "John";

	/* Get content manager */
	StorageContentManager content = storage.get_content_manager ();
	content.create (person as Storable);
}
