=begin

= NAME

rdswap - a multi-language RD documents support tool

= SYNOPSIS

rdswap [ -h | -v ] filename ...

= DESCRIPTION

This tool is written to support you to write multi-language documents using
the Ruby-Document-Format (RD).

The idea for such a tool was originated by Minero Aoki, how has thought
about, how to make life easier for developers who have to write and
maintain scripts in more than one language.

You have to specify at least two filenames on the command line. One
containing the Ruby script, the second containing a translated RD. If the
script does ((*not*)) end with `.rb', it has to be the first filename mentioned
on the command line! In opposition, all files containing translations 
((*must not*)) ending with `.rb'! They should use a extension that describes the
language. So that would give us the following picture:

  * sample.rb : Script contains the original documentation.
  * sample.jp : Documentation written in Japanese.
  * sample.de : Translation to German.

The tool doesn't care about the language extensions. You can name them as
you like! So the file containing the Japanese translation above, could also
be names e.g. `sample.japan' or even `japantranslation.japan'.

For every translation file, a new file will be created. The name is build
from the script filename plus the language extension. So regarding the
example above, following files would be created:

  * sample.rb.jp
  * sample.rb.de

or, given the alternative translation filename as mentioned above...

  * sample.rb.japan

== How does it work?

The contents of all files will be split into source and RD blocks. The
source of the translation files, will be discarded! Every RD block may be
of a certain type. The type will be taken from the contents directly
following the `=begin' on the same line. If there is only a lonely `=begin'
on a line by itself, the type of the block is `nil'. That means in

        # File sample.rd
        :
        =begin
         bla bla
        =end
        :
        =begin whatever or not
         blub blub
        =end
        :
   
the first block would be of type `nil' and the second one of type `whatever
or not'.
   
Block types are important for the translation. If a source will be generated
from a script and a translation file, only these blocks are taken from the
translation files, that comes in the right sequence ((*and*)) contains the same
type as the block in the script! For example:

        # File sample.rb
        :
        =begin gnark
         Some comment
        =end
        :
        =begin
         block 2
        =end
        :
        =begin
         block 3
        =end
        :

        # File sample.de
        :
        =begin
         Block zwei
        =end
        :
        =begin
         Block drei
        =end
        :

Here, the first block of `sample.rb' will *not* be translated, as there is
no translation block with that type in sample.de! So the first block would
be inserted as-it-is into the translated script. The blocks afterwards,
however, are translated as the block type does match (it is `nil' there).

Attention: In a translation file, a second block will only be used, if a
first one was already used (matched). A third block will only be used, if a
second one was used already!

That means, if the first block of `sample.de' would be of type e.g. `Never
match', then no block would ever be taken to replace anyone of `sample.rb'.

== OPTIONS

: -h
  shows this help text.
: -v
  shows some more text during processing.

: filename
  means a file, that contains RD and/or Ruby code.

== EXAMPLES

  rdswap -v sample.rb sample.ja sample.de
  rdswap -v sample.ja sample.rb sample.de
  rdswap -v sample.ja sample.de sample.rb
  rdswap -v sample.??

== AUTHORS

Clemens Hintze <c.hintze@gmx.net>.

=end
