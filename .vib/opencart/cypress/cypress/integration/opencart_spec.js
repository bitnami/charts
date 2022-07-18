/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows a user to register', () => {
  cy.visit('/index.php?route=account/login');
  cy.contains('Continue').click();
  cy.fixture('users').then((user) => {
    cy.get('#input-firstname').type(`${user.newUser.firstName}.${random}`);
    cy.get('#input-lastname').type(`${user.newUser.lastName}.${random}`);
    cy.get('#input-email').type(`${random}.${user.newUser.email}`);
    cy.get('#input-telephone').type(user.newUser.phone);
    cy.get('#input-password').type(`${user.newUser.password}.${random}`);
    cy.get('#input-confirm').type(`${user.newUser.password}.${random}`);
  });
  cy.get('[type="checkbox"]').check();
  cy.contains('Continue').click();
  cy.contains('Your Account Has Been Created');
});

it('allows a user to place an order and an admin to list it', () => {
  cy.visit('/desktops/mac');
  cy.contains('Add to Cart').click();
  cy.contains('.alert', 'Success');
  cy.get('.btn-inverse').click();
  cy.contains('Checkout').click();
  cy.contains('Guest Checkout').click();
  cy.get('#button-account').click();
  cy.fixture('guests').then((guest) => {
    cy.get('#input-payment-firstname').type(
      `${guest.newGuest.firstName}.${random}`
    );
    cy.get('#input-payment-lastname').type(
      `${guest.newGuest.lastName}.${random}`
    );
    cy.get('#input-payment-email').type(`${guest.newGuest.email}`);
    cy.get('#input-payment-telephone').type(guest.newGuest.phone);
    cy.get('#input-payment-address-1').type(`${guest.newGuest.address}`);
    cy.get('#input-payment-city').type(guest.newGuest.city);
    cy.get('#input-payment-postcode').type(guest.newGuest.postCode);
    cy.get('#input-payment-zone').select(guest.newGuest.zone);
  });
  cy.get('#button-guest').click();
  cy.get('#button-shipping-method').click();
  cy.get('[name="agree"]').check();
  cy.get('#button-payment-method').click();
  cy.get('#button-confirm').click();
  cy.contains('Your order has been placed!');
  cy.login();
  cy.contains('Sales').click();
  cy.contains('Orders').click();
  cy.fixture('guests').then((guest) => {
    cy.contains(`${guest.newGuest.firstName}.${random}`);
  });
});

it('allows an admin to add a product to the catalog', () => {
  cy.login();
  cy.contains('Catalog').click();
  cy.contains('Product').click();
  cy.get('[data-original-title="Add New"]').click();
  cy.fixture('products').then((product) => {
    cy.get('#input-name1').type(`${product.newProduct.name}.${random}`);
    cy.get('#input-meta-title1').type(product.newProduct.metatagTitle);
    cy.contains('Data').click();
    cy.get('#input-model').type(product.newProduct.model);
    cy.get('[data-original-title="Save"]').click();
    cy.contains('Success');
    cy.visit('/');
    cy.get('.form-control').type(
      `${product.newProduct.name}.${random} {enter}`
    );
    cy.get('#content').contains(`${product.newProduct.name}.${random}`);
  });
});

it('checks if SMTP is configured as per the chart', () => {
  cy.login();
  cy.contains('System').click();
  cy.contains('Settings').click();
  cy.get('[data-original-title="Edit"]').click();
  cy.contains('[data-toggle="tab"]', 'Mail').click();
  cy.get('#input-mail-smtp-hostname').should(
    'have.value',
    Cypress.env('smtpHost')
  );
  cy.get('#input-mail-smtp-username').should(
    'have.value',
    Cypress.env('smtpUser')
  );
});

it('allows the admin to upload a file', () => {
  cy.login();
  cy.contains('Catalog').click();
  cy.contains('Downloads').click();
  cy.get('[data-original-title="Add New"]').click();
  cy.fixture('downloads').then((download) => {
    cy.get('#button-upload').click();
    cy.get('input[type="file"]').selectFile(
      'cypress/fixtures/images/logo.png',
      {
        force: true,
      }
    );
    cy.get('[placeholder="Download Name"]').type(
      `${download.newDownload.name}.${random}`
    );
  });
  cy.get('[data-original-title="Save"]').click();
  cy.contains('Success: You have modified downloads!');
});
