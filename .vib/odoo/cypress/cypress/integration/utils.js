/// <reference types="cypress" />

export let random = (Math.random() + 1).toString(36).substring(7);

export let installSalesModule = () => {
  //   cy.login();
  //   cy.contains('Sales').click();
  //   cy.get('[title="Sales"]').within(() => {
  //     cy.contains('Install').click();
  //   });
};

export let uninstallSalesModule = () => {
  cy.login();
  cy.get('[title="Home Menu"]').click();
  cy.contains('Apps').click();
  cy.get('[title="Sales"]').within(() => {
    cy.get('[title="Dropdown menu"]').click();
  });
};
