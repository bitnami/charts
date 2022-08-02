/// <reference types="cypress" />

it('checks if the amount of workers is correct', () => {
  const expectedWorkers = 2;
  cy.visit('/');
  cy.contains(`Alive Workers: ${expectedWorkers}`);
});
