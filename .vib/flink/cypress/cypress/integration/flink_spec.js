/// <reference types="cypress" />

describe.only('Apache Flink', () => {
  it('Flink UI should return 200', () => {
    cy.visit('/')
    cy.request('/')
      .its('status')
      .should('eq', 200)
  })

  it('should show completed jobs', () => {
    cy.visit('/')
    cy.contains('span', 'FINISHED')
  })

  it('should show available task slots', () => {
    cy.visit('/')
    cy.get('.field').within(() => {
      cy.contains('Total Task Slots');
      cy.contains('6');
    });
  })
})
