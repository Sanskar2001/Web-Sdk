// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add('login', (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add('drag', { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add('dismiss', { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This will overwrite an existing command --
// Cypress.Commands.overwrite('visit', (originalFn, url, options) => { ... })
import "cypress-iframe";
// commands.js or your custom support file
let iframeSelector =
  "#orca-payment-element-iframeRef-orca-elements-payment-element-payment-element";

Cypress.Commands.add("enterValueInIframe", (selector, value) => {
  cy.iframe(iframeSelector)
    .find(`[data-testid=${selector}]`)
    .should("be.visible")
    .type(value);
});

Cypress.Commands.add("selectValueInIframe", (selector, value) => {
  cy.iframe(iframeSelector)
    .find(`[data-testid=${selector}]`)
    .should("be.visible")
    .select(value);
});

Cypress.Commands.add("hardReload", () => {
  cy.wrap(
    Cypress.automation("remote:debugger:protocol", {
      command: "Network.clearBrowserCache",
    })
  );
});
