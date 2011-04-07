MgdSchema RDF Mappings
======================

As Midgard1 and Midgard2 content repositories use [MgdSchema files](http://www.midgard-project.org/documentation/mgdschema-file/) instead of RDF ontologies for their content definitions, some mappings are needed for making their contents accessible via RDF.

## Default namespace

The default namespace for MgdSchemas is `http://www.midgard-project.org/repligard/1.4`, with default alias of `mgd`.

The default namespace can be used for mapping every MgdSchema type or property into RDF.

## Entity identifiers

Entities in Midgard are identified by their [GUIDs](http://www.midgard-project.org/development/mrfc/0018/). These are mapped to RDF using ´UUID´ [CURIEs](http://www.w3.org/TR/2007/WD-curie-20070307/):

* `urn:uuid:d5623172553311e0a48f5ba4eebd0cc10cc1` maps to Midgard GUID `d5623172553311e0a48f5ba4eebd0cc10cc1`

Examples:

* `mgd:midgard_person` maps to the `midgard_person` MgdSchema type
* `mgd:firstname` maps to the `firstname` property of an MgdSchema type

## Mapping with other ontologies

MgdSchemas can also contain mappings to other ontologies. These can be used as an alternate RDF representation of the MgdSchema ontology used, so basically the relation between them and MgdSchema types and properties is `owl:sameAs`.

### Declaring namespace aliases

When mapping MgdSchemas to other ontologies, the namespace mappings should be provided in the `user_data` part of the type definition.

The namespace aliases are provided as a comma-separated string, with alias and URL separated by a colon.

Example:

    <type name="...">
        <user_values>
            <namespaces>foaf:http://xmlns.com/foaf/0.1/,doap:http://usefulinc.com/ns/doap#</namespaces>
        </user_values>
        ...
    </type>

### Type mapping

MgdSchema types can be mapped to other ontologies using the `user_data` part of the type definition.

    <type name="...">
        <user_values>
            <namespaces>...</namespaces>
            <typeof>foaf:Group</typeof>
        </user_values>
        ...
    </type>

### Property mapping

MgdSchema type properties can be mapped to other ontologies by adding a `property` element inside the property. Example:

    <type name="...">
        <property name="abstract" type="text">
            <property>doap:shortdesc</property>
        </property>
    </type>
