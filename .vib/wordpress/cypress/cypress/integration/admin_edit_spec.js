/// <reference types="cypress" />
describe('Edit page ', () => {

  beforeEach(() => {
    cy.login();
    cy.visit('/wp-admin/index.php')
  })

  it('allows editing the site.', () => {
    cy.get('#welcome-panel .load-customize')
    .should('exist')
    .should('have.text', 'Customize Your Site')
    .click();
    cy.url().should('include', '/wp-admin/customize.php');
  })

  it('/edit.php allows editing posts', () => {
    cy.visit('/wp-admin/edit.php');
    cy.get('#bulk-action-selector-top').should('exist');
    cy.get('#post-1 .row-title').should('exist').click();
    cy.url().should('include', '/post.php?post=1&action=edit');
    cy.get('#editor').should('exist');
  })

})
