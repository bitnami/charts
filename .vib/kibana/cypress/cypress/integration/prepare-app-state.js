/// <reference types="cypress" />

export const skipTheWelcomeScreen = () => {
  cy.visit('/');
  cy.get($body).contains('not ready yet');
  closeThePopups();
  cy.get('body').then(($body) => {
    if ($body.text().includes('Explore on my own')) {
      cy.get('button[data-test-subj="skipWelcomeScreen"]').click();
    }
  });
};

export const closeThePopups = () => {
  cy.get('[data-test-subj="kbnLoadingMessage"]').should('not.exist');
  cy.get('[data-test-subj="toastCloseButton"]').click({
    multiple: true,
  });
};
