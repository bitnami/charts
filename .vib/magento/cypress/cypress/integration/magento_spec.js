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
  cy.get('.item-catalog-products').click();
  cy.contains('Salable Quantity');
  cy.get('#add_new_product-button').click();
  cy.fixture('products').then((product) => {
    cy.get('[name="product[name]"]').type(
      `${product.newProduct.productName}.${random}`
    );
    cy.get('[name="product[price]"]').type(product.newProduct.price);
  });
  cy.contains('Images And Videos').click();
  cy.get('#fileupload').selectFile('cypress/fixtures/images/image.png', {
    force: true,
  });
  cy.get('.product-image');
  cy.get('#save-button').click();
  cy.contains('You saved the product');
  cy.get('#menu-magento-catalog-catalog').click();
  cy.get('.item-catalog-products').click();
  cy.fixture('products').then((product) => {
    cy.contains(`${product.newProduct.productName}.${random}`);
  });
});

it('allows user to create a customer account', () => {
  cy.visit('/');
  cy.contains('Create an Account').click();
  cy.fixture('customers').then((customer) => {
    cy.get('.field-name-firstname').type(
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

it('allows customer to subscribe to newsletter', () => {
  cy.visit('/');
  cy.fixture('customers').then((customer) => {
    cy.get('#newsletter').type(`${random}.${customer.newCustomer.email}`);
  });
  cy.contains('Subscribe').click();
  cy.contains('Thank you for your subscription.');
  cy.login();
  cy.get('#menu-magento-backend-marketing').click();
  cy.get('.item-newsletter-subscriber').click();
  cy.fixture('customers').then((customer) => {
    cy.contains(`${random}.${customer.newCustomer.email}`);
  });
});

it('allows admin to add a discount', () => {
  cy.login();
  cy.get('#menu-magento-backend-marketing').click();
  cy.get('.item-promo-catalog').click();
  cy.get('#add').click({ force: true });
  cy.fixture('discounts').then((discount) => {
    cy.get('[name="name"]').type(`${discount.newDiscount.ruleName}.${random}`);
    cy.get('.admin__actions-switch-text').click({ force: true });
    cy.get('[class="admin__control-multiselect"]')
      .first()
      .select('Main Website');

    cy.get('[class="admin__control-multiselect"]').last().select('General');
    cy.get('#save').click();
    cy.get('[name="discount_amount"]').type(discount.newDiscount.amount);
    cy.get('#save').click();
  });
  cy.contains('You saved the rule');
  cy.get('#apply_rules').click();
  cy.contains('Updated rules applied');
});

it('allows admin to customize the home page', () => {
  cy.login();
  cy.get('#menu-magento-backend-content').click();
  cy.get('.item-cms-page').click();
  cy.get('.page-main-actions');
  cy.get('[data-role="grid-wrapper"]').within(() => {
    cy.contains('td', 'home').siblings().last().click();
    cy.get('[class="action-menu _active"]').within(() => {
      cy.contains('Edit').click({ force: true });
    });
  });
  cy.fixture('pages').then((page) => {
    cy.get('input[name="title"]').type(`${page.newPage.pageTitle}.${random}`, {
      force: true,
    });
  });
});
