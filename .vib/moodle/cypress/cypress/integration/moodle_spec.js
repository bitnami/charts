/// <reference types="cypress" />

it('adds new course', () => {
  cy.login();
  cy.contains('a', 'Site administration').click();
  cy.contains('a', 'Courses').click();
  cy.contains('a', 'Add a new course').click();
  cy.fixture('courses').then((courses) => {
    cy.get('#id_fullname').type(courses.newCourse.fullName);
    cy.get('#id_shortname').type(courses.newCourse.shortName);
  });
  cy.get('.fp-btn-add').click();
  cy.contains('a', 'Upload a file').click();
  cy.get('input[type="file"]').selectFile(
    'cypress/fixtures/images/post_image.png',
    {
      force: true,
    }
  );
  cy.contains('button', 'Upload this file').click();
  cy.contains('input', 'Save and display').click();
  cy.visit('/my/courses.php');
  cy.fixture('courses').then((courses) => {
    cy.contains(courses.newCourse.fullName);
  });
});
