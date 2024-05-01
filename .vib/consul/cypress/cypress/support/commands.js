/*
 * Copyright Broadcom, Inc. All Rights Reserved.
 * SPDX-License-Identifier: APACHE-2.0
 */

Cypress.on('uncaught:exception', (err, runnable) => {
  if (err.message.includes('Cannot read properties of undefined') ||
    err.message.includes('is not a function')) {
    return false;
  }
});
