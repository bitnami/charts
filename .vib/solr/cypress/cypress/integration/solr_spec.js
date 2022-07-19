/// <reference types="cypress" />
import { random, getBasicAuthHeader } from '../support/utils';

it('allows accessing the Dashboard', () => {
  cy.login();
  cy.visit('/solr/#/');
  cy.contains('Unauthorized').should('not.exist');

  cy.contains('solr-spec');
  cy.contains('JVM');
  cy.contains('solr.install.dir=/opt/bitnami/solr');
});

it('checks all nodes are up', () => {
  const NUMBER_OF_NODES = 3;
  cy.login();
  cy.visit('/solr/#/~cloud');

  cy.get('table#nodes-table').within(() => {
    cy.get('div[class*="host-name"]').should('have.length', NUMBER_OF_NODES);
  });
});

it('allows registering a user', () => {
  cy.login();
  cy.visit('/solr/#/~security');

  cy.fixture('users').then((users) => {
    cy.contains('button', 'Add User').click();
    cy.get('input#add_user').type(`${users.newUser.username}.${random}`);
    cy.get('input#add_user_password').type(users.newUser.password);
    cy.get('input#add_user_password2').type(users.newUser.password);
    cy.contains('button', 'Add User').click();
    cy.contains('td', `${users.newUser.username}.${random}`);
  });
});

/*
 * SolR does also offer the possibility of uploading a file via UI. Nevertheless,
 * Cypress seems to struggle setting the Content-Type header to application/json
 * and the server refuses to process a octet-stream object. Use the API instead.
 */
it('allows uploading and indexing a file', () => {
  cy.fixture('books').then(($books) => {
    const formData = new FormData();
    var content = new Blob([JSON.stringify($books)], {
      type: 'application/json',
    });
    formData.set('user-file', content, 'data.js');

    cy.request({
      url: '/solr/my-collection/update',
      qs: {
        commitWithin: 1000,
        overwrite: true,
        commit: true,
        wt: 'json',
      },
      method: 'POST',
      headers: {
        Authorization: getBasicAuthHeader(),
      },
      body: formData,
    })
      .its('status')
      .should('be.equal', 200);
  });
  cy.fixture('books').then(($books) => {
    // Get an arbitrary book from the collection
    var book = $books[Math.floor(Math.random() * $books.length)];
    cy.request({
      url: '/solr/my-collection/query',
      qs: {
        q: `title:${book.title}`,
        'q.op': 'OR',
        indent: true,
      },
      method: 'GET',
      headers: {
        Authorization: getBasicAuthHeader(),
      },
    }).then((response) => {
      var bodyString = JSON.stringify(response.body);
      expect(response.status).to.eq(200);
      expect(bodyString).to.contain(book.title);
      expect(bodyString).to.contain(book.author);
    });
  });
});

it('allows retrieving sample schema', () => {
  cy.request({
    url: '/solr/my-collection/schema',
    method: 'GET',
    headers: {
      Authorization: getBasicAuthHeader(),
    },
  }).then((response) => {
    var bodyString = JSON.stringify(response.body);
    expect(response.status).to.eq(200);
    expect(bodyString).to.contain('"name":"text_es"');
    expect(bodyString).to.contain('queryAnalyzer');
  });
});
