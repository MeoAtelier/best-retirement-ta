# New Zealand's best retirement area.

The analysis and data are described in `analysis/main.Rmd`

## Quickstart (Linux and OS X)

If you have [Nix](https://nixos.org/nix/) and [PostgreSQL](http://postgresql.org/) installed run:

    nix-shell --run make

## Analysis and data preparation tool

- Gnumake
- PostgreSQL
- R + tidyverse
- Haskell

## Interactive

The source code for the interactive at http://insights.nzherald.co.nz/article/best-retirement-area
is in the `interactive` directory. It is a React app

All the data for the app have been committed so you should be able to run

    yarn start

in `interactive`

