/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

export let random = (Math.random() + 1).toString(36).substring(7);

export let importAppStarters = () => {
  cy.visit('/dashboard');
  cy.fixture('imports').then((imports) => {
    for(let [key, importType] of Object.entries(imports)) {
      cy.contains('Add application').click();
      cy.contains('label', importType).click();
      cy.contains('Import Application(s)').click();
      cy.contains('Application(s) Imported');
    }
  });
};
