/// <reference types="cypress" />

export let random = (Math.random() + 1).toString(36).substring(7);

export let allowDataUsage = () => {
  cy.get('body').then(($body) => {
    if ($body.find('.admin__form-loading-mask').is(':visible')) {
      cy.contains('.action-primary', 'Allow').click({ force: true });
    }
  });
};
