Midgard Project visual guidelines
=================================

As part of the [Midgard Project](https://github.com/midgardproject/org_midgardproject_projectsite) website renewal, we're getting new visual guidelines for the project. This file seeks to document them.

## Focus on simplicity

Visuals with in Midgard projects should focus on simplicity and clarity. If you can display something reasonably on a plain white or black background, do so. Also try to avoid unnecessary borders and effects, instead using necessary space and large, readable font sizes.

## Logos

The logos used in this document have been designed by [Andreas Nilsson](http://www.andreasn.se/).

By default the logos of the Midgard Project and its products are used in black-and-white versions. On light backgrounds, the black ones should be used, and on dark backgrounds the white ones.

* [Black logos (SVG)](https://github.com/midgardproject/proposals/raw/master/Visual%20Guidelines/midgard_black.svg)
* [White logos (SVG)](https://github.com/midgardproject/proposals/raw/master/Visual%20Guidelines/midgard_white.svg)

There are also colored versions using the "old" Midgard colors of yellow and brown that may be used in contexts where more color is needed.

* [Colorful logos (SVG)](https://github.com/midgardproject/proposals/raw/master/Visual%20Guidelines/midgard_colors.svg)

### Project logo

![The Midgard Project](https://github.com/midgardproject/proposals/raw/master/Visual%20Guidelines/midgard_black.png)

The logo of The Midgard Project is a simplified version of the [logo we've used for Midgard CMS](http://en.wikipedia.org/wiki/File:Midgard_logo.png) since the Ragnaroek days.

### Product logos

Each product of the Midgard Project will have its own logo, modeled on the original logo of the project itself.

![Product logos](https://github.com/midgardproject/proposals/raw/master/Visual%20Guidelines/midgard_products_black.png)

From left to right: Midgard Create, Midgard MVC, Midgard Daemon, Midgard Content Repository.

## Fonts

For product names and headlines on Midgard-branded materials, the [Cantarell](http://abattis.org/cantarell/) font is used. Cantarell is available under the [Open Font License](http://scripts.sil.org/OFL) from [GNOME git repository](http://git.gnome.org/browse/cantarell-fonts/plain/ttf).

Cantarell can be used on web pages via the Google Web Fonts service. To use it, add the following to your page:

    <link href="http://fonts.googleapis.com/css?family=Cantarell" rel="stylesheet" type="text/css" />

## Colors

Midgard follows the [Tango color guidelines](http://tango.freedesktop.org/Tango_Icon_Theme_Guidelines). Most information should be displayed on a greyscale palette, but colors can be used for highlighting relevant information.

The preferred highlight color is green (`#4e9a06`).

### Gradients

Some Midgard materials display the product names and logos on top of a large area with a slight gradient. If you need to recreate this, the gradient goes from `#343c3d` to `#1b1f20`, top to bottom.

CSS3 implementation of this gradient:

    header {
        padding: 1em;
        background-color: #343c3d;
        background: -webkit-linear-gradient(#343c3d, #1b1f20);
        background: -moz-linear-gradient(100% 100% 90deg, #343c3d, #1b1f20);
    }

### Notice color

If there is a notice that the user must specifically see (for example, an error message), a good practice is to show it on a orange background. Use color `#fcaf3e` for this.
