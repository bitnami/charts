
/// <reference types="cypress" />

const ALERT_SUCCESS = 'div[data-testid="data-testid Alert success"]';

export const verifySuccesOfAction = () => {
    cy.get(ALERT_SUCCESS).should('be.visible');
}

export let random = (Math.random() + 1).toString(36).substring(7);
console.log("random", random);
