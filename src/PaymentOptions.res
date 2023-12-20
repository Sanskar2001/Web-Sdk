open RecoilAtoms
module TabLoader = {
  @react.component
  let make = (~cardShimmerCount) => {
    let list = Recoil.useRecoilValueFromAtom(RecoilAtoms.list)
    let {themeObj} = Recoil.useRecoilValueFromAtom(configAtom)
    open PaymentType
    open PaymentElementShimmer
    switch list {
    | SemiLoaded =>
      Belt.Array.make(cardShimmerCount - 1, "")
      ->Js.Array2.mapi((_, i) => {
        <div
          className={`Tab flex flex-col gap-3 animate-pulse cursor-default`}
          key={i->Belt.Int.toString}
          style={ReactDOMStyle.make(
            ~minWidth="5rem",
            ~overflowWrap="hidden",
            ~width="100%",
            ~padding=themeObj.spacingUnit,
            ~cursor="pointer",
            (),
          )}>
          <Shimmer classname="opacity-50 w-1/3">
            <div
              className="w-full h-3 animate-pulse"
              style={ReactDOMStyle.make(~backgroundColor=themeObj.colorPrimary, ~opacity="10%", ())}
            />
          </Shimmer>
          <Shimmer classname="opacity-50">
            <div
              className="w-full h-2 animate-pulse"
              style={ReactDOMStyle.make(~backgroundColor=themeObj.colorPrimary, ~opacity="10%", ())}
            />
          </Shimmer>
        </div>
      })
      ->React.array
    | _ => React.null
    }
  }
}

@react.component
let make = (
  ~setCardsContainerWidth,
  ~cardOptions: array<string>,
  ~dropDownOptions: array<string>,
  ~checkoutEle: React.element,
  ~cardShimmerCount: int,
) => {
  let {themeObj, localeString} = Recoil.useRecoilValueFromAtom(configAtom)
  let {readOnly, customMethodNames} = Recoil.useRecoilValueFromAtom(optionAtom)
  let payOptionsRef = React.useRef(Js.Nullable.null)
  let selectRef = React.useRef(Js.Nullable.null)
  let (winW, winH) = Utils.useWindowSize()
  let (selectedOption, setSelectedOption) = Recoil.useRecoilState(selectedOptionAtom)
  let (moreIconIndex, setMoreIconIndex) = React.useState(_ => 0)
  let (toggleIconElement, setToggleIconElement) = React.useState(_ => false)
  React.useEffect2(() => {
    let width = switch payOptionsRef.current->Js.Nullable.toOption {
    | Some(ref) => Webapi.Dom.Element.clientWidth(ref)
    | None => 0
    }
    setCardsContainerWidth(_ => width)
    None
  }, (winH, winW))

  let handleChange = ev => {
    let target = ev->ReactEvent.Form.target
    let value = target["value"]
    setSelectedOption(._ => value)
    CardUtils.blurRef(selectRef)
  }

  let cardOptionDetails = cardOptions->PaymentMethodsRecord.getPaymentDetails

  let dropDownOptionsDetails = dropDownOptions->PaymentMethodsRecord.getPaymentDetails
  let selectedPaymentOption =
    PaymentMethodsRecord.paymentMethodsFields
    ->Js.Array2.find(item => item.paymentMethodName == selectedOption)
    ->Belt.Option.getWithDefault(PaymentMethodsRecord.defaultPaymentMethodFields)

  React.useEffect1(() => {
    let intervalId = Js.Global.setInterval(() => {
      if dropDownOptionsDetails->Belt.Array.length > 1 {
        setMoreIconIndex(prev => mod(prev + 1, dropDownOptionsDetails->Belt.Array.length))

        setToggleIconElement(_ => true)
        Js.Global.setTimeout(() => {
          setToggleIconElement(_ => false)
        }, 10)->ignore
      }
    }, 5000)

    Some(
      () => {
        Js.Global.clearInterval(intervalId)
      },
    )
  }, [dropDownOptionsDetails])

  let displayIcon = ele => {
    <span className={`scale-90 animate-slowShow ${toggleIconElement ? "hidden" : ""}`}> ele </span>
  }
  <div className="w-full">
    <AddDataAttributes attributes=[("data-testid", TestUtils.paymentMethodListTestId)]>
      <div
        ref={payOptionsRef->ReactDOM.Ref.domRef}
        className="flex flex-row overflow-auto no-scrollbar"
        style={ReactDOMStyle.make(
          ~columnGap=themeObj.spacingTab,
          ~marginBottom=themeObj.spacingGridColumn,
          ~paddingBottom="7px",
          ~padding="4px",
          ~height="auto",
          (),
        )}>
        {cardOptionDetails
        ->Js.Array2.mapi((payOption, i) => {
          let isActive = payOption.paymentMethodName == selectedOption
          <TabCard key={i->Belt.Int.toString} paymentOption=payOption isActive />
        })
        ->React.array}
        <TabLoader cardShimmerCount />
        <RenderIf condition={dropDownOptionsDetails->Js.Array2.length > 0}>
          <div className="flex relative h-auto justify-center">
            <div className="flex flex-col items-center absolute mt-3 pointer-events-none gap-y-1.5">
              {switch dropDownOptionsDetails->Belt.Array.get(moreIconIndex) {
              | Some(paymentFieldsInfo) =>
                switch paymentFieldsInfo.miniIcon {
                | Some(ele) => displayIcon(ele)
                | None =>
                  switch paymentFieldsInfo.icon {
                  | Some(ele) => displayIcon(ele)
                  | None => React.null
                  }
                }
              | None => React.null
              }}
              <Icon size=10 name="arrow-down" />
            </div>
            <AddDataAttributes attributes=[("data-testid", TestUtils.paymentMethodDropDownTestId)]>
              <select
                value=selectedPaymentOption.paymentMethodName
                ref={selectRef->ReactDOM.Ref.domRef}
                className={`TabMore place-items-start outline-none`}
                onChange=handleChange
                disabled=readOnly
                style={ReactDOMStyle.make(
                  ~width="40px",
                  ~paddingLeft=themeObj.spacingUnit,
                  ~background=themeObj.colorBackground,
                  ~cursor="pointer",
                  ~height="inherit",
                  ~borderRadius=themeObj.borderRadius,
                  ~appearance="none",
                  ~color="transparent",
                  (),
                )}>
                <option value=selectedPaymentOption.paymentMethodName disabled={true}>
                  {React.string(
                    selectedPaymentOption.displayName === "Card"
                      ? localeString.card
                      : {
                          let (name, _) = PaymentUtils.getDisplayNameAndIcon(
                            customMethodNames,
                            selectedPaymentOption.paymentMethodName,
                            selectedPaymentOption.displayName,
                            selectedPaymentOption.icon,
                          )
                          name
                        },
                  )}
                </option>
                {dropDownOptionsDetails
                ->Js.Array2.mapi((item, i) => {
                  <option
                    key={string_of_int(i)}
                    value=item.paymentMethodName
                    style={ReactDOMStyle.make(~color=themeObj.colorPrimary, ())}>
                    {React.string(
                      item.displayName === "card"
                        ? localeString.card
                        : {
                            let (name, _) = PaymentUtils.getDisplayNameAndIcon(
                              customMethodNames,
                              item.paymentMethodName,
                              item.displayName,
                              item.icon,
                            )
                            name
                          },
                    )}
                  </option>
                })
                ->React.array}
              </select>
            </AddDataAttributes>
          </div>
        </RenderIf>
      </div>
    </AddDataAttributes>
    {checkoutEle}
  </div>
}
