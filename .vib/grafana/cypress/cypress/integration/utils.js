
/// <reference types="cypress" />

<<<<<<< HEAD
const ALERT_SUCCESS = 'div[data-testid="data-testid Alert success"]'; 
const DELETE_BUTTON = 'button[aria-label="Confirm Modal Danger Button"]';
const DASHBOARD_SETTINGS = '[aria-label="Dashboard settings"]';
const DELETE_DASHBOARD_BUTTON = '[aria-label="Dashboard settings page delete dashboard button"]';
const CLOSE_DIALOGUE_BUTTON = 'button[aria-label="Close dialogue"]';
const DELETE_API_KEY_BUTTON = 'button[aria-label="Delete API key"]';

export const deleteDashboard = () => {
    cy.get(DASHBOARD_SETTINGS).click();
    cy.get(DELETE_DASHBOARD_BUTTON).click();
    cy.get('div').contains('Do you want to delete').should('be.visible');
    clickDeleteButton();
    verifySuccesOfAction();
}

export const deleteAPIKey = () => {
    cy.get(CLOSE_DIALOGUE_BUTTON).click();
    cy.get(DELETE_API_KEY_BUTTON).click();
    cy.get('span').contains('Delete').click();
    verifySuccesOfAction();
}

export const verifySuccesOfAction = () => {
    cy.get(ALERT_SUCCESS).should('be.visible');
}

export const clickDeleteButton = () => {
    cy.get(DELETE_BUTTON).should('be.visible').click();
}
=======
export const verifySuccesOfAction = () => {
    cy.get('div[data-testid*="data-testid Alert success"]').should('be.visible');
}

export let random = (Math.random() + 1).toString(36).substring(7);
console.log("random", random);
>>>>>>> bitnami-master
