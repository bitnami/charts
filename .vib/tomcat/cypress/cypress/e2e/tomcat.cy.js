/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows to deploy a new WAR app', () => {
  cy.visitAuth(`/manager`);
  cy.contains('form', 'Select WAR file').within(() => {
    cy.get('[type="file"]').selectFile({
      contents: 'cypress/fixtures/sample.war',
      fileName: `sample${random}.war`,
    });
    cy.contains('Deploy').click();
  });
  cy.contains(`/sample${random}`).click();
  cy.contains('Hello, World');
});
