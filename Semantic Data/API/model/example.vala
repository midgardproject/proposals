
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
 
	/* Prepare to register class */
	SchemaBuilder schema_builder = new SchemaBuilder ();
	schema_builder.register_model (schema_model);

	try {
		/* Validate and register person class */
		schema_builder.execute (); 
	} catch (GLib.Error e) {
		GLib.error ("Can not register %s class. %s", type.name, e.message);
	}

	/* person class is valid and already registered. Prepare its models */
	StorageModelManager model_manager = storage.get_model_manager();

	StorageModel storage_model = model_manager.create_storage_model (type, "tbl_person");
	StorageModelProperty fname_storage = new StorageModelProperty (fname_property, "firstname_field);
	StorageModelProperty lname_storage = new StorageModelProperty (lname_property, "lastname_field)
	storage_model.add_model (fname_mapper).add_model (lname_mapper);

	/* SchemaModel might be used and valid during application lifetime only.
	 Add SchemaModel to ModelManager, if it should be reused later. */
	model_manager.add_model (schema_model);

	/* Create storage for defined class and its model info if succeded */
	model_manager.add_model (storage_model);
	model_manager.prepare_create ();

	try {
		model_manager.execute  ();
	} catch (Glib.Error e) {
		GLib.error ("Failed to store models. %s", e.message);
	}

	/* Instantiate person */
	SchemaObject person = SchemaBuilder.factory ("person") as SchemaObject;
	person.firstname = "John";

	/* Get content manager */
	StorageContentManager content = storage.get_content_manager ();
	content.create (person as Storable);

	/* Query data */
}
