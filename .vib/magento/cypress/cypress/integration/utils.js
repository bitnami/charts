/// <reference types="cypress" />

export let random = (Math.random() + 1).toString(36).substring(7);

export let allowDataUsage = () => {
  cy.contains('Average Order');
  cy.get('.admin__form-loading-mask').should('not.exist');
  cy.get('body').then(($body) => {
    cy.get('.modal-header');
    console.log($body.text().includes('Allow Adobe to collect usage data'));
    if ($body.text().includes('Allow Adobe to collect usage data')) {
      cy.get('.modal-header').should('be.visible');
      cy.contains('.action-primary', 'Allow').click();
    }
  });
};
