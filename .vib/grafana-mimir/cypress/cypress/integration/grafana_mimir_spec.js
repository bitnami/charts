/// <reference types="cypress" />
import body from '../fixtures/metric-body.json';
import {
  lastMinuteTimestamp,
  random
} from '../support/utils';

it('can push metrics', () => {
  // Using Open Telemetry endpoint because it allow us to use plain connection.
  // Regular prometheus endpoint requires snappy compression.
  const upToDateJson = JSON.stringify(body).replace(
    '"timestamp_placeholder"',
    lastMinuteTimestamp
  ).replace(
    '"integer_placeholder"',
    random
  );
  cy.request({
    method: 'POST',
    headers: { 'X-Scope-OrgID': 'demo' },
    url: '/otlp/v1/metrics',
    body: JSON.parse(upToDateJson),
  }).then((response) => {
    expect(response.status).to.eq(200);
  });
});

it('can read metrics', () => {
  cy.request({
    method: 'GET',
    headers: {'X-Scope-OrgID': 'demo' },
    url: `/prometheus/api/v1/query?query=test`,
    form: false,
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.headers['content-type']).to.eq(
      'application/json'
    );
  expect(response.body.data.result[0].value).to.contain(`${random}`);
  });
});
