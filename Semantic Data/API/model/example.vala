
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
	SchemaModel schema_model = new SchemaModel ("person");
	SchemaModelProperty fname_schema = new SchemaModelProperty ("firstname", "string", "", "Person firstname");
	SchemaModelProperty lname_schema = new SchemaModelProperty ("lastname", "string", "", "Person lastname");
	schema_model.add_model (fname_schema).add_model (lname_schame);
 
	/* Validate during execution. Might be ignored. */
	schema_model.execute ();

	/* Register class */
	try {
		Schema.register_type (type); /* Checks if type is valid and invoke execute() of given type model */	
	} catch (GLib.Error e) {
		GLib.error ("Can not register %s class. %s", type.name, e.message);
	}

	StorageModelManager model_manager = storage.get_model_manager();

	StorageModel storage_model = model_manager.create_storage_model (type, "tbl_person");
	fname_storage = new StorageModelProperty (fname_property, "firstname_field);
	lname_storage = new StorageModelProperty (lname_property, "lastname_field)
	storage_model.add_model (fname_mapper).add_model (lname_mapper);

	/* Store schema and mapper models for later use */
	model_manager.add_model (schema_model).add_model (storage_mapper);
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

	/* Register person class in GType system */
	SchemaBuilder builder = new SchemaBuilder ();
	builder.register_model (schema_model);

	try {
		builder.execute ();
	} catch (GLib.Error e) {
		GLib.Error ("Failed to register person class. %s", e.message);
	}

	/* Instantiate person */
	SchemaObject person = Schema.factory ("person") as SchemaObject;
	person.firstname = "John";

	/* Get content manager */
	StorageContentManager content = storage.get_content_manager ();
	content.create (person as Storable);

	/* Query data */
}
