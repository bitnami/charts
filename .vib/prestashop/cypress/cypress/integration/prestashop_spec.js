/// <reference types="cypress" />
import { random } from './utils';

// Note: Interaction with the UI is preferred over cy.visit() as
// PrestaShop requires to provide a token within the URL or else
// a security warning page is shown.

it('allows login in and out', () => {
  cy.login();
  cy.contains('Activity overview');

  cy.get('#header_employee_box').click();
  cy.contains('Sign out').click();
  cy.get('form#login_form');
});

it('allows registering a new product', () => {
  cy.login();
  cy.contains('a[href*="catalog/products"]', 'Catalog').click();
  cy.contains('a[href*="catalog/products"]', 'Products').click();
  cy.get('div.header-toolbar').within(() => {
    cy.contains('a[href*="catalog/products/new"]', 'New product').click();
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

    cy.contains('a[href*="catalog/products"]', 'Products').click();
    cy.contains(`${products.newProduct.name} ${random}`);
  });
});

it('allows registering a new customer', () => {
  cy.login();
  cy.contains('a[href*="sell/customers"]', 'Customers').click();
  cy.contains('li#subtab-AdminCustomers', 'Customers').click();
  cy.get('div.header-toolbar').within(() => {
    cy.contains('a[href*="customers/new"]', 'Add new customer').click();
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
  cy.contains('a[href*="payment/payment_methods"]', 'Payment').click();
  cy.contains('a[href*="payment/payment_methods"]', 'Payment Methods').click();
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
    'a[href*="configure/advanced/system-information"]',
    'Advanced Parameters'
  ).click();
  cy.contains('a[href*="configure/advanced/sql-requests"]', 'Database').click();
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
