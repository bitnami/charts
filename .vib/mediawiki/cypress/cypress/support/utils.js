/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

export let random = (Math.random() + 1).toString(36).substring(7);

export const getPageUrlFromTitle = (title) => {
  return '/wiki/'.concat(title.replace(' ', '_'));
};

// Sometimes, you get redirected to a log out confirmation page
export const confirmLogOut = () => {
  cy.get("body").then(($body) => {
      if ($body.text().includes('Do you want to log out')) {
        cy.contains('button', 'Submit').click();
      }
  })
}
