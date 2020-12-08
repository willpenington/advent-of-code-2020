Advent Of Code 2020
============

Solutions to [Advent of Code 2020](https://adventofcode.com/2020/) in Elixir

## Getting Started

To run the code in this repo you will need the Erlang and Elixir runtimes 
installed. Visit https://elixir-lang.org/install.html for platform specific
instructions.

The main solutions are in the `lib` directory with a file for each day. There are
tests covering some days in the test directory.  The module for each day contains 
a method called `process()` that will load the input, calculate the anwser and 
print it to the terminal. Elixir's default build system (Mix) can be used to run
these methods using the command

`mix run -e "AdventOfCode.Day08.process()"`

(with the appropriate day number)

Input files are stored in the  `priv` directory, with a directory for each day 
containing a text file called input in the format`priv/dayNN/input` (where `NN` 
is the day number, padded with a zero if necessary). All of the file and path
logic is encapsulated in the `AdventOfCode.Util` module.

## Tests
Unit tests are implemented using [ExUnit](https://hexdocs.pm/ex_unit/ExUnit.html),
Elixir's main testing framework. See the documentation for details on the 
structure.

Some functions with documentation have examples prefixed with the prompt `iex>`.
These are [Doctests](https://elixir-lang.org/getting-started/mix-otp/docs-tests-and-with.html#doctests)
and they are treated as part of the unit tests by ExUnit, so some functions may
not have "proper" tests if they would just be duplicates.

## Documentation
The level of documentation varies by day, but the documentation that exists can
be parsed by [ExDoc](https://github.com/elixir-lang/ex_doc) to produce user 
friendly HTML (and ePub). 

To generate the documentation run the following commands:
  - `mix deps.get` to download ExDoc. This may prompt you to install Hex, Elixir's package manager, type `y` if prompted.
  - `mix deps.compile` to build ExDoc
  - `mix docs` to run ExDoc and generate the HTML

The documentation should then appear in the `doc` folder. Open `doc/index.html` in
a browser to view it.

## Type Checking
Some modules have [typespec](https://hexdocs.pm/elixir/typespecs.html) annotations
that indicate what functions expect and return. The types can be analyzed by
(Dialixir)[https://hexdocs.pm/dialyxir/readme.html], an Elixir library for the
Erlang tool Dialyzer.

To install Dialixier run `mix deps.get` and `mix deps.compile` if you haven't for 
ExDoc and to run a type check run `mix dialyzer`. The first time you run it will
be very slow as it generates a large amount of cached data.


