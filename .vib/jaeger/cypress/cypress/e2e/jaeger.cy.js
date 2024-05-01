/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('lists and retrieves jaeger traces', () => {

  // The container we use to create traces, uses 'frontend' as a service name
  const testService = 'frontend';
  const currentDate = new Date();
  const timestampMillis = currentDate.getTime() * 1000;

  cy.visit(`/search?end=${timestampMillis}&limit=20&lookback=1h&maxDuration&minDuration&service=${testService}&start=0`);

  cy.contains('a', '/dispatch').invoke('attr', 'href').then((href) => {
    const traceID = href.substring(href.lastIndexOf('/') + 1, href.length);

    cy.request({
      method: 'GET',
      url: `/api/traces/${traceID}`
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body.data[0].traceID).to.eq(traceID);
    });
  })
});
