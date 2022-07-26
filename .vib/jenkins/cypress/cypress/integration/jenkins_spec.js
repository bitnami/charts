/// <reference types="cypress" />
import { random, checkErrors } from '../support/utils';

it('allows to create system credentials', () => {
  cy.login();
  cy.visit('/credentials/store/system/domain/_/newCredentials');

  cy.fixture('credentials').then((credential) => {
    cy.contains('div.jenkins-form-item', 'Kind').within(() => {
      cy.get('select').select(credential.newUserAndPass.kind);
    });
    cy.get('[name="_.username"]').type(
      `${credential.newUserAndPass.username}-${random}`
    );
    cy.get('[name="_.password"]').type(credential.newUserAndPass.password);
    cy.get('[name="_.id"]').type(`${credential.newUserAndPass.id}-${random}`);
    cy.contains('button', 'Create').click();
    cy.visit(
      `/credentials/store/system/domain/_/credential/${credential.newUserAndPass.id}-${random}`
    );
    cy.contains(`${credential.newUserAndPass.username}-${random}`);
  });
});

it('should be possible to create a new Jenkins pipeline', () => {
  cy.login();
  cy.visit('/view/All/newJob');

  cy.fixture('items').then((item) => {
    cy.get('#name').type(`${item.freestyleProject.name}-${random}`);
    cy.contains(item.freestyleProject.type).click();
    cy.contains('button', 'OK').should('be.enabled').click();
    cy.contains('Error').should('not.be.visible');

    cy.get('.radio-block-start').contains('Git').click();
    cy.get("[name*='url']").type(item.freestyleProject.repositoryURL);
    cy.contains('button', 'Save').click();
    cy.contains('h1', item.freestyleProject.name);
  });

  // As a new Git project is created in every execution, the next build
  // will always be the first one.
  const nextBuildNumber = 1;
  cy.contains('Build Now').click();
  cy.contains(`#${nextBuildNumber}`);

  cy.contains('Build Now');
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
    cy.get("[name='password1']").type(user.newUser1.password);
    cy.get("[name='password2']").type(user.newUser1.password);
    cy.get("[name='fullname']").type(`${user.newUser1.fullname}-${random}`);
    cy.get("[name='email']").type(`${random}-${user.newUser1.email}`);
    cy.contains('button', 'Create User').click();

    cy.visit('/securityRealm');
    cy.contains('Users');
    cy.contains(`${user.newUser1.username}-${random}`);
  });
});

it('should not report any configuration errors', () => {
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
