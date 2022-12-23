/// <reference types="cypress" />
import {
  random,
  getPageUrlFromTitle,
  getUserFromEmail,
} from '../support/utils';

it('allows to log in and out', () => {
  cy.login();
  cy.get("div[class*='avatar']").click();
  cy.contains('Sign out').click();
  cy.contains('Sign in');
});

it('allows to create and publish a new post', () => {
  cy.login();
  cy.visit('/ghost/#/posts');
  cy.contains('New post').click();
  cy.get('input[type="file"]').selectFile(
    'cypress/fixtures/images/post_image.png',
    { force: true }
  );
  cy.fixture('posts').then(($posts) => {
    cy.get('textarea[placeholder="Post title"]').type(
      `${$posts.newPost.title}-${random}`
    );
    cy.get('article div[contenteditable="true"]').type(`${$posts.newPost.content}-${random}`, {force: true});
  });
  // Publishing a post needs 3 steps
  // Step 1: Open drop-down menu
  cy.contains('Publish').click();
  // Step 2: Select the option from the menu
  cy.get('div[class=gh-publish-cta]').within(() => {
    cy.contains('Continue').click();
  });
  // Step 3: Confirmation pop-up
  cy.get('div[class=gh-publish-cta]').within(() => {
    cy.contains('Publish').click();
  });
  cy.contains('It’s out there').should('be.visible');
  cy.visit('/');
  cy.fixture('posts').then(($posts) => {
    cy.contains(`${$posts.newPost.title}-${random}`);
    cy.get(`img[alt='${$posts.newPost.title}-${random}']`);
  });
});

it('allows to create a new page', () => {
  cy.login();
  cy.visit('/ghost/#/pages');
  cy.contains('New page').click();
  cy.fixture('pages').then(($pages) => {
    cy.get('textarea[placeholder="Page title"]').type(
      `${$pages.newPage.title}-${random}`
    );
    // Clicking a different element to trigger save event
    cy.get('article').click()
    cy.contains('div[class=gh-editor-post-status]', 'Saved');
    cy.get('article').type(`${$pages.newPage.content}-${random}`);
    // Ensure content has been saved before publishing
    cy.get('textarea[placeholder="Page title"]').click()
    cy.contains('div[class=gh-editor-post-status]', 'Saved');
  });
  // Publishing a page needs 3 steps
  // Step 1: Open drop down-menu
  cy.contains('Publish').click();
  // Step 2: Select the option from the menu
  cy.get('div[class=gh-publish-cta]').within(() => {
    cy.contains('Continue').click();
  });
  // Step 3: Confirmation pop-up
  cy.get('div[class=gh-publish-cta]').within(() => {
    cy.contains('Publish').click();
  });
  cy.contains('It’s out there').should('be.visible');
  cy.fixture('pages').then(($pages) => {
    cy.visit(getPageUrlFromTitle(`${$pages.newPage.title}-${random}`));
    cy.contains(`${$pages.newPage.title}-${random}`);
    cy.contains(`${$pages.newPage.content}-${random}`);
  });
});

it('allows to import members', () => {
  cy.login();
  cy.visit('/ghost/#/members/import');
  cy.contains('h1', 'Import members').should('be.visible');
  cy.get('input[type="file"]').selectFile('cypress/fixtures/members.csv', {
    force: true,
  });
  cy.contains('button', 'Import').click();
  cy.contains('Import complete');
  cy.visit('/ghost/#/members/');
  cy.fixture('members')
    .then(($rawMembers) => {
      // Get an arbitrary member from the collection
      let membersArray = $rawMembers.split('\n');
      membersArray.shift(); // Delete CSV column header
      return membersArray[Math.floor(Math.random() * membersArray.length)];
    })
    .then(($randomMember) => {
      const EMAIL_COLUMN_CSV = 1;
      cy.contains($randomMember.split(',')[EMAIL_COLUMN_CSV]);
    });
});

it('allows to change users settings', () => {
  cy.login();
  cy.visit(`/ghost/#/settings/staff/${getUserFromEmail()}`);
  cy.fixture('user-settings').then(($us) => {
    cy.get('input#user-name')
      .clear()
      .type(`${$us.admin.fullname}-${random}`, { force: true });
    cy.get('textarea#user-bio')
      .clear()
      .type(`${$us.admin.bio}-${random}`, { force: true });
    cy.contains('button', 'Save').click();

    cy.visit(`/author/${getUserFromEmail()}`);
    cy.contains(`${$us.admin.fullname}-${random}`);
    cy.contains(`${$us.admin.bio}-${random}`);
  });
});
