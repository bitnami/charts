/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import body from '../fixtures/metric-body.json';
import {
  lastMinuteTimestamp,
  random
} from '../support/utils';

it('can push metrics and read them', () => {
  // Using Open Telemetry endpoint because it allow us to use plain connection.
  // Regular prometheus endpoint requires snappy compression.
  const orgID = { 'X-Scope-OrgID': 'demo' };
  const upToDateJson = JSON.stringify(body).replace(
    '"timestamp_placeholder"',
    lastMinuteTimestamp
  ).replace(
    '"integer_placeholder"',
    random
  );
  cy.request({
    method: 'POST',
    headers: orgID,
    url: '/otlp/v1/metrics',
    body: JSON.parse(upToDateJson),
  }).then((response) => {
    expect(response.status).to.eq(200);
  });
  // Read metrics
  cy.request({
    method: 'GET',
    headers: orgID,
    url: '/prometheus-test/api/v1/query?query=test',
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.headers['content-type']).to.eq(
      'application/json'
    );
    expect(response.body.data.result[0].value).to.contain(random);
  });
});
