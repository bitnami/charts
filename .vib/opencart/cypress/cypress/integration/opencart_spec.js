/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows a user to place an order and an admin to list it', () => {
  cy.visit('/desktops/mac');
  cy.contains('Add to Cart').click();
  cy.contains('You have added');
  cy.visit('/index.php?route=checkout/checkout');
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
  cy.contains('order has been placed');
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
    cy.get('[name="search"]').type(
      `${product.newProduct.name}.${random} {enter}`
    );
    cy.get('#content').contains(`${product.newProduct.name}.${random}`);
  });
});
