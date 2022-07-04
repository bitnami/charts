/// <reference types="cypress" />

export let random = (Math.random() + 1).toString(36).substring(7);

export let allowDataUsage = () => {
  cy.contains('Average Order');
  // cy.wait(2000);
  cy.get('body').then(($body) => {
    console.log($body.find('[class="admin__fieldset"]'));
    console.log($body.find('[class="admin__fieldset"]').is(':visible'));
    if ($body.find('[class="admin__fieldset"]').is(':visible')) {
      cy.contains('.action-primary', 'Allow').click({ force: true });
    }
  });
};
