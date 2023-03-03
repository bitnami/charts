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
    cy.get('.field')
      .contains('Total Task Slots')
      .siblings('span')
      .contains('6');
  })
})
