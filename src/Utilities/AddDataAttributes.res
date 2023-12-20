let spreadProps = React.cloneElement

@react.component
let make = (~attributes: array<(string, string)>, ~children) => {
  let attributesDict = attributes->Js.Dict.fromArray

  children->spreadProps(attributesDict)
}
