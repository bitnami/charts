/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows creating a new user with a profile picture', () => {
  cy.login();
  cy.visit('/admin/people/create');
  cy.fixture('users').then((user) => {
    cy.get('#edit-mail').type(`${random}.${user.newUser.email}`);
    cy.get('#edit-name').type(`${user.newUser.name}${random}`);
    cy.get('#edit-pass-pass1').type(`${random}${user.newUser.password}`);
    cy.get('#edit-pass-pass2').type(`${random}${user.newUser.password}`);
    cy.get('[type=file]').selectFile('cypress/fixtures/images/test_image.jpeg', { force: true });
    cy.contains('test_image');
    cy.contains('Create new account').click();
    cy.visit('/admin/people');
    cy.contains(`${user.newUser.name}${random}`);
  })
});