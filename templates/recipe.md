Creating a New Recipe
---------------------

*(Optional) Credit: Your Name*

### Problem

You want to know how to add a new recipe to the *REDHAWK Cookbook*.

### Solution

Creating a new recipe requires that you have cloned the *REDHAWK
Cookbook* source code. The source code is available on
[GitHub](http://www.github.com/Axios-Enginering/redhawk-cookbook) and
can be accessed via the `git` tool:

    $ git clone http://www.github.com/Axios-Enginering/redhawk-cookbook.git
    $ cd redhawk-cookbook

Clearly the first step is to create a title for your recipe. This should
be a short description of what the reader will accomplish. In general,
the title should start with a
[gerund](http://en.wikipedia.org/wiki/Gerund).

To start your recipe, determine what chapter is most appropriate for it.
Each chapter is a folder within the source code folder.

    $ ls
    00-preface
    01-installing-and-running
    02-the-redhawk-development-tools
    ...

If none of the chapters seem appropriate, use `misc` chapter. The
easiest way to start is to copy the provided template into the
appropriate chapter folder. The file name for your recipe should be
based off the title of your recipe, but in all lower case without white
space. For example, if the recipe title was "Creating a New Recipe" the
file name would be `creating_a_new_recipe.md`.

    $ cp templates/recipe.md <chapter>/<short_recipe_title>.md

Using your favorite Markdown editor, write your recipe.

Once you are happy with your recipe, you can commit it.

    $ git commit add <chapter>/<short_recipe_title>.md
    $ git commit -m "Adding a new recipe"

Then create a git patch and email it to
<redhawk-cookbook@axiosengineering.com>

    $ git format-patch HEAD^

### Discussion

The *REDHAWK Cookbook* provides a concise source of concrete solutions
that will help REDHAWK users be effective developers. Like REDHAWK
itself, the REDHAWK cookbook is an open-source,document that uses github
to support collaboration.

The folder and file naming conventions help organize the book and allow
for multiple developers to collaborate without causing too many
merge-conflicts.

Markdown syntax is used because it is easy to edit and can be converted
to produce high-quality HTML or PDFs.

All recipes contributed to the *REDHAWK Cookbook* must be provided under
the Creative Commons Attribution-Share Alike 3.0 license.

### See Also

-   [Pro Git](http://git-scm.com/book) for information about using Git
-   [Markdown Syntax](http://daringfireball.net/projects/markdown/) for
    information about the Markdown syntax

