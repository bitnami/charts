/*
 * Copyright VMware, Inc.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />
import { random } from '../support/utils';

it('allows to upload and view a new Report', () => {
  cy.login();
  cy.visit('/jasperserver/flow.html?_flowId=reportUnitFlow&ParentFolderUri=/');

  cy.fixture('reports').then((reports) => {
    const reportFile = `cypress/fixtures/${reports.newReport.file}`;
    cy.readFile(reportFile).then((data) => {
      const regex = new RegExp(
        `${reports.newReport.textToRandomize}[a-z0-9_]*`
      );
      const randomizedData = data.replace(
        regex,
        `${reports.newReport.textToRandomize}${random}`
      );
      cy.writeFile(reportFile, randomizedData);
    });

    cy.get('[name="reportUnit.label"]')
      .click()
      .type(`${reports.newReport.name}_${random}`);
    cy.get('#fromLocal').click();
    cy.get('[type="file"]').selectFile(reportFile, { force: true });
    cy.contains('Submit').click();
    // Wait for DOM content to load
    cy.wait(5000);
    cy.contains('#resultsContainer p.resourceName', `${reports.newReport.name}_${random}`).click();
    cy.contains(`${reports.newReport.textToRandomize}${random}`);
  });
});
