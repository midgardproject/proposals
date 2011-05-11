Midgard JCR mappings
====================

Midgard and JCR are both content repositories, but they have some conceptual differences. This document outlines how Midgard's data model may be mapped to JCR usage.

For now the primary consumer of these mappings is PHP Content Repository (PHPCR), a PHP implementation of the JCR specification.

## Tree basics

In JCR all content is available as a single tree, while Midgard allows greater flexibility in this aspect.

### Main node type

In Midgard2 to enable a single main tree, we will add a new `midgard_node` type to Midgard's core MgdSchemas. All developers are encouraged to use this type as a parent of their own main types.

In Midgard1 we can use either `midgard_page` or `midgard_topic` for this purpose.

The main node type can map to `nt:folder`.

### Unstructured content

It is very common in JCR implementations to use the `nt:unstructured` node type for basic content:

> The JCR node type nt:unstructured is designed to accept any properties, so you can dump at will strings, dates or even binaries into such a node. This node type is very useful to get started with coding an application when you do not know what the end result should look like.

We need a MgdSchema type that can be a child of objects of any other type that maps to `nt:unstructured`.

### Unfiled content

Types that do not map into the main tree can be accessed via path `/jcr:system/jcr:unfiled/<guid>`.

This matches JCR specification 3.12: 

> The hierarchical structure below /jcr:system/jcr:unfiled is implementation-dependent. JCR implementers may disallow discovery (listing) of the nodes beneath this folder. In such a case a call to Node.getNodes() on the jcr:unfiled node would throw a RepositoryException

Types that are mappable to the main tree may not be available through `jcr:unfiled`.

## Node types

All MgdSchema types inherit from an abstract "mgd:object" type.

By default MgdSchemas are visible as NodeTypes named with "mgd:<schema name>"

### Properties

Normal properties of MgdSchema types are available without namespace (i.e. MgdSchema `title` property is a JCR "title property).

Namespaced additional properties are stored into parameters with namespace URL being the parameter domain.

Unnamespaced properties that are not available in a MgdSchema type, when saved to a `nt:unstructured` node are saved as parameters under `phpcr:undefined` domain.

Storing unnamespaced properties that are not available in a MgdSchema type other than `nt:unstructured` cause an exception.