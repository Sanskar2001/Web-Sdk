open RecoilAtoms
open PaymentType
open Utils

@react.component
let make = (~paymentType, ~customFieldName=None) => {
  let {localeString} = Recoil.useRecoilValueFromAtom(configAtom)
  let {fields} = Recoil.useRecoilValueFromAtom(optionAtom)
  let loggerState = Recoil.useRecoilValueFromAtom(loggerAtom)

  let (billingName, setBillingName) = Recoil.useLoggedRecoilState(
    userBillingName,
    "billingName",
    loggerState,
  )

  let showDetails = getShowDetails(~billingDetails=fields.billingDetails, ~logger=loggerState)

  let changeName = ev => {
    let val: string = ReactEvent.Form.target(ev)["value"]
    setBillingName(.prev => {
      ...prev,
      value: val,
      errorString: "",
    })
  }
  let (placeholder, fieldName) = switch customFieldName {
  | Some(val) => (val, val)
  | None => (localeString.billingNamePlaceholder, localeString.billingNameLabel)
  }
  let nameRef = React.useRef(Js.Nullable.null)

  let submitCallback = React.useCallback1((ev: Window.event) => {
    let json = ev.data->Js.Json.parseExn
    let confirm = json->getDictFromJson->ConfirmType.itemToObjMapper
    if confirm.doSubmit {
      if billingName.value == "" {
        setBillingName(.prev => {
          ...prev,
          errorString: `Please provide your ${fieldName}`,
        })
      }
    }
  }, [billingName])
  submitPaymentData(submitCallback)

  <RenderIf condition={showDetails.name == Auto}>
    <PaymentField
      fieldName
      value=billingName
      onChange=changeName
      paymentType
      type_="text"
      name=TestUtils.cardHolderNameInputTestId
      inputRef=nameRef
      placeholder
    />
  </RenderIf>
}
