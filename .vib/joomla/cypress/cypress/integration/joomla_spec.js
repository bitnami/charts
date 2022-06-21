/// <reference types="cypress" />
import { random } from './utils';

it('allows user to log in and log out', () => {
  cy.login();
  cy.contains('Username and password do not match').should('not.exist');
  cy.contains('User Menu').click();
  cy.contains('Log out').click();
  cy.get("[name='username']");
});

it('allows creating an article', () => {
  cy.login();
  cy.visit('/administrator/index.php?option=com_content&view=articles');
  cy.get('.button-new').click();
  cy.fixture('articles').then((article) => {
    cy.get('#jform_title')
      .scrollIntoView()
      .type(`${article.newArticle.title} ${random}`, {
        force: true,
      });
  });
  cy.contains('Save & Close').click();
  cy.contains('Article saved');
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

it('allows modifying site settings', () => {
  cy.login();
  cy.visit('/administrator/index.php?option=com_config');
  cy.fixture('site-settings').then((siteSettings) => {
    cy.get('#jform_sitename')
      .scrollIntoView()
      .clear({ force: true })
      .type(`${siteSettings.newSiteSetting.sitename} ${random}`);
  });
  cy.contains('Save & Close').click();
  cy.contains('Configuration saved');
});

it('checks plugin management and API operabilty', () => {
  cy.login();
  cy.contains('User Menu').click();
  cy.contains('Edit Account').click();
  cy.contains('API Token').click({ force: true });
  cy.get('#jform_joomlatoken_token')
    .invoke('attr', 'value')
    .as('APIToken')
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
