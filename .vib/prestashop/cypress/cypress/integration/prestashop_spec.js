/// <reference types="cypress" />
import { random } from '../support/utils';

// Note: Interaction with the UI is preferred over cy.visit() as
// PrestaShop requires to provide a token within the URL or else
// a security warning page is shown.

it('allows a user to place an order and an admin to list it', () => {
  cy.visit('/');
  cy.get('div.product').first().click();
  cy.contains('Add to cart').click();
  cy.visit('/order');
  cy.fixture('customers').then((customers) => {
    cy.get('form#customer-form').within(() => {
      cy.get('input#field-id_gender-1').check();
      cy.get('input#field-firstname').type(customers.shopper.firstName);
      cy.get('input#field-lastname').type(customers.shopper.lastName);
      cy.get('input#field-email').type(`${random}${customers.shopper.email}`);
      cy.get('input[name="customer_privacy"]').check();
      cy.get('input[name="psgdpr"]').check();
      cy.contains('button', 'Continue').click();
    });
    cy.get('div.js-address-form').within(() => {
      cy.get('input#field-address1').type(customers.shopper.address.street);
      cy.get('input#field-city').type(customers.shopper.address.city);
      cy.get('select#field-id_state').select(customers.shopper.address.state);
      cy.get('input#field-postcode').type(customers.shopper.address.zipcode);
      cy.contains('button', 'Continue').click();
    });
    cy.get('form#js-delivery').within(() => {
      cy.contains('button', 'Continue').click();
    });
    cy.get('input#payment-option-1').click();
    cy.get('input[id*="conditions_to_approve"]').click();
    cy.contains('button', 'Place order').click();
    cy.contains('order is confirmed');
    cy.login();
    cy.contains('[href*="sell/orders"]', 'Orders').click();
    cy.contains('li#subtab-AdminOrders', 'Orders').click();
    cy.get('td[class*="column-reference"]').first().click();
    cy.contains(`${random}${customers.shopper.email}`);
  });
});

it('allows registering a new product', () => {
  cy.login();
  cy.contains('[href*="catalog/products"]', 'Catalog').click();
  cy.contains('[href*="catalog/products"]', 'Products').click();
  cy.get('div.header-toolbar').within(() => {
    cy.contains('[href*="catalog/products/new"]', 'New product').click();
  });

  cy.fixture('products').then((products) => {
    cy.get('input[placeholder="Enter your product name"]').type(
      `${products.newProduct.name} ${random}`
    );
    cy.get('input[type="file"][accept="image/*"]').selectFile(
      'cypress/fixtures/images/product_image.png',
      { force: true }
    );
    cy.get('input#form_step1_price_shortcut').type(products.newProduct.price);
    cy.contains('input#submit', 'Save').click();
    cy.contains('Settings updated');

    cy.contains('[href*="catalog/products"]', 'Products').click();
    cy.contains(`${products.newProduct.name} ${random}`);
  });
});

it('allows registering a new customer', () => {
  cy.login();
  cy.contains('[href*="sell/customers"]', 'Customers').click();
  cy.contains('li#subtab-AdminCustomers', 'Customers').click();
  cy.get('div.header-toolbar').within(() => {
    cy.contains('[href*="customers/new"]', 'Add new customer').click();
  });

  cy.fixture('customers').then((customers) => {
    cy.get('input#customer_first_name').type(customers.newCustomer.firstName);
    cy.get('input#customer_last_name').type(customers.newCustomer.lastName);
    cy.get('input#customer_email').type(
      `${random}.${customers.newCustomer.email}`
    );
    cy.get('input#customer_password').type(customers.newCustomer.password);
    cy.get('button#save-button').click();
    cy.contains('Successful creation');
    cy.contains(`${random}.${customers.newCustomer.email}`);
  });
  cy.clearCookies();
  cy.clearLocalStorage();
});

it('has payments activated', () => {
  cy.login();
  cy.contains('[href*="payment/payment_methods"]', 'Payment').click();
  cy.contains('[href*="payment/payment_methods"]', 'Payment Methods').click();
  const DEFAULT_ACTIVE_PAY_METHODS = ['Bank transfer', 'Payments by check'];

  cy.contains('div.card', 'Active payment').within(() => {
    DEFAULT_ACTIVE_PAY_METHODS.forEach((method) => {
      cy.contains(method);
    });
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
