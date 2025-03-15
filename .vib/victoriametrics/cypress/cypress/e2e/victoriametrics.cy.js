/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

// All tests use vmauth as the access

// This verifies that vmui and vmagent work
// vmagent pushes metrics, and we use vmui to query them
it('Access VMUI and check metric ingested by vmagent (access via vmauth)', () => {
  cy.visit('/select/0/vmui');
  cy.fixture('vmagent_metric').then((metric) => {
    cy.get('[inputmode="search"]').type(metric.name);
    cy.contains('Execute Query').click();
    cy.contains('JSON').click();
    cy.contains(metric.expectedResult);
  });
});

// This verifies that vminsert, vmselect and vmstorage work
// With vminsert we push a metric, which gets stored in vmstorage. Then it is
// queried using vmselect
it('Push metric using the vminsert API and then query using vmselect (all via vmauth)', () => {
  cy.fixture('ingest_metric').then((metric) => {
    // Metrics need to start with a letter
    const ingestPromQL = `a${random}${metric.ingestPromQL}`;
    const queryPromQL = `a${random}${metric.queryPromQL}`;
    cy.request({
      url: '/insert/0/prometheus/api/v1/import/prometheus',
      method: 'POST',
      body: ingestPromQL,
    })
      .its('status')
      .should('be.equal', 204)
      .then(() => {
        // It is not instantly available for querying, so we need to wait
        cy.wait(45000);
        cy.request({
          url: '/select/0/prometheus/api/v1/query',
          qs: {
            query: queryPromQL,
          },
          method: 'GET',
        }).then((response) => {
          const bodyString = JSON.stringify(response.body);
          expect(response.status).to.eq(200);
          expect(bodyString).to.contain(metric.expectedResult);
        });
      })
    }
  )
});
