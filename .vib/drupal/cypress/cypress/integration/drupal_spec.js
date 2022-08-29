/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows creating an article with an image', () => {
  cy.login();
  cy.visit('/node/add/article');
  cy.fixture('articles').then((article) => {
    cy.get('.text-full[name*=title]').type(`${article.newArticle.title} ${random}`);
    cy.get('iframe.cke_wysiwyg_frame').iframe().find('p').type(`${article.newArticle.text}`);
    cy.get('[type=file]').scrollIntoView();
    cy.get('[type=file]').selectFile('cypress/fixtures/images/test_image.jpeg', { force: true });
    cy.get('img').should('have.attr', 'src').and('contains', 'test_image');
    cy.get('input[id*="alt"]').type(`${article.newArticle.altText}`);
    cy.contains('Save').click();
    cy.visit('/admin/content');
    cy.contains(`${article.newArticle.title} ${random}`);
  })
});
