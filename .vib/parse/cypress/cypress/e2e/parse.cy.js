/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';
import highScoreStats from '../fixtures/high_score_stats.json';

it('allows store and retrieve a new object', () => {
  const NEW_CLASS_NAME = `BitnamiClass${random}`;
  const AUTH_HEADERS = {
    'X-Parse-Application-Id': Cypress.env('appId'),
    'X-Parse-Master-Key': Cypress.env('masterKey'),
  };

  cy.request({
    method: 'POST',
    url: `/parse/classes/${NEW_CLASS_NAME}`,
    headers: AUTH_HEADERS,
    body: highScoreStats,
  }).then((response) => {
    expect(response.status).to.eq(201);
    expect(response.body).to.include.keys(['objectId']);

    cy.request({
      method: 'GET',
      url: `/parse/classes/${NEW_CLASS_NAME}/${response.body.objectId}`,
      headers: AUTH_HEADERS,
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body).to.contain(highScoreStats);
    });
  });
});
