/// <reference types="cypress" />
import { random, getPageUrlFromTitle, confirmLogOut } from './utils';

it('allows to log in and out', () => {
  cy.login();
  cy.get('a[href*="logout"]').click();
  cy.contains('Sign in');
});

it('allows to create user', () => {
  cy.login();
  cy.visit('/?module=UsersManager&showadduser=1');
  cy.fixture('users').then((user) => {
    cy.get('#user_login').type(`${user.newUser.username}-${random}`);
    cy.get('#user_password').type(
      `${user.newUser.password}-${random}`
    );
    cy.get('#user_password').type(
      `${user.newUser.password}-${random}`
    );
    cy.get('#user_email').type(`${random}_${user.newUser.email}`);
  });
  cy.contains('input', 'Create user').click();
  cy.contains('changes have been saved');
});

it('allows to create a new website', () => {
  cy.login();
  cy.visit('/index.php?module=SitesManager&showaddsite=1');
  // We need to use the title attribute because with the inner HTML we cannot differentiate
  // between "website" and "intranet website"
  cy.get('button[title*="A website"]').click();
  cy.fixture('websites').then((site) => {
    // The name input has no attribute "name" or "id"
    cy.get('input[placeholder="Name"]').type(`${site.newSite.name}`, { force: true });
    cy.get('textarea[name="urls"]').type(`${site.newSite.url}`, { force: true });
  });
  cy.get('input[type="submit"]').click();
  cy.contains('Website created');
});

it('allows to use the API', () => {
  cy.login();
  cy.visit('/index.php?module=UsersManager&action=addNewToken');
  cy.get('#login_form_password').type(Cypress.env('password'));
  cy.get('#description').type(random);
  cy.get('input[type="submit"]').click();
  cy.contains('Token successfully generated');
  cy.get('code').invoke('text').then((apiToken) => {
    cy.visit(
      '/index.php?module=API&method=API.getMatomoVersion'
      + `'&format=JSON&token_auth=${apiToken}`);
    // The output should be "value: <VERSION>"
    cy.contains('"value": "');
  });
});

it('allows to change users settings', () => {
  cy.login();
  cy.visit('/index.php?module=UsersManager&action=userSettings');
  cy.fixture('users').then((user) => {
    cy.get('#email')
      .clear({ force: true })
      .type(`${random}_${Cypress.env('email')}`);
  });
  cy.contains('button', 'Save').should('not.be.disabled').click();
  cy.get('#currentPassword').type(Cypress.env('password'));
  cy.contains('a', 'Ok').click();

  cy.contains('Settings updated');
});
