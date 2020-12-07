# Hyphen8

## Introduction

Hyphen8 is a pure Elixir implementation of the Knuth-Liang Hyphenation Algorithm. That algorithm formed the basis of Franklin Mark Liang's [1983 Stanford Dissertation, _WORD HY-PHEN-A-TION BY COM-PU-TER_](http://www.tug.org/docs/liang/liang-thesis.pdf). It remains the standard hyphenation method in TeX.

## Usage

Pass a string to `Hyphen8.Engine.main()`:

```command
iex> Hyphen8.Engine.main("let's hyphenate containerization orchestration platform")
```

You will receive the hyphenated string:

```
"let s hy-phen-ate con-tainer-iza-tion or-ches-tra-tion plat-form"
```

The current version will not reconstruct punctuation. To customize the string and word splitting, adjust the regular expressions in `Hyphen8.Engine.parse_words()` and `Hyphen8.Engine.parse_characters()`.

## History of the Knuth-Liang Algorithm

Liang built a program, Patgen, which developed a large pattern table. He says the following about the resulting algorithm:

> "The new hyphenation algorithm is based on the idea of hyphenating and inhibiting patterns. These are simply strings of letters that, when they match a word, give us information about hyphenation at some point in the pattern. For example, '-tion' and *c-c' are good hyphenating patterns. An important feature of this method is that a suitable set of patterns can be extracted automatically from the dictionary.

>"...The resulting hyphenation algorithm uses about 4500 patterns...These patterns find 89% of the hyphens in a pocket dictionary word list, with essentially no error."

In the [official resource for Patgen](https://www.tug.org/texlive/devsrc/Build/source/texk/web2c/patgen.web), we find a clear description of the algorithm's logic:

>"The patterns consist of strings of letters and digits, where a digit indicates a `hyphenation value` for some intercharacter position.  For example, the pattern `\.{3t2ion}` specifies that if the string `\.{tion}` occurs in a word, we should assign a hyphenation value of `3` to the position immediately before the `\.{t}`, and a value of `2` to the position between the `\.{t}` and the `\.{i}`.

>"...To hyphenate a word, we find all patterns that match within the word and determine the hyphenation values for each intercharacter position.  If more than one pattern applies to a given position, we take the maximum of the values specified (i.e., the higher value takes priority).  If the resulting hyphenation value is odd, this position is a feasible breakpoint; if the value is even or if no value has been specified, we are not allowed to break at this position.

Hyphen8 uses Liang's original tables. There is a lot of room for optimization in this Elixir port, but the basic implementation is there.

There is a large sample output in this repo. [View this hyphenated version of _Moby-Dick_](https://github.com/zuchka/hyphen8/blob/main/moby-dick-hyphenated.txt). The input was [the unabridged, UTF-8 copy of _Moby Dick_ on Project Gutenberg](http://www.gutenberg.org/files/2701/2701-0.txt). This file is Hyphen8's raw output.

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
