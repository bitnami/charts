/// <reference types="cypress" />

describe.only('Apache Flink', () => {
  it('Flink UI should return 200', () => {
    cy.visit('/')
    cy.request('/')
      .its('status')
      .should('eq', 200)
  })

  it('should show available task slots', () => {
    cy.visit('/')
    cy.get('div.field').within(() => {
      cy.contains('Total Task Slots'); // Asserts that the first span contains the text "Total Task Slots"
      cy.contains('span', /^\d+$/).should(($span) => {
        const num = parseInt($span.text());
        expect(num).to.be.greaterThan(0); // Asserts that the number in the second span is greater than 0
      });
    });
  })

  it('should show completed jobs', () => {
    cy.visit('/')
    cy.contains('span', 'FINISHED')
  })
})
