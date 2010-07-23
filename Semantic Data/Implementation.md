RDF Namespaces registry
=======================

RDF values are URIs which are often long and not human-friendly. There is a common practice of using namespace-aliases (shortcuts) to fix the issue

Registry can be stored like this:

    CREATE TABLE midgard_rdf_namespaces(
        uri varchar(1024) key,   # http://dublincore.org/documents/dcmi-namespace/
        shortcut varchar(64) key # dc
    );

And have API like this:

    MidgardStorage::getFullParameterName('dc:title');
    // ==>  http://dublincore.org/documents/dcmi-namespace/title
    
    MidgardStorage::getShortParameterName('http://dublincore.org/documents/dcmi-namespace/tableOfContents');
    // ==>  dc:tableOfContents


Schema
======

Schema is used to define Classes and their pre-defined properties 

Storage of Data Structure
-------------------------

Entities:

* Basic Data Types (xsd:integer, xsd:string, etc… see [list of XSD-types](http://books.xmlschemata.org/relaxng/relax-CHP-19.html))
* Classes
* Properties (name=URI + range=[Class|Basic] + …)

Property is mapped to classes in **many-to-many** fashion (dc:title is a valid property of many classes)

Basic Data Types should be mapped to GDA data types

If Property's range is Class, then this property implies a link between Classes

API
---

ToDo


Mapper
======

Mapper defines mapping of Classes to Database Tables.

Intro
-----

By default, Midgard's database has only service tables. Definition of Class in Schema doesn't result in creation of table.

Initially, object consists of the single GUID record in "parameters" table. Something like:

    INSERT INTO `parameters` (guid, name, value)
                      VALUES ('f0000000000000000000000000000000000f', 'hasClass', 'HelloWorld');

which means: "object with guid 'f00…00f' is an instance of HelloWorld class"

Similarily, other fields of objects are added as parameters.

So, by default, all data resides in the **same table**. Clearly, this is not the most efficient way of storing data, so we need an API which will allow us to move data from parameters to specific tables and back.

API
---

API can be implemented in MidgardStorage class

    $mapping = MidgardStorage::getMapping('HelloWorld');
    /*
    array(
        '_tables' => array(),
        'hello' => null,
        'world' => null
    )
    */

    MidgardStorage::moveFieldToTable('HelloWorld', 'hello', 'helloworld_base');
    /*
    array(
        '_tables' => array('helloworld_base'),
        'hello' => 'helloworld_base',
        'world' => null
    )
    1) CREATE TABLE helloworld_base (guid char(80), hello text);
    2) in transaction: insert rows, delete corresponding parameters
    */

    MidgardStorage::moveFieldToTable('HelloWorld', 'world', 'helloworld_base');
    /*
    array(
        '_tables' => array('helloworld_base'),
        'hello' => 'helloworld_base',
        'world' => 'helloworld_base'
    )
    1) ALTER TABLE helloworld_base ADD COLUMN world text;
    2) in transaction: update rows, delete corresponding parameters
    */

    MidgardStorage::moveFieldToParameters('HelloWorld', 'hello');
    /*
    array(
        '_tables' => array('helloworld_base'),
        'hello' => null,
        'world' => 'helloworld_base'
    )
    1) in transaction: insert parameters
    2) ALTER TABLE helloworld_base DROP COLUMN hello;
    */

Theoretically, data of the single class can be divided even between several tables for optimisation purposes.

### Q&A

> **Q:** (piotras) Starting transaction implicitly in core is very bad idea (or user is not allowed to start own transaction). 

> **A:** This is not a normal operation. It is intended for administrator and he is supposed to know implications. Transaction is required, because it is a large data-move operation and we absolutely need consistency here.

> **comment(piotras):** If any of such critical operation must be done by administrator which has particular tool/ui/whatever, such tool should explicitly start and commit transaction. 

> **Q:** (piotras) Dividing class data between tables is even worse idea (this is practical point of view after using this approach in Midgard for years).

> **A:** Well, I am ok with not allowing this. Just thought that in some edge-cases it might be useful 

> **comment(piotras):** With jval we recently tested such operation with multilang in Ragnaroek. Join for class tables decreased performance ~20x.

Storage
-------

Mapping data can be stored in service tables similar to this:

    CREATE TABLE midgard_schema_mapper_tables (
        tablename varchar(1024) primary key,
        classname varchar(1024) key
    );

    CREATE TABLE midgard_schema_mapper_fields (
        classname varchar(1024) key,
        fieldname varchar(1024),
        tablename varchar(1024) key,
        table_field varchar(1024),
        primary key (classname, fieldname)
    );

Data from these tables **should** be cached into RAM during midgard initialization. We can introduce option, which will disable this caching.


Property Aliaser
================

Property Aliaser defines mapping of full property-names (URIs) to short property-names in classes

URIs can't be used as properties in most programming languages. So, we need alias them to some shorter, alphanumeric form

*(additional restriction: GObject doesn't allow usage of underscores in names)*

Our options are:

1. API for accessing properties using full names
------------------------------------------------

    // getting using namespace-shortcut
    $old_title = $obj->getParameter('dc:title');
    
    // using full URI-name
    $obj->setParameter('http://dublincore.org/documents/dcmi-namespace/title', 'new_title');

This should be implemented any way, as:

* "last hope" measure
* a way to work with incoming RDF documents

### Q&A

> **Q:** (piotras) Can we do it explicitly and kiss?

    object.getParameter ('dc', 'title');
    object.getParameterNamespaces ('title');

> … Of course we can compute everything all over again, but we do not have time for this when website is running. Accessing properties (read/write) is *real* performance bottleneck.

> **A:** Sure, we can. I just didn't think this will affect performance that badly. Hash-lookup is usually ultra-fast. Anyway, things that you propose probably belong to "RDF Namespaces registry" section of this document.

> **comment(piotras):** It's not about hash lookup, becaue this is what is done on any bindings level. In core we have to implement property handlers from scratch. Keeping in mind stability of such implementation, reindexing properties (not db indices), prepared statements regeneration, db to property maps regeneration, etc. RDF Napmespaces registry section is highly related to properties if we want to provide common programming interface for other developers. 

2. Heuristics
-------------

Heuristics engine can check if the only parameter defined for current object ending with "title" is "dc:title", then, if user requires $obj->title then she probably means this parameter.

As any heuristics-approach, it won't work deterministically. But, if results of heuristics are stored (see #4) it might actually be useful.


3. Conversion algorithm
-----------------------

We can introduce algorithm, which will take short namespaced name of parameter (e.g. dc:title) and expose it to users as dcTitle (camelcasing) or DCtitle or in some other obscure way ;)


4. User-provided mapping
------------------------

We can introduce API, which will allow users to set specific name for parameter in the context of class.

Something like:

    MidgardStorage::setParameterAlias('HelloWorld', 'dc:title', 'title');

We can store this mapping information as additional column in many-to-many table, which connects parameters to classes (mentioned in "Schema" section of this document).

This approach can be used in conjunction with Heuristics and Conversion algorithm, overriding them.

