Introduction
============

We believe, that future of web belongs to Semantic Data. We want Midgard to become a full-fledged citizen of this world.

In Midgard2 world data is represented as a set of interconnected objects.

In "Semantic world" data is a directed graph of nodes.


We can represent any Midgard2 object as a small graph consisting of identity-node and it's direct successors (which would represent properties). Then these small graphs can be combined in larger graph, which will represent whole data-set.

Midgard's objects are based on primitive ontologies. As part of mgdschema we define data-types and relationships, but we do not define _meaning_ of fields. This way, our data is usable for our applications, but other applications won't be able to do much without explicit interpretation by operator.

At the same time, Midgard2 can not store arbitrary incoming semantic data without losing part of the information. Midgard2 has fixed data-schema, while semantic data coming from external sources might have some unexpected metadata.


So, we have the following challenges for Midgard3:

* Store arbitrary semantic data coming from external sources
* Export data-storage contents as a standards-compliant semantic graph
* Be compatible with semantic-data querying tools (implement SparQL support)


During the Tampere gathering in June 2010 we decided to do the following:

A. Core
=======

1. Switch from mgdschema to RDF-schema compatible ontologies.
-------------------------------------------------------------

Internal representation of ontologies in Midgard3 will be stored in pre-parsed way in database, and we will need to provide tools to import/export standard [RDF-Schema](http://en.wikipedia.org/wiki/RDF_Schema) and/or [OWL](http://en.wikipedia.org/wiki/Web_Ontology_Language) representations such as [Manchester Syntax](http://www.w3.org/2007/OWL/wiki/ManchesterSyntax) and RDF/[Turtle](http://en.wikipedia.org/wiki/Turtle_(syntax)).

Strictly speaking, we don't need to support the whole RDF-Schema or OWL on the core-level from the start. We need to support some basic subset, which will define relationships between objects.

Definitions of basic data-types and basic relationships can be implicitly provided by the system:

* RDF, RDFs, XSD
* [Dublin Core](http://dcmi.kc.tsukuba.ac.jp/dcregistry/navigateServlet) (instead of current midgard_metadata)
* [FOAF](http://xmlns.com/foaf/spec/)
* ontologies supported by [Google's Rich Snippets](http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=99170) (to work the SEO angle of why semantics are useful)

Support for importing-exporting full schemas should be implemented on application-level

### 1.1. Some RDF Schema examples:

Schema #1:

    =============================================
    @base <http://example.org/schemas/library>

    :Book           a               rdfs:Class.

    :colour         a               rdf:Property;
                    rdfs:domain     :Book.

    dc:title        rdfs:domain     :Book.

    dc:author       rdfs:domain     :Book.

    :EBook          a               rdfs:Class;
                    rdfs:subClassOf :Book.

    foaf:homepage   rdfs:domain     :EBook.
    =============================================

Should be converted to the following classes:

    =============================================
    class Book
    {
        var $colour; // custom property
        var $title;  // dublin core title
        var $author; // dublin core author
    }

    class EBook extents Book
    {
        var $homepage; // FOAF homepage
    }
    =============================================


Schema #2:

    =============================================
    @base <http://example.org/schemas/math>

    :Real           a               rdfs:Class.

    :Imaginary      a               rdfs:Class.

    :integral       a               rdf:Property;
                    rdfs:range      xsd:integer;
                    rdfs:domain     :Real;
                    rdfs:domain     :Imaginary.

    :fractional     a               rdf:Property;
                    rdfs:range      xsd:integer;
                    rdfs:domain     :Real;
                    rdfs:domain     :Imaginary.

    :Complex        a               rdfs:Class.

    :real           a               rdf:Property;
                    rdfs:range      :Real;
                    rdfs:domain     :Complex.

    :imaginary      a               rdf:Property;
                    rdfs:range      :Imaginary;
                    rdfs:domain     :Complex.
    =============================================

Should be converted to the following classes:

    =============================================
    class Real
    {
        var $integral; // int
        var $fractional; // int
    }

    class Imaginary
    {
        var $integral; // int
        var $fractional; // int
    }

    class Complex
    {
        var $real; // object of Real class
        var $imaginary; // object of Imaginary class
    }
    =============================================


### 1.2. Additional notes on RDF Namespaces.

(almost) everything in RDF is namespaced. this can be a problem, because we can't use URIs as Class-names or Property-names.

Which means: we need support for aliasing rdf-names to programming language compatible names.

For classes we can reuse rdf's namespacing mechanism. So, we define, that: "math" namespace corresponds to "<http://example.org/schemas/math>" prefix.

and classes are named as: 'math.Complex' in python and 'math\Complex' in php

(we can additionally prefix it with "midgard.schema" as was proposed in earlier mRFC on namespaces)

There is also limitation in current GIR design, which might complicate such namespacing: https://bugzilla.gnome.org/show_bug.cgi?id=576327

But the last comment on this bug sounds like a possible solution


For object-properties we don't have namespacing facilities in most of the languages. So, we have 4 options:

* use heuristics, which means:

    If the object has "dc:title" property and there are no other "*:title" properties, let user access it with "title" shortcut

* use user-provided mapping table

        "dc:title" = dc_title,
        "library:title" = title

* define rules for automatic conversion (camelcasing, for example)

        "dc:title" = dcTitle,
        "library:title" = libraryTitle 

* provide api for accessing properties using their full names.

        $old_title = $obj->getParameter('dc:title');
        $obj->setParameter('http://dublincore.org/documents/dcmi-namespace/title', 'new title');]

Probably we should support several ways at the same time.

In "[Hormiga](http://blogs.gnome.org/abustany/2010/07/05/hormiga-quick-followup/)" project they use a "user-provided mapping table" approach. They have a "mapping file" where you make the connection between namespaced properties and unnamespaced properties. But obviously this would be quite a burden to maintain alongside the actual ontology, if that is the only option.

    {
        "Class": "nmm:Photo",
        "Name": "Photo",
        "Properties": [
            {
                "Property": "dc:title",
                "Name": "title"
            },

            {
                "Property": "nao:hasTag",
                "Range": "nao:Tag",
                "Name": "tags"
            }
        ]
    }


The important thing is that on core level we need a clear API for defining and modifying schemas. Importing schema definitions from various semantic ontology formats can then be handled on application level.


2. RDF Schemas won't be used as direct rules to create database tables.
-----------------------------------------------------------------------

Instead, classical Midgard Parameter facilities will be "tuned" in such way, that there won't be any difference from API point of view between accessing field of table or parameter from external table. This way, we will be able to add arbitrary semantic relations to any object. If there is a field in the table for this relationship, then it will be stored there. Otherwise, relationship will be transparently stored in parameters-table. 


3. Additional API for controlling mapping of fields to actual db-tables will be implemented.
--------------------------------------------------------------------------------------------

It should include means for:

* moving field from "parameters" to table and from table to "parameters" (implying transaction-safe moving of actual data stored)
* creating/removing indices on table-columns.


4. "Query Analyzer" component should be implemented.
----------------------------------------------------

It will gather statistics on data-access patterns and give suggestions on proper data-storage strategies (storing values in parameters or in table, creating indices). 

5. SPARQL queries interface should be implemented in addition to MidgardQuery facilities, which were implemented in Midgard2.
-----------------------------------------------------------------------------------------------------------------------------

Current plan is to reuse SPARQL-parser from GNOME's Tracker project.

As an alternative approach, Alexander Bokovoy proposed that we could utilize Tracker for the whole SPARQL processing. In this setup we'd run Tracker alongside Midgard, using it with an in-memory SQLite database. When started, Midgard would export all triples to Tracker, and handle SPARQL there.


B. Midgard CMS
==============

1. Midgard's CMS user interface must support creating semantically enhanced information
---------------------------------------------------------------------------------------

Primary content format handled with Midgard CMS is HTML5. With HTML5 you can include semantic information into the mark-up using RDFa. The IKS project is working on a [semantic rich text editor](http://wiki.iks-project.eu/index.php/Semantic_Editor) that we will be able to use as the content editing interface. When content is stored Midgard should analyze the RDFa content and store it to corresponding Midgard store.

RDFa will also be used for marking up content displayed via templates in Midgard CMS. The RDFa information can be used by the editing interface to determine where edited content ought to be stored and how.


2. Midgard CMS must be able to connect to semantic engines that can enrich content
-------------------------------------------------------------------------------------------------------------------------------------------------------------------

The IKS project supplies [FISE](http://fise.demo.nuxeo.com/), a semantic engine that can accept raw textual content, recognize entities (companies, places, etc) in it and return corresponding RDF.
