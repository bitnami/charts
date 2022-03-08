
/// <reference types="cypress" />

export const verifySuccesOfAction = () => {
    cy.get('div[data-testid*="data-testid Alert success"]').should('be.visible');
}

export let random = (Math.random() + 1).toString(36).substring(7);
console.log("random", random);
