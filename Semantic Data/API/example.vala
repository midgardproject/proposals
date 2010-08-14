
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

	/* Create schema for 'person' class */
	SchemaType type = new SchemaType ("name", "person");
	SchemaTypeProperty prop = new SchemaTypeProperty ("name", "firstname");
	prop.set_value_typename ("string");
	
	/* Add 'firstname' property */
	type.property_add (prop);

	/* Create storage mapping for 'person' class */
	StorageMapperType type_mapper = new StorageMapperType ("name", "person");
	type_mapper.set_location ("tbl_person");

	/* Create storage field for 'firstname' property */
	StorageMapperTypeProperty property_mapper = new StorageMapperTypeProperty ("name", "firstname");
	property_mapper.set_location ("name_field");
	property_mapper.has_index = false;
	property_mapper.is_primary = false;

	type_mapper.add_property_mapper (property_mapper);

	/* Register class */
	try {
		Schema.register_type (type, "SchemaObject");	
	} catch (GLib.Error e) {
		GLib.error ("Can not register %s class. %s", type.name, e.message);
	}

	/* Create underlying storage for newly registered class */
	storage.create_storage (type_mapper);
	storage.create_storage_element (type_mapper, property_mapper);
	
	/* Instantiate person */
	SchemaObject person = Schema.factory ("person") as SchemaObject;
	person.firstname = "John";

	/* Get content manager */
	StorageContentManager content = storage.get_content_manager ();
	content.create (person as Storable);

	/* Query data */
}
