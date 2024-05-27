/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows to upload and execute a python notebook', () => {
  cy.session('test_upload', () => {
    const notebookName = `notebook_template_${random}.ipynb`;
    const userName = Cypress.env('username');

    cy.login();
    cy.visit(`/user/${userName}/tree/tmp`);
    cy.contains('Upload').should('be.visible');
    cy.get('[type=file]').selectFile('cypress/fixtures/notebook_template.ipynb', {
      force: true,
    });
    cy.get('.filename_input').clear().type(notebookName);
    cy.contains('button', 'Upload').click();
    cy.contains('a', notebookName);

    cy.visit(`/user/${userName}/notebooks/tmp/${notebookName}`);
    cy.contains('button', 'Run').click();
    cy.contains('Hello World!');
  });
});

it('allows generating an API token', () => {
  cy.session('test_token', () => {
    cy.login();
    cy.visit('/hub/token');
    // We need to wait until the background API request is finished
    cy.contains(/\d+Z/).should('not.exist');
    cy.contains('button', 'API token').click();
    cy.get('#token-result')
      .should('be.visible')
      .invoke('text')
      .then((apiToken) => {
        cy.request({
          url: '/hub/api/users',
          method: 'GET',
          headers: {
            Authorization: `token ${apiToken}`,
          },
        }).then((response) => {
          expect(response.status).to.eq(200);
          expect(response.body[0].name).to.eq(Cypress.env('username'));
        });
      });
  });
});
