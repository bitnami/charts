/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { getBasicAuthHeader } from '../support/utils';

it('checks initialized collection', () => {
  cy.login();
  cy.visit(`/solr/#/${Cypress.env('collection').name}/collection-overview`);

  cy.get('#shards').within(() => {
    cy.get('[class*="shard-title"]').should('have.length', Cypress.env('collection').shards);
    cy.get('[href*="solr-"]').should('have.length', Cypress.env('collection').shards * Cypress.env('collection').replicas);
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
      url: `/solr/${Cypress.env('collection').name}/update`,
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
      url: `/solr/${Cypress.env('collection').name}/query`,
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
    url: `/solr/${Cypress.env('collection').name}/schema`,
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
