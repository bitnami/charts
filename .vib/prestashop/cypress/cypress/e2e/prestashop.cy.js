/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

// Note: Interaction with the UI is preferred over cy.visit() as
// PrestaShop requires to provide a token within the URL or else
// a security warning page is shown.

it('allows a user to place an order and an admin to list it', () => {
  cy.visit('/');
  cy.contains('new products').click();
  cy.get('div.product').first().click();
  cy.fixture('customers').then((customers) => {
    cy.get('textarea[class=product-message]').type(customers.shopper.firstName);
  });
  cy.contains('Save Customization').click();
  cy.contains('Add to cart').click();
  cy.contains('Proceed').click();
  cy.contains('checkout').click();
  cy.fixture('customers').then((customers) => {
    cy.get('form#customer-form').within(() => {
      cy.get('#field-id_gender-1').check();
      cy.get('#field-firstname').type(customers.shopper.firstName);
      cy.get('#field-lastname').type(customers.shopper.lastName);
      cy.get('#field-email').type(`${random}${customers.shopper.email}`);
      cy.get('[name="customer_privacy"]').check();
      cy.get('[name="psgdpr"]').check();
      cy.contains('button', 'Continue').click();
    });
    cy.get('div[id=delivery-address]').within(() => {
      cy.get('#field-address1').type(customers.shopper.address.street);
      cy.get('#field-city').type(customers.shopper.address.city);
      cy.get('#field-id_state').select(customers.shopper.address.state);
      cy.get('#field-postcode').type(customers.shopper.address.zipcode);
      cy.contains('button', 'Continue').click();
    });
    cy.get('form#js-delivery').within(() => {
      cy.contains('button', 'Continue').click();
    });
    cy.get('#payment-option-1').click();
    cy.get('[id*="conditions_to_approve"]').click();
    cy.contains('button', 'Place order').click();
    cy.contains('order is confirmed');
    cy.login();
    cy.contains('a[href*="sell/orders/?"]', 'Orders').click();
    cy.get('#subtab-AdminOrders').click();
    cy.get('td[class*="column-reference"]').first().click();
    cy.contains(`${random}${customers.shopper.email}`);
  });
});

it('allows performing backups', () => {
  cy.login();
  cy.contains(
    '[href*="configure/advanced/system-information"]',
    'Advanced Parameters'
  ).click();
  cy.contains('[href*="configure/advanced/sql-requests"]', 'Database').click();
  cy.contains('#subtab-AdminBackup', 'DB Backup').click();

  cy.contains('button', 'create a new backup').click();
  // Perform a request instead of clicking the link, as Cypress would try to
  // navigate and eventually fail.
  cy.contains('a', 'Download the backup')
    .invoke('attr', 'href')
    .then((href) => {
      cy.log(href);
      cy.request({
        url: href,
        method: 'GET',
      }).then((response) => {
        expect(response.status).to.eq(200);
        expect(response.headers['content-type']).to.eq('application/x-bzip2');
      });
    });
});
