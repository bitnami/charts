/// <reference types="cypress" />

import {
    random,
  } from './utils'
  
  it('allows to see Runtime & Build information', () => {
    cy.visit('/');
    cy.contains('.dropdown-toggle','Status').should('be.visible').click();
    cy.contains('[class="dropdown-item"]','Runtime & Build Information').click();
    cy.contains('Runtime Information').should('be.visible');
    cy.get('h2').contains('Build Information').should('be.visible');
  })

  it('allows the execution of a query', () => {
    cy.visit('/');
    cy.get('.cm-line').type('scalar {enter}');
    cy.get('.alert').contains('Empty query result').should('be.visible');
  })

  it('allows listing all installed stores', () => {
    cy.visit('/');
    cy.contains('[class="nav-link"]','Stores').should('be.visible').click();
    cy.contains('No stores registered').should('be.visible');
  })

  it('allows changing of the UI' ,() => {
    cy.visit('/');
    cy.contains('[class="nav-link"]','Classic UI').should('be.visible').click();
    cy.contains('.nav-link','New UI').should('exist'); //check if the UI is switched
  })

  it('allows adding a graph', () => {
    cy.visit('/');
    cy.contains('button','Add Panel').should('be.visible').click();
    cy.get('.execute-btn').should('have.length',2); //check if there are 2 execute buttons, 1 for new panel
  })
  
  