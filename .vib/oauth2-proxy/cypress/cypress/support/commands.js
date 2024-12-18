/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

const BASE_URL = 'http://vmware-oauth2-proxy.my';

// DEX is deployed at localhost:5556/dex/, which is not exposed (only port 80 is).
// A proxy pass in localhost/dex/ is configured to allow communication with it, but
// the UI keeps referring to the original 5556 port. This command allows to access
// DEX using the proxy path instead of the port.
Cypress.Commands.add(
  'safeRedirectVisit',
  (initialUrl, dexPort = Cypress.env('dexPort')) => {
    cy.request({
      url: `${BASE_URL}${initialUrl}`,
      followRedirect: false,
    }).then((req) => {
      const scopedRedirectedUrl = req.redirectedToUrl.replace(
        `:${dexPort}`,
        ''
      );
      cy.visit(scopedRedirectedUrl);
    });
  }
);