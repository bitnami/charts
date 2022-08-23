/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows adding a new course with image', () => {
  cy.login();
  cy.visit('course/edit.php');
  cy.fixture('courses').then((courses) => {
    cy.get('#id_fullname').type(`${courses.newCourse.fullName}.${random}`);
    cy.get('#id_shortname').type(`${courses.newCourse.shortName}.${random}`);
  });
  cy.get('.fp-btn-add').click();
  cy.contains('a', 'Upload a file').click();
  cy.get('input[type="file"]').selectFile(
    'cypress/fixtures/images/test_image.jpeg',
    {
      force: true,
    }
  );
  cy.contains('button', 'Upload this file').click();
  cy.contains('input', 'Save and display').click();
  cy.visit('/my/courses.php');
  cy.fixture('courses').then((courses) => {
    cy.contains(`${courses.newCourse.fullName}.${random}`);
  });
});
