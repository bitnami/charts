/// <reference types="cypress" />

it('can check metrics endpoint', () => {
  cy.request({
    method: 'GET',
    url: '/metrics',
    form: true,
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.body).to.contain('external_dns_registry_a_records');
  });
});
