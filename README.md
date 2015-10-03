# elm-html-defaults

`elm-html` is pretty awesome, but the syntax is a bit noisy, and there are some good abstractions to be made. Behold!

```elm
import Html exposing (..)
doc = 
  div [] [ h1 [] [ text "Title" ]
         , p [] [ text "Body" ]
         ]
```

All those braces, all that boilerplate... Let's DRY that up a bit:

```elm
import Html as H exposing (Html, Attribute)
import Html.Defaults as D

doc =
  D.div [ D.h1' "Title"
        , D.p' "Body"
        ]
```

Much nicer!

## Html.Defaults

For each `tag` in `elm-html`, this package defines two:

* `tag : List Html -> Html`: This uses a default attribute list as defined for the tag.
* `tag' : String -> Html`: This puts a string as text in the list.

## Html.Custom

For each `tag` in `elm-html`, this module defines a default list of attributes.
This is imported by `Html.Defaults`.

# How to Use:

Make sure that [stack](https://github.com/commercialhaskell/stack) is installed.
Clone recursively to include the `elm-html` repository.

    $ git clone --recursive git@github.com:parsonsmatt/elm-html-defaults
    $ cd elm-html-defaults && stack build
    $ stack exec -- elm-html-gen --help

    Elm.Html Generator

    Usage: elm-html-gen [-i|--input INPUT] [-c|--cout COUT] [-d|--dout DOUT]

    Available options:
      -h,--help                Show this help text
      -i,--input INPUT         The input file (default ./elm-html/src/Html.elm)
      -c,--cout COUT           Output for Html.Custom (default ./Custom.elm)
      -d,--dout DOUT           Output for Html.Default (default ./Defaults.elm)

Once you have the `Custom.elm` and `Default.elm`, move them to your project and put them in `src/Html/` so Elm knows what to do with them.
