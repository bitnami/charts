/// <reference types="cypress" />

export let random = (Math.random() + 1).toString(36).substring(9);

export const skipTheWelcomeScreen = () => {
    cy.visit('/');
    closeThePopups();
    cy.get("body").then(($body) => {
        if ($body.text().includes('Explore on my own')) {
            cy.get('button[data-test-subj="skipWelcomeScreen"]').should('be.visible').click();
        }
    })
}

export const closeThePopups = () => {
    cy.get('[data-test-subj="kbnLoadingMessage"]').should('not.exist');
    cy.get('[data-test-subj="toastCloseButton"]').should('exist').click({
        multiple: true
    });
}
