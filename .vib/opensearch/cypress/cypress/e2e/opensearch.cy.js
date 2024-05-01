/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';
import body from '../fixtures/documents.json';

it('can check cluster health', () => {
  cy.request({
    method: 'GET',
    url: '/_cluster/health',
    form: true,
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.body.status).to.contain('green');
    expect(response.body.number_of_nodes).to.eq(Cypress.env('nodeNumber'));
  });
});

it('can index a search and retrieve it', () => {
  cy.request({
    method: 'PUT',
    url: 'favorite_candy' + random,
    form: true,
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.body.acknowledged).to.eq(true);
    expect(response.body.shards_acknowledged).to.eq(true);
    expect(response.body.index).to.eq(`favorite_candy${random}`);
  });

  cy.request({
    method: 'GET',
    url: 'favorite_candy' + random,
    form: true,
  }).then((response) => {
    expect(response.status).to.eq(200);
  });
});

it('can index a document and retrieve it', () => {
  cy.request({
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=utf-8' },
    url: `favorite_dj/_create/${random}`,
    body: body,
  }).then((response) => {
    expect(response.status).to.eq(201);
    expect(response.body._index).to.eq('favorite_dj');
    expect(response.body.result).to.eq('created');
  });

  cy.request({
    method: 'GET',
    url: 'favorite_dj/_source/' + random,
    form: true,
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.body.name).to.eq(body.name);
    expect(response.body.origin).to.eq(body.origin);
  });
});
