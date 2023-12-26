let paymentMethodListTestId = "paymentList"
let paymentMethodDropDownTestId = "paymentMethodsSelect"
let cardNoInputTestId = "cardNoInput"
let expiryInputTestId = "expiryInput"
let cardCVVInputTestId = "cvvInput"
let cardHolderNameInputTestId = "BillingName"
let fullNameInputTestId = "FullName"
let emailInputTestId = "email"
let addressLine1InputTestId = "line1"
let cityInputTestId = "city"
let countryDropDownTestId = "Country"
let stateDropDownTestId = "State"
let postalCodeInputTestId = "postal"
let addNewCardIcon = "addNewCard"

/*
{

  "cardNo":"4242 4242 4242 4242",
  "cardExpiry":"04/24",
  "cardCVV":"424",
  "billingName":"Arun Mishra",
  "cardHolderName":"Arun Mishra",
  "email":"arun@gmail.com",
  "address":"123 Main Street Apt 4B",
  "city":"New York",
  "country":"United States",
  "state":"New York",
  "postalCode":"10001",
  "paymentSuccessfulText":"Payment successful"
}


 */

let fieldTestIdMapping = {
  "billing.address.city": cityInputTestId,
  "billing.address.country": countryDropDownTestId,
  "billing.address.first_name": cardHolderNameInputTestId,
  "billing.address.last_name": cardHolderNameInputTestId,
  "billing.address.line1": addressLine1InputTestId,
  "billing.address.state": stateDropDownTestId,
  "billing.address.zip": postalCodeInputTestId,
  "email": emailInputTestId,
  "payment_method_data.card.card_cvc": cardCVVInputTestId,
  "payment_method_data.card.card_exp_month": expiryInputTestId,
  "payment_method_data.card.card_exp_year": expiryInputTestId,
  "payment_method_data.card.card_holder_name": fullNameInputTestId,
  "payment_method_data.card.card_number": cardNoInputTestId,
}

let publishableKey = "pk_snd_3b33cd9404234113804aa1accaabe22f"
let endpoint = "https://sandbox.hyperswitch.io"
let clientSecret = `pay_Brjz6KTIGMXRmCVuNDBh_secret_7C6GvAyMkOqIEPXHGRCf`
let headers = [("Content-Type", "application/json"), ("api-key", publishableKey)]
let uri = `${endpoint}/account/payment_methods?client_secret=${clientSecret}`
// Utils.fetchApi(uri, ~method_=Fetch.Get, ~headers, ())
