/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows user to log in and log out', () => {
  cy.login();
  cy.get('joomla-alert[type="warning"]').should('not.exist');
  cy.contains('User Menu').click();
  cy.contains('Log out').click();
  cy.contains('Login Form');
});

it('allows creating a new user and login in', () => {
  cy.login();
  cy.visit('/administrator/index.php?option=com_users&view=users');
  cy.get('.button-new').click();
  cy.fixture('users').then((user) => {
    cy.get('#jform_name').type(`${user.newUser.name}`, { force: true });
    cy.get('#jform_username').type(`${random}.${user.newUser.username}`, {
      force: true,
    });
    cy.get('#jform_password').type(`${user.newUser.password}`, { force: true });
    cy.get('#jform_password2').type(`${user.newUser.password}`, {
      force: true,
    });
    cy.get('#jform_email').type(`${random}.${user.newUser.email}`, {
      force: true,
    });
    cy.contains('Save & Close').click();
    cy.contains('User saved');
    cy.contains('User Menu').click();
    cy.contains('Log out').click();

    cy.visit('/');
    cy.get("[name='username']").type(`${random}.${user.newUser.username}`);
    cy.get("[name='password']").type(`${user.newUser.password}`);
    cy.contains('Log in').click();
    cy.get('joomla-alert[type="warning"]').should('not.exist');
    cy.contains(`Hi ${user.newUser.name}`);
  });
});

it('allows creating an article and accessing it publicly', () => {
  cy.login();
  cy.visit('/administrator/index.php?option=com_content&view=articles');
  cy.get('.button-new').click();
  cy.fixture('articles').then((article) => {
    cy.get('#jform_title')
      .scrollIntoView()
      .type(`${article.newArticle.title} ${random}`, {
        force: true,
      });
    cy.contains('Content').click({ force: true });
    cy.get('.switcher > [id="jform_featured1"]').click({ force: true });
    cy.contains('Save').click();
    cy.contains('Article saved');
    cy.visit('/index.php');
    cy.contains(`${article.newArticle.title} ${random}`);
  });
});

it('allows updating an image', () => {
  cy.login();
  cy.visit('/administrator/index.php?option=com_media');
  cy.contains('Upload').click();
  cy.get('input[type="file"]').selectFile(
    'cypress/fixtures/images/post_image.png',
    { force: true }
  );
  cy.contains('Item uploaded');
});

it('checks plugin management and API operabilty', () => {
  cy.login();
  cy.contains('User Menu').click();
  cy.contains('Edit Account').click();
  cy.contains('API Token').click({ force: true });
  cy.get('#jform_joomlatoken_token')
    .invoke('attr', 'value')
    .then((APIToken) => {
      cy.request({
        method: 'GET',
        url: '/api/index.php/v1/banners/categories',
        form: true,
        auth: {
          bearer: APIToken,
        },
      }).then((response) => {
        expect(response.status).to.eq(200);
        expect(response.body).to.include.all.keys('links', 'data');
      });
    });
});
