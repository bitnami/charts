/// <reference types="cypress" />
import {
  random,
} from '../support/utils';

it.only('allows to publish a tweet with an image', () => {
  cy.login();
  cy.get('[type="file"]').selectFile('cypress/fixtures/images/test_image.jpeg', {force: true});
  cy.fixture('tweets').then((tweet) => {
    // There is another hidden textarea so we need to use the *compose* class
    cy.get('[class*="compose"] textarea').type(`${tweet.text} ${random}`, {
      force: true,
    });
    cy.get('[type="submit"]').should('be.enabled').click();
    cy.get('.status-public').contains(`${tweet.text} ${random}`);
  });
  // The image will get renamed so we need to use a regex containing the media_attachments section
  // which will be the only element containing it
  cy.get('.media-gallery').first().click();
  cy.get('[src*="media_attachments"]');
});
