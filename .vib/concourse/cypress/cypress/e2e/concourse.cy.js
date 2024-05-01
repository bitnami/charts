/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

/// <reference types="cypress" />

it('renders landing page correctly', () => {
  // The asset currently presents some incompatibilities when enabling HTTPs, which
  // prevent from running the login process via the UI. Although this functionality
  // might be interesting to implement when the issue is addressed, it is already
  // being tested in GOSS.

  // The UI is just an alternative to the CLI to interact with Concourse. Main functionality
  // is already covered in GOSS, so these tests should be kept to a minimum.
  cy.visit('/');
  cy.contains('welcome to concourse');
});
