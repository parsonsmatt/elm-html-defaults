{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Data.Text as T
import Turtle
import Prelude hiding (FilePath)

main :: IO ()
main = do
  (pathToElm, custOutput, defOutput) <- options "Elm.Html Generator" parser
  sh $ do
    output defOutput (pure defaultsHeader)
    output custOutput (pure customHeader)
    tagLines <- grep (suffix  " : List Attribute -> List Html -> Html")
                    (input pathToElm)
    let tags = T.unlines 
             $ filter (\c -> T.strip c /= "" 
                          && not ("map" `T.isInfixOf` c) 
                          && not ("area" `T.isInfixOf` c))
             $ map (head . cut " ") (T.lines tagLines)
    append (defOutput) (pure (getDefinitions tags))
    append (custOutput) (pure (getAttributeDefinitions tags))


parser :: Parser (FilePath, FilePath, FilePath)
parser = (,,) <$> (optPath "input" 'i' "The input file (default ./elm-html/src/Html.elm)"
                   <|> pure "./elm-html/src/Html.elm")
              <*> (optPath "cout" 'c' "Output for Html.Custom (default ./Custom.elm)"
                   <|> pure "./Custom.elm")
              <*> (optPath "dout" 'd' "Output for Html.Default (default ./Defaults.elm)"
                   <|> pure "./Defaults.elm")
  
defaultsHeader :: Text
defaultsHeader =
  "module Html.Defaults where\n\n" <> elmImports <> "import Html.Custom as C\n\n"

customHeader :: Text
customHeader =
  "module Html.Custom where\n\n" <> elmImports <> "\n\n"

elmImports :: Text
elmImports = T.unlines $
  ("import " <>) <$> [ "Html as H exposing (Html, Attribute)"
                     , "Html.Events as E"
                     , "Html.Attributes as A"
                     ]

getDefinitions :: Text -> Text
getDefinitions = T.unlines . map expand . T.lines
  where
  expand fn = T.unlines [ fn <> " : List Html -> Html"
                        , fn <> " = H." <> fn <> " C." <> fn <> "Attributes"
                        , ""
                        , fn <> "' : String -> Html"
                        , fn <> "' s = " <> fn <> " [H.text s]"
                        ]

getAttributeDefinitions :: Text -> Text
getAttributeDefinitions = T.unlines . map expand . T.lines
  where
    expand fn = T.unlines [ fn <> "Attributes : List Attribute"
                          , fn <> "Attributes = []"
                          ]
