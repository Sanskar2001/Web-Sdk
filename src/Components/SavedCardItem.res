@react.component
let make = (
  ~setPaymentToken,
  ~isActive,
  ~paymentItem: PaymentType.customerMethods,
  ~brandIcon,
  ~index,
  ~savedCardlength,
  ~cvcProps,
  ~paymentType,
  ~list,
) => {
  let {themeObj, config} = Recoil.useRecoilValueFromAtom(RecoilAtoms.configAtom)
  let (cardBrand, setCardBrand) = Recoil.useRecoilState(RecoilAtoms.cardBrand)
  let (
    isCVCValid,
    setIsCVCValid,
    cvcNumber,
    _,
    changeCVCNumber,
    handleCVCBlur,
    _,
    _,
    cvcError,
    _,
  ) = cvcProps
  let cvcRef = React.useRef(Js.Nullable.null)
  let (pickerItemClass, pickerItemLabelClass, pickerItemIconClass) = React.useMemo1(() => {
    isActive
      ? ("PickerItem--selected", "PickerItemLabel--selected", "PickerItemIcon--selected")
      : ("", "", "")
  }, [isActive])
  let focusCVC = () => {
    setCardBrand(._ =>
      switch paymentItem.card.scheme {
      | Some(val) => val
      | None => ""
      }
    )
    let optionalRef = cvcRef.current->Js.Nullable.toOption
    switch optionalRef {
    | Some(_) => optionalRef->Belt.Option.forEach(input => input->CardUtils.focus)->ignore
    | None => ()
    }
  }
  React.useEffect1(() => {
    isActive ? focusCVC() : ()
    None
  }, [isActive])
  <AddDataAttributes attributes=[("data-testid", `card-${index->Belt.Int.toString}`)]>
    <button
      className={`PickerItem ${pickerItemClass} flex flex-row items-stretch`}
      type_="button"
      style={ReactDOMStyle.make(
        ~minWidth="150px",
        ~width="100%",
        ~padding="1rem 0 1rem 0",
        ~cursor="pointer",
        ~borderBottom=index == savedCardlength - 1 ? "0px" : `1px solid ${themeObj.borderColor}`,
        ~borderTop="none",
        ~borderLeft="none",
        ~borderRight="none",
        ~borderRadius="0px",
        ~background="transparent",
        ~color=themeObj.colorTextSecondary,
        ~boxShadow="none",
        (),
      )}
      onClick={_ => setPaymentToken(._ => (paymentItem.paymentToken, paymentItem.customerId))}>
      <div className="w-full">
        <div>
          <div className="flex flex-row justify-between items-center">
            <div
              className={`flex flex-row justify-center items-center`}
              style={ReactDOMStyle.make(~columnGap=themeObj.spacingUnit, ())}>
              <div style={ReactDOMStyle.make(~color=isActive ? themeObj.colorPrimary : "", ())}>
                <Radio
                  checked=isActive
                  height="18px"
                  className="savedcard"
                  marginTop="-2px"
                  opacity="20%"
                  padding="46%"
                  border="1px solid currentColor"
                />
              </div>
              <div className={`PickerItemIcon ${pickerItemIconClass} mx-3 flex  items-center `}>
                brandIcon
              </div>
              <div
                className={`PickerItemLabel ${pickerItemLabelClass} flex flex-row gap-3  items-center w-full`}>
                <div className="tracking-widest"> {React.string(`****`)} </div>
                <div> {React.string({paymentItem.card.last4Digits})} </div>
              </div>
            </div>
            <div
              className={`flex flex-row items-center justify-end gap-3 -mt-1`}
              style={ReactDOMStyle.make(~fontSize="14px", ~opacity="0.5", ())}>
              <div className="flex">
                {React.string(
                  `${paymentItem.card.expiryMonth} / ${paymentItem.card.expiryYear->CardUtils.formatExpiryToTwoDigit}`,
                )}
              </div>
            </div>
          </div>
          <div className="w-full ">
            <RenderIf condition={isActive}>
              <div className="flex flex-col items-start mx-8">
                <div
                  className={`flex flex-row items-start justify-start gap-2`}
                  style={ReactDOMStyle.make(~fontSize="14px", ~opacity="0.5", ())}>
                  <div className="w-12 mt-6"> {React.string("CVC: ")} </div>
                  <div
                    className={`flex h mx-4 justify-start w-16 ${isActive
                        ? "opacity-1 mt-4"
                        : "opacity-0"}`}>
                    <PaymentInputField
                      isValid=isCVCValid
                      setIsValid=setIsCVCValid
                      value=cvcNumber
                      onChange=changeCVCNumber
                      onBlur=handleCVCBlur
                      errorString=cvcError
                      inputFieldClassName="flex justify-start"
                      paymentType
                      name={TestUtils.cardCVVInputTestId}
                      appearance=config.appearance
                      type_="tel"
                      className={`tracking-widest justify-start w-full`}
                      maxLength=4
                      inputRef=cvcRef
                      placeholder="123"
                      height="2.2rem"
                    />
                  </div>
                </div>
                <Surcharge
                  list
                  paymentMethod="card"
                  paymentMethodType="debit"
                  cardBrand={cardBrand->CardUtils.cardType}
                />
              </div>
            </RenderIf>
          </div>
        </div>
      </div>
    </button>
  </AddDataAttributes>
}
