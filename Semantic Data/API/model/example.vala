
using GLib;
using Midgard;

namespace Midgard {

	Config config = new Config ();
	config.dbtype = "SQLite";

	/* Open connection to SQLite database */
	StorageManagerSQL storage = new StorageManagerSQL (config);
	try {
		storage.open ();
	} catch ( GLib.Error e ) {
		GLib.warning "Failed to open storage with given config. %s", e.message);
	}

	/* Create schema model for 'person' class */
	SchemaType type = new SchemaType ("person");
	fname_property = new SchemaTypeProperty ("firstname", "string", "", "Person firstname");
	lname_property = new SchemaTypeProperty ("lastname", "string", "", "Person lastname");
	type.add_model (fname_property).add_model (lname_property);
 
	/* Validate during execution. Might be ignored. */
	type.execute ();

	/* Register class */
	try {
		Schema.register_type (type); /* Checks if type is valid and invoke execute() of given type model */	
	} catch (GLib.Error e) {
		GLib.error ("Can not register %s class. %s", type.name, e.message);
	}

	StorageModelManager model_manager = storage.get_model_manager();

	StorageMapper storage_mapper = model_manager.create_mapper (type, "tbl_person");
	fname_mapper = new StorageMapperTypeProperty (fname_property, "firstname_field);
	lname_mapper = new StorageMapperTypeProperty (lname_property, "lastname_field)
	storage_mapper.add_model (fname_mapper).add_model (lname_mapper);

	/* Store schema and mapper models for later use */
	StorageModelManager model_manager = storage.get_model_manager();
	model_manager.add_model (type).add_model (storage_mapper);
	
	model_manager.prepare_create ();

	try {
		model_manager.execute  ();
	} catch (Glib.Error e) {
		GLib.error ("Failed to store models. %s", e.message);
	}

	/* Create underlying storage for newly registered class */
	storage_mapper.prepare_create ();

	try {
		storage_mapper.execute ();
	} catch (GLib.Error e) {
		GLib.error ("Can not initialize storage for %s class. %s", type.name, e.message);
	}

	/* Instantiate person */
	SchemaObject person = Schema.factory ("person") as SchemaObject;
	person.firstname = "John";

	/* Get content manager */
	StorageContentManager content = storage.get_content_manager ();
	content.create (person as Storable);

	/* Query data */
}
