/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('can check cluster health', () => {
  cy.request({
    method: 'GET',
    url: '/',
    form: true,
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.body.status).to.contain('green');
  });
});
