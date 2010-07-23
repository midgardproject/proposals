Fundamentals
============

What is the main approach and big picture of this spec?
-------------------------------------------------------
* Are we going to create new project - Midgard TripleStore?

> (indeyets) Yes

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

* Which part of Midgard has to be untouched and which one has to be rewritten from scratch? (basically it is somehow related to bacwakrd compatibility)

> (indeyets) Backwards compatibility should be ignored. We want to keep as much code as possible, but API part should change drastically.


If, we are going to continue Midgard Content Repository:
--------------------------------------------------------

* Do we need to build ontologies for everything which is not efficient for content repository?

> (indeyets) I don't see how it is "not efficient". I believe overhead will be close to zero. SQL queries are still the slowest part. We will have some hash-lookups in addition to those and hash-lookups are instant O(1)


Is this a spec for next Midgard generation or for next Midgard release?
-----------------------------------------------------------------------

> (indeyets) next Midgard generation. That's why it is "Midgard 3", not "Midgard 2.1"
