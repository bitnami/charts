/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

export let random = (Math.random() + 1).toString(36).substring(7);

export let allowDataUsage = () => {
  cy.get('body').then(($body) => {
    if ($body.find('[class="admin__fieldset"]').is(':visible')) {
      cy.contains('.action-primary', 'Allow').click({ force: true });
    }
  });
};
