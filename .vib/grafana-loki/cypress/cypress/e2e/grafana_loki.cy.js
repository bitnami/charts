/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import body from '../fixtures/logs-body.json';
import { lastMinuteTimestamp } from '../support/utils';

it('checks Loki range endpoint', () => {
  cy.request({
    method: 'GET',
    url: 'loki/api/v1/query?query={job="varlogs"}',
    form: true,
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.headers['content-type'].toLowerCase()).to.eq(
      'application/json; charset=utf-8'
    );
    expect(response.body.data.stats.summary).not.to.be.empty;
    expect(response.body.data.stats).to.include.all.keys(
      'summary',
      'querier',
      'ingester'
    );
  });
});

it('can publish and retrieve a label', () => {
  // Per configuration, Loki rejects timestamps older than 168h
  const upToDateJson = JSON.stringify(body).replace(
    'timestamp_placeholder',
    lastMinuteTimestamp
  );
  cy.request({
    method: 'POST',
    headers: { 'Content-Type': 'application/json; charset=utf-8' },
    url: 'loki/api/v1/push',
    body: JSON.parse(upToDateJson),
  }).then((response) => {
    expect(response.status).to.eq(204);
  });

  cy.request({
    method: 'GET',
    url: 'loki/api/v1/label/label/values',
    form: true,
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.body.data).to.contain('value');
  });
});
