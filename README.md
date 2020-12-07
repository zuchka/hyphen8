# Hyphen8

## Introduction

Hyphen8 is a pure Elixir implementation of the Knuth-Liang Hyphenation Algorithm. It was the basis of Franklin Mark Liang's [1983 Dissertation, _WORD HY-PHEN-A-TION BY COM-PU-TER_](http://www.tug.org/docs/liang/liang-thesis.pdf). It remains the standard hyphenation method in TeX.

## History of the Knuth-Liang Algorithm

Liang built a program, Patgen, which developed his method. He says the following about the resulting algorithm:

> "The new hyphenation algorithm is based on the idea of hyphenating and inhibiting patterns. These are simply strings of letters that, when they match hi a word, give us information about hyphenation at some point in the pattern. For example, '-tion' and *c-c' are good hyphenating patterns. An important feature of this method is that a suitable set of patterns can be extracted automatically from the dictionary.

>"...The resulting hyphenation algorithm uses about 4500 patterns...These patterns find 89% of the hyphens in a pocket dictionary word list, with essentially no error."

In the [official resource for Patgen](https://www.tug.org/texlive/devsrc/Build/source/texk/web2c/patgen.web), we find a very clear definition of the algorithm's logic:

>"The patterns consist of strings of letters and digits, where a digit indicates a `hyphenation value` for some intercharacter position.  For example, the pattern `\.{3t2ion}` specifies that if the string `\.{tion}` occurs in a word, we should assign a hyphenation value of `3` to the position immediately before the `\.{t}`, and a value of `2` to the position between the `\.{t}` and the `\.{i}`.

>"...To hyphenate a word, we find all patterns that match within the word and determine the hyphenation values for each intercharacter position.  If more than one pattern applies to a given position, we take the maximum of the values specified (i.e., the higher value takes priority).  If the resulting hyphenation value is odd, this position is a feasible breakpoint; if the value is even or if no value has been specified, we are not allowed to break at this position.

Hyphen8 uses Liang's original tables. There is a lot of room for optimization. 

To view a very large sample output, [view this hyphenated version of Moby-Dick](https://github.com/zuchka/hyphen8/blob/main/moby-dick-hyphenated.txt). The input was [the unabridged, UTF-8 copy on Project Gutenberg](http://www.gutenberg.org/files/2701/2701-0.txt).

## Additional Resources

- [Links page for Patgen-related content](https://www.tug.org/docs/liang/)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `hyphen8` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hyphen8, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/hyphen8](https://hexdocs.pm/hyphen8).

