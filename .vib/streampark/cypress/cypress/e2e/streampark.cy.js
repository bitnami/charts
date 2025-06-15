// Copyright Broadcom, Inc. All Rights Reserved.
// SPDX-License-Identifier: APACHE-2.0

it('passes', () => {
  cy.visit('/')
  /* ==== Generated with Cypress Studio ==== */
  cy.get('#form_item_account').clear('ad');
  cy.get('#form_item_account').type('admin');
  cy.get('#form_item_password').clear();
  cy.get('#form_item_password').type('streampark');
  cy.get(':nth-child(3) > .ant-col > .ant-form-item-control-input > .ant-form-item-control-input-content > .ant-btn > span').click();
  /* ==== End Cypress Studio ==== */
});
