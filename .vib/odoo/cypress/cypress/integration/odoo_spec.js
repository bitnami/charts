/// <reference types="cypress" />
import { random } from './utils';
import 'cypress-real-events/support';

it('allows creating a company', () => {
  cy.login();
  cy.get('[title="Home Menu"]').click();
  cy.contains('Settings').click();
  cy.contains('Users & Companies').click();
  cy.get('[data-menu-xmlid="base.menu_action_res_company_form"]').click();
  cy.get('.o_list_button_add').click();
  cy.fixture('companies').then((company) => {
    cy.get('[name="name"]').type(`${company.newCompany.name}.${random}`, {
      force: true,
    });
    cy.get('[name="phone"]').type(`${company.newCompany.phone}.${random}`, {
      force: true,
    });
    cy.contains('Save').click();
    cy.contains('.oe_title', 'Company Name');
    cy.contains('.oe_title', `${company.newCompany.name}.${random}`);
  });
});

it('allows installing/uninstalling an application', () => {
  cy.login();
  cy.contains('Sales').click();
  cy.get('[title="Sales"]').within(() => {
    cy.contains('Install').click();
    cy.reload();
  });
  cy.get('[title="Home Menu"]').click();
  cy.contains('Apps').click();
  cy.get('.o_searchview_input').type('Discuss {enter}');
  cy.contains('.oe_module_vignette', 'Discuss').within(() => {
    cy.contains('Discuss');
    cy.get('a[title="Dropdown menu"]').click({ force: true });
  });
  cy.contains('Uninstall').click({ force: true });
  cy.contains('The following documents will be permanently lost');
  cy.contains('Confirm').click();
});

it('allows inviting new users', () => {
  cy.login();
  cy.get('[title="Home Menu"]').click();
  cy.contains('Settings').click();
  cy.fixture('newUsers').then((newUser) => {
    cy.get('.o_user_emails').type(`${random}.${newUser.newUser.email}`);
    cy.get('[data-loading-text="Inviting..."]').click();
    cy.get('#invite_users_setting').within(() => {
      cy.contains(`${random}.${newUser.newUser.email}`);
    });
  });
});

it('allows creating a user', () => {
  cy.login();
  cy.get('[title="Home Menu"]').click();
  cy.contains('Settings').click();
  cy.contains('Users').click();
  cy.get('[data-menu-xmlid="base.menu_action_res_users"]').click();
  cy.get('.o_list_button_add').click({ force: true });
  cy.fixture('users').then((user) => {
    cy.contains('Access Rights');
    cy.get('[name="name"]').type(`${user.newUser.name}.${random}`);
    cy.get('[name="login"]').type(`${random}${user.newUser.email}`);
    cy.contains('Save').click();
    cy.get('[title="Home Menu"]').click();
    cy.contains('Settings').click();
    cy.contains('Manage Users').click();
    cy.contains(`${user.newUser.name}.${random}`);
  });
});

it('allows uploading a photo of the admin', () => {
  cy.login();
  cy.contains('Administrator').click();
  cy.contains('Preferences').click();
  cy.get('.img').realHover().realClick();
  cy.get('input[type="file"').selectFile('cypress/fixtures/images/image.png', {
    force: true,
  });
  cy.contains('Save').click();
});
