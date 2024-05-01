/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import body from '../fixtures/schema.json';

it('can access the API and obtain global compatibility level', () => {
  cy.request({
    method: 'GET',
    url: '/config',
    form: true,
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.body.compatibilityLevel).to.contain(Cypress.env('compatibilityLevel'));
  });
});

it('can create a new schema and subject', () => {
  const newSubject = 'test';
  cy.request({
    method: 'POST',
    headers: { 'Content-Type': 'application/vnd.schemaregistry.v1+json' },
    url: `/subjects/${newSubject}/versions`,
    body: body,
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.body.id).to.eq(1);
  });

  cy.request({
    method: 'GET',
    url: '/subjects',
    form: true,
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.body).to.have.length(1);
    expect(response.body).to.include(newSubject);
  });
});
