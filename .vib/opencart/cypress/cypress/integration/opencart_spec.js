/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows a user to add an item and register', () => {
  cy.visit('/en-gb/product/macbook');
  cy.contains('Add to Cart').click();
  cy.contains('You have added');
  cy.visit('/index.php?route=checkout/checkout');
  cy.contains('Guest Checkout').click();
  cy.fixture('guests').then((guest) => {
    cy.get('#input-firstname').type(
      `${guest.newGuest.firstName}.${random}`
    );
    cy.get('#input-lastname').type(
      `${guest.newGuest.lastName}.${random}`
    );
    cy.get('#input-email').type(`${guest.newGuest.email}`);
    cy.get('#input-shipping-address-1').type(`${guest.newGuest.address}`);
    cy.get('#input-shipping-city').type(guest.newGuest.city);
    cy.get('#input-shipping-postcode').type(guest.newGuest.postCode);
    cy.get('#input-shipping-zone').select(guest.newGuest.zone);
  });
  cy.get('#button-payment-method').click();
  cy.get('#button-register').click();
  cy.contains('Your account has been created');
});

it('allows an admin to add a product to the catalog', () => {
  cy.login();
  cy.contains('Catalog').click();
  cy.contains('Product').click();
  cy.get('a.btn.btn-primary i.fa-solid.fa-plus').click();
  cy.fixture('products').then((product) => {
    cy.get('#input-name-1').type(`${product.newProduct.name}.${random}`);
    cy.get('#input-meta-title-1').type(product.newProduct.metatagTitle);
    cy.contains('Data').click();
    cy.get('#input-model').type(product.newProduct.model);
      cy.get('#input-keyword-0-1').type(product.newProduct.model, { force: true });
    cy.get('button.btn.btn-primary i.fa-solid.fa-floppy-disk').click();
    cy.contains('Success');
    cy.visit('/');
    cy.get('[name="search"]').type(
      `${product.newProduct.name}.${random} {enter}`
    );
    cy.get('#content').contains(`${product.newProduct.name}.${random}`);
  });
});
