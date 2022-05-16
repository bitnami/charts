/// <reference types="cypress" />
import { random, checkErrors } from './utils';

it('allows user to log in and log out', () => {
  cy.login();
  cy.contains('.alert-danger').should('not.exist');
  cy.get('div#tasks');

  cy.get('[href$="/logout"]').click();
  cy.get('form[name*="login"]');
});

it('should be possible to create a new Git Project', () => {
  cy.login();
  cy.visit('/view/All/newJob');

  cy.fixture('items').then((item) => {
    cy.get('#name').type(`${item.freestyleProject.name}-${random}`);
    cy.contains(item.freestyleProject.type).click();
    cy.contains('button', 'OK').should('be.enabled').click();
    cy.contains('Error').should('not.be.visible');

    cy.get('.radio-block-start').contains('Git').click();
    cy.get("input[name*='url']").type(item.freestyleProject.repositoryURL);
    cy.contains('button', 'Save').click();
    cy.contains('h1', item.freestyleProject.name);
  });

  // As a new Git project is created in every execution, the next build
  // will always be the first one.
  const nextBuildNumber = 1;
  cy.get("a[title='Build Now']").click();
  cy.contains(`#${nextBuildNumber}`);

  cy.get("a[title='Build Now']");
  // Depending on the setup, the node where to execute the build needs to be
  // provisioned, which can take up some time
  cy.get(`a[href$='/${nextBuildNumber}/'][class*='display-name']`).click();

  cy.fixture('items').then((item) => {
    cy.visit(
      `/job/${item.freestyleProject.name}-${random}/${nextBuildNumber}/`
    );
    cy.contains(`Build #${nextBuildNumber}`);
    cy.contains('Build has been executing for');
  });
});

it('should be possible to register a new user', () => {
  cy.login();
  cy.visit('/securityRealm/addUser');

  cy.contains('Create User');
  cy.fixture('users').then((user) => {
    cy.get('#username').type(`${user.newUser1.username}-${random}`);
    cy.get("input[name='password1']").type(user.newUser1.password);
    cy.get("input[name='password2']").type(user.newUser1.password);
    cy.get("input[name='fullname']").type(
      `${user.newUser1.fullname}-${random}`
    );
    cy.get("input[name='email']").type(`${random}-${user.newUser1.email}`);
    cy.contains('button', 'Create User').click();

    cy.visit('/securityRealm');
    cy.contains('Users');
    cy.contains(`${user.newUser1.username}-${random}`);
  });
});

it('should not contain errors', () => {
  cy.login();
  cy.visit('/manage');

  const errorAllowedList = [];
  cy.get('body').then(($body) => {
    if ($body.find('.alert-danger').length > 0) {
      checkErrors('.alert-danger', errorAllowedList);
    } else {
      cy.log('No error messages found in the UI');
    }
  });
});

it('should list the built-in node', () => {
  cy.login();
  cy.visit('/computer');

  cy.contains('Manage nodes and clouds');
  cy.get('table#computers').within(() => {
    cy.contains('tr', 'Built-In Node');
  });
});
