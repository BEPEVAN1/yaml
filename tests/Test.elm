module Test exposing (main)

import Parser
import Yaml.Parser as Yaml
import Html


{- 

TODO:
  - Numbers starting with 0
  - Why does eee not parse? "ExpectingNumber"
  - Check that sub list has larger indent than parent
-}

main : Html.Html msg 
main =
  case Parser.run Yaml.parser testDocumentBegin of 
    Ok value -> yamlValueToHtml value
    Err error -> Html.text (String.join ", " (List.map errorToString error))


testDocumentBegin : String
testDocumentBegin =
  """

--- trash

- aaa
-     
  - bbb
  -
    - ccc
    - ddd
    - _eee
    - fff
  - ggg
- hhh
"""


errorToString : Parser.DeadEnd -> String
errorToString deadEnd =
  case deadEnd.problem of
    Parser.Expecting string ->
      "Expecting: " ++ string
    
    Parser.ExpectingInt ->
      "Expecting: Int"
    
    Parser.ExpectingHex ->
      "Expecting: Hex"
    
    Parser.ExpectingOctal ->
      "Expecting: Octal"
    
    Parser.ExpectingBinary ->
      "Expecting: Binary"
    
    Parser.ExpectingFloat ->
      "Expecting: Float"
    
    Parser.ExpectingNumber ->
      "Expecting: Number"
    
    Parser.ExpectingVariable ->
      "Expecting: Variable"
    
    Parser.ExpectingSymbol symbol ->
      "Expecting: Symbol " ++ symbol
    
    Parser.ExpectingKeyword keyword ->
      "Expecting: Keyword " ++ keyword
    
    Parser.ExpectingEnd ->
      "Expecting: End"
    
    Parser.UnexpectedChar ->
      "Expecting: Char"
    
    Parser.Problem problem ->
      "Expecting: " ++ problem
    
    Parser.BadRepeat ->
      "BadRepeat"



-- HELPERS


yamlValueToHtml : Yaml.Value -> Html.Html msg
yamlValueToHtml value =
  Html.text (yamlValueToString value)


yamlValueToString : Yaml.Value -> String
yamlValueToString value =
  case value of
    Yaml.String_ string ->
      string 
    
    Yaml.Float_ float ->
      String.fromFloat float ++ " (float)"
    
    Yaml.Int_ int ->
      String.fromInt int ++ " (int)"
    
    Yaml.List_ list ->
      "[ " ++ String.join ", " (List.map yamlValueToString list) ++ " ]"
    
    Yaml.Record_ properties ->
      "{ " ++ String.join ", " (List.map yamlPropertyToString properties) ++ " }"
    
    Yaml.Null_ ->
      "Null"


yamlPropertyToString : Yaml.Property -> String
yamlPropertyToString {name, value} =
  name ++ ": " ++ yamlValueToString value
