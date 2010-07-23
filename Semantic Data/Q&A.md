Fundamentals
============

What is the main approach and big picture of this spec?
-------------------------------------------------------
* Are we going to create new project - Midgard TripleStore?

> (indeyets) Yes

> (bergie) To some extent. The immediate goal is to make data storage in Midgard more extensible, and to possibly support SparQL as a new query method besides the more traditional MidgardQuery* methods. Midgard however steps outside traditional triplestore boundaries with features like Workspaces.

* Are we going to replace Midgard Content Repository with Midgard TripleStore?

> (indeyets) Yes and No. We are creating RDF-compatible Content Repository.


If, we are going to create Midgard TripleStore:
-----------------------------------------------

* Do we need to build this on top of GDA, instead of other library?

> (indeyets) In my opinion, Yes. We can reuse a) their work b) some midgard2 code

* Is GDA proper library to build TripleStore on top of it?

> (indeyets) It is not a proper library for usual TripleStore. But it should be just fine for us. We are still going to have objects and properties. And we want to work on top of generally available databases.


* Do we want to compete with Tracker?

> (indeyets) To some degree. At first we will provide solutions for different segments of the market. Later, probably, we will be able to provide alternative backend for Tracker.

> (bergie) Tracker and Midgard have slightly different targets. Tracker wants to be an efficient triplestore for constrained devices like mobile phones, mostly aiming management of "desktop-like" data using the Nepomuk ontologies. Midgard aims to bridge desktop-scale and web-scale with a generic content repository that can manage things like business information. RDF triples are just a way to achieve this goal. Additionally, Midgard is usually multi-user while Tracker is usually single-user.

* Which part of Midgard has to be untouched and which one has to be rewritten from scratch? (basically it is somehow related to bacwakrd compatibility)

> (indeyets) Backwards compatibility should be ignored. We want to keep as much code as possible, but API part should change drastically.

> (bergie) We should aim to retain some of the good concepts in Midgard. Replication and Workspaces are such examples. But APIs will be a bit different anyway as we're building them on top of GObject Introspection instead of "handcrafted per-language APIs"

If, we are going to continue Midgard Content Repository:
--------------------------------------------------------

* Do we need to build ontologies for everything which is not efficient for content repository?

> (indeyets) I don't see how it is "not efficient". I believe overhead will be close to zero. SQL queries are still the slowest part. We will have some hash-lookups in addition to those and hash-lookups are instant O(1)

> (bergie) in Midgard1 and Midgard2 we already build ontologies for everything. MgdSchema is an ontology format, though a quite limited one.

Is this a spec for next Midgard generation or for next Midgard release?
-----------------------------------------------------------------------

> (indeyets) next Midgard generation. That's why it is "Midgard 3", not "Midgard 2.1"
