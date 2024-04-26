/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import {
  random
} from '../support/utils';

/*
  Out of the possible components, these are the ones that can be tested without
  having to create a full Supabase development project. Here we check

     - The Authorization service: checking that we can create a user
     - The Postgres Meta service: checking that we can interact with the database
     - The Storage service: checking that we can create a bucket
*/

it('can create a user and generate a token to it (auth)', () => {
  // Source: https://github.com/netlify/gotrue
  cy.fixture('users').then((users) => {
    const userPayload = {
      email: `${random}${users.newUser.email}`,
      password: `${users.newUser.password}-${random}`,
    };
    cy.request({
      method: 'POST',
      headers: { apikey: Cypress.env('serviceKey') },
      url: '/auth/v1/signup',
      body: userPayload,
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(JSON.stringify(response.body)).to.have.string(userPayload.email);
    });

    cy.request({
      method: 'POST',
      headers: { apikey: Cypress.env('serviceKey') },
      // This one works with URL parameters, not with a body
      url: '/auth/v1/token',
      body: userPayload,
      qs: {
        grant_type: 'password',
      },
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(JSON.stringify(response.body)).to.have.string('access_token');
    });
  });
});

it('can create a schema and it appears on the list of schemas (meta)', () => {
  // Source: https://supabase.github.io/postgres-meta/
  cy.fixture('schemas').then((schemas) => {
    const schemaPayload = {
      name: `${schemas.newSchema.name}${random}`,
      owner: schemas.newSchema.owner,
    };
    cy.request({
      method: 'POST',
      headers: { apikey: Cypress.env('serviceKey') },
      url: '/pg/schemas',
      body: schemaPayload,
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(JSON.stringify(response.body)).to.have.string(schemaPayload.name);
    });

    cy.request({
      method: 'GET',
      headers: { apikey: Cypress.env('serviceKey') },
      url: '/pg/schemas',
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(JSON.stringify(response.body)).to.have.string(schemaPayload.name);
    });
  });
});

it('can create a bucket and upload a file (storage)', () => {
  // Source: https://github.com/supabase/storage-api
  cy.fixture('buckets').then((buckets) => {
    const bucketPayload = {
      id: `${buckets.newBucket.name}${random}`,
      name: `${buckets.newBucket.name}${random}`,
      public: buckets.newBucket.public,
    };
    cy.request({
      method: 'POST',
      headers: {
        apikey: Cypress.env('serviceKey'),
        Authorization: `Bearer ${Cypress.env('serviceKey')}`,
      },
      url: '/storage/v1/bucket',
      body: bucketPayload,
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(JSON.stringify(response.body)).to.have.string(bucketPayload.id);
    });

    cy.request({
      method: 'GET',
      headers: {
        apikey: Cypress.env('serviceKey'),
        Authorization: `Bearer ${Cypress.env('serviceKey')}`,
      },
      url: '/storage/v1/bucket',
      body: bucketPayload,
    }).then((response) => {
      expect(response.status).to.eq(200);
      expect(JSON.stringify(response.body)).to.have.string(bucketPayload.id);
    });

    cy.fixture('files').then((files) => {
      const filePayload = {
        name: `${files.newFile.name}${random}`,
        content: `${random}_${files.newFile.content}`,
      };
      cy.request({
        method: 'POST',
        headers: {
          apikey: Cypress.env('serviceKey'),
          Authorization: `Bearer ${Cypress.env('serviceKey')}`,
        },
        url: `/storage/v1/object/${bucketPayload.id}/${filePayload.name}`,
        body: filePayload.content,
      }).then((response) => {
        expect(response.status).to.eq(200);
        expect(JSON.stringify(response.body)).to.have.string(`${bucketPayload.id}/${filePayload.name}`);
      });

      cy.request({
        method: 'GET',
        headers: {
          apikey: Cypress.env('serviceKey'),
          Authorization: `Bearer ${Cypress.env('serviceKey')}`,
        },
        url: `/storage/v1/object/${bucketPayload.id}/${filePayload.name}`,
      }).then((response) => {
        expect(response.status).to.eq(200);
        expect(JSON.stringify(response.body)).to.have.string(filePayload.content);
      });
    });
  });
});
