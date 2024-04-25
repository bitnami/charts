/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random, allowDataUsage } from '../support/utils';

before(() => {
  cy.login();
  allowDataUsage();
  cy.logout();
});

it('allows admin to add a product to the store', () => {
  cy.login();
  cy.get('#menu-magento-catalog-catalog').click();
  cy.contains('Products').click();
  cy.contains('Salable Quantity');
  cy.contains('Add Product').click();
  cy.fixture('products').then((product) => {
    cy.get('[name="product[name]"]', {timeout: 60000}).type(
      `${product.newProduct.productName}.${random}`
    );
    cy.get('[name="product[price]"]').type(product.newProduct.price);
  });
  cy.contains('Images And Videos').click();
  cy.get('div[class*="fileinput"]').selectFile('cypress/fixtures/images/image.png', {
    action: 'drag-drop',
    force: true,
  });
  cy.get('.product-image').should('be.visible');
  cy.get('#save-button').click();
  cy.get('#menu-magento-catalog-catalog', {timeout: 60000}).click();
  cy.contains('Products').click();
  cy.fixture('products').then((product) => {
    cy.contains(`${product.newProduct.productName}.${random}`);
  });
});

it('allows user to create a customer account', () => {
  cy.visit('/');
  cy.contains('Create an Account').click();
  cy.fixture('customers').then((customer) => {
    cy.get('#firstname').type(
      `${customer.newCustomer.firstName}.${random}`
    );
    cy.get('#lastname').type(`${customer.newCustomer.lastName}.${random}`);
    cy.get('#email_address').type(`${random}.${customer.newCustomer.email}`);
    cy.get('#password').type(customer.newCustomer.password);
    cy.get('#password-confirmation').type(customer.newCustomer.password);
  });
  cy.contains('button', 'Create an Account').click();
  cy.contains('Thank you for registering');
  cy.fixture('customers').then((customer) => {
    cy.get('.logged-in').contains(
      `${customer.newCustomer.firstName}.${random}`
    );
  });
});
