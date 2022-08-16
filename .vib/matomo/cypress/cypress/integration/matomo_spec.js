/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows to log in and out', () => {
  cy.login();
  cy.get('a[href*="logout"]').first().click();
  cy.contains('Sign in');
});

it('allows to create user', () => {
  cy.login();
  cy.visit('/?module=UsersManager&showadduser=1');
  cy.fixture('users').then((user) => {
    cy.get('#user_login').type(`${user.newUser.username}-${random}`);
    cy.get('#user_email').type(`${random}_${user.newUser.email}`);
    cy.get('input[value*="Invite user"]').click();
    cy.contains('Success!');
    cy.visit('/index.php?module=UsersManager');
    cy.contains('#userLogin', `${user.newUser.username}-${random}`);
  });
});

it('allows to create a new website', () => {
  cy.login();
  cy.visit('/index.php?module=SitesManager&showaddsite=1');
  // We need to use the title attribute because with the inner HTML we cannot differentiate
  // between "website" and "intranet website"
  cy.get('button[title*="A website"]').click();
  cy.fixture('websites').then((site) => {
    // The name input has no attribute "name" or "id"
    cy.get('input[placeholder="Name"]').type(`${site.newSite.name} ${random}`, {
      force: true,
    });
    cy.get('textarea[name="urls"]').type(`${site.newSite.url}`, {
      force: true,
    });
  });
  cy.get('input[type="submit"]').click();
  cy.contains('Website created');
});

// The Matomo API allows checking the site analytics and tracking metrics
// Source: https://matomo.org/guide/apis/analytics-api/
it('allows to use the API', () => {
  cy.login();
  cy.visit('/index.php?module=UsersManager&action=addNewToken');
  cy.get('#login_form_password').type(Cypress.env('password'));
  cy.get('input[type="submit"]').click();
  cy.get('#description').type(random);
  cy.get('input[type="submit"]').click();
  cy.contains('Token successfully generated');
  cy.get('code')
    .invoke('text')
    .then((apiToken) => {
      cy.request(
        '/index.php?module=API&method=API.getMatomoVersion' +
          `&format=JSON&token_auth=${apiToken}`
      ).then((response) => {
        const bodyString = JSON.stringify(response.body);
        expect(response.status).to.eq(200);
        expect(bodyString).to.contain('"value":');
      });
    });
});

it('allows to change users settings', () => {
  cy.login();
  cy.visit('/index.php?module=UsersManager&action=userSettings');
  cy.contains('Last 7 days').click();
  cy.get('input[value*="Save"]').first().click();
  cy.contains('Settings updated');
});
