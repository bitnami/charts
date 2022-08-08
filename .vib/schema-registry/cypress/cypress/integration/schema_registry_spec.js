/// <reference types="cypress" />
import { body } from '../fixtures/schema.json';

it('can access the API and obtain global compatibility level', () => {
  cy.fixture('config').then((config) => {
    cy.request({
      method: 'GET',
      url: '/config',
      form: true,
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(response.body.compatibilityLevel).to.contain(config.compatibilityLevel);
    });
  });
});

it('can access the API and create a new schema in the "test" subject', () => {
  cy.request({
    method: 'POST',
    headers: { 'Content-Type': 'application/vnd.schemaregistry.v1+json' },
    url: 'subjects/test/versions',
    body: body,
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.body.id).to.eq(1);
  });

  cy.request({
    method: 'GET',
    url: 'subjects',
    form: true,
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.body).to.have.length(1);
    expect(response.body).to.include('test');
  });
});
