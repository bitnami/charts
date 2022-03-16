
/// <reference types="cypress" />

export let random = (Math.random() + 1).toString(36).substring(7);

export const importTestData = () => {
}

export const skipTheWelcomeScreen = () => {
    cy.visit('app/home#/');
    cy.contains('button[data-test-subj="skipWelcomeScreen"]','Explore on my own').should('be.visible').click();
}

export const closeTheSecurityWarnings = () => {
    cy.get('button[data-test-subj="toastCloseButton"]').click();
    cy.get('button[data-test-subj="toastCloseButton"]').click({multiple:true});
}

export function dragAndDrop (x, y) {
    cy.get('[data-test-subj="lnsDragDrop_draggable-dataset"]')
    .trigger('mousedown', { which: 1 })
    .trigger('mousemove', { clientX: x, clientY: y })
    .trigger('mouseup', { force: true })
  }

